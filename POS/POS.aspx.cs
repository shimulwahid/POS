using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace POS
{
    public partial class POS : Page
    {
        private string ConnectionString { get { return ConfigurationManager.ConnectionStrings["POSDatabase"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) { InitCart(); LoadProducts(); BindCart(); }
        }

        private void InitCart()
        {
            if (Session["Cart"] != null) return;
            var cart = new DataTable();
            cart.Columns.Add("ProductId", typeof(int));
            cart.Columns.Add("Product_Name", typeof(string));
            cart.Columns.Add("ProductCode", typeof(string));
            cart.Columns.Add("Barcode", typeof(string));
            cart.Columns.Add("Qty", typeof(decimal));
            cart.Columns.Add("Price", typeof(decimal));
            cart.Columns.Add("Total", typeof(decimal));
            cart.PrimaryKey = new[] { cart.Columns["ProductId"] };
            Session["Cart"] = cart;
        }

        private DataTable Cart { get { InitCart(); return (DataTable)Session["Cart"]; } }

        private void LoadProducts()
        {
            using (var con = new SqlConnection(ConnectionString))
            using (var da = new SqlDataAdapter(@"SELECT ser, Product_Name, Product_code, Barcode_No, Unit_Price, Stock
                                                 FROM Product_TBL ORDER BY Product_Name", con))
            {
                var products = new DataTable();
                da.Fill(products);
                gvProducts.DataSource = products;
                gvProducts.DataBind();
            }
        }

        protected void btnScan_Click(object sender, EventArgs e)
        {
            string barcode = txtBarcode.Text.Trim();
            txtBarcode.Text = string.Empty;
            if (barcode.Length == 0) { ShowMessage("Scan or enter a barcode first.", false); return; }

            int id;
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(@"SELECT TOP 1 ser FROM Product_TBL
                                              WHERE Barcode_No = @value OR Product_code = @value", con))
            {
                cmd.Parameters.Add("@value", SqlDbType.NVarChar, 100).Value = barcode;
                con.Open();
                object found = cmd.ExecuteScalar();
                if (found == null) { ShowMessage("No product matches barcode/code: " + barcode, false); return; }
                id = Convert.ToInt32(found);
            }
            AddToCart(id);
        }

        protected void gvProducts_PreRender(object sender, EventArgs e)
        {
            if (gvProducts.Rows.Count > 0) { gvProducts.UseAccessibleHeader = true; gvProducts.HeaderRow.TableSection = TableRowSection.TableHeader; }
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart") AddToCart(Convert.ToInt32(e.CommandArgument));
        }

        private void AddToCart(int productId)
        {
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(@"SELECT Product_Name, Product_code, Barcode_No, Unit_Price, Stock
                                              FROM Product_TBL WHERE ser = @id", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = productId;
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.Read()) { ShowMessage("Product was not found.", false); return; }
                    DataRow existing = Cart.Rows.Find(productId);
                    decimal stock = Convert.ToDecimal(reader["Stock"]);
                    if (stock < 1) { ShowMessage("Not enough stock for " + reader["Product_Name"] + ".", false); return; }

                    decimal price = Convert.ToDecimal(reader["Unit_Price"]);
                    if (!ChangeReservedStock(productId, 1m)) { ShowMessage("This item is out of stock.", false); return; }
                    if (existing == null)
                    {
                        var row = Cart.NewRow();
                        row["ProductId"] = productId; row["Product_Name"] = reader["Product_Name"].ToString();
                        row["ProductCode"] = reader["Product_code"].ToString(); row["Barcode"] = reader["Barcode_No"].ToString();
                        row["Qty"] = 1m; row["Price"] = price; row["Total"] = price; Cart.Rows.Add(row);
                    }
                    else
                    {
                        decimal newQty = Convert.ToDecimal(existing["Qty"]) + 1m;
                        existing["Qty"] = newQty; existing["Total"] = newQty * price;
                    }
                }
            }
            BindCart();
            LoadProducts();
        }

        protected void txtQty_TextChanged(object sender, EventArgs e)
        {
            var box = (TextBox)sender;
            var gridRow = (GridViewRow)box.NamingContainer;
            int id = Convert.ToInt32(gvCart.DataKeys[gridRow.RowIndex].Value);
            decimal qty;
            if (!TryMoney(box.Text, out qty) || qty <= 0) { ShowMessage("Quantity must be greater than zero.", false); BindCart(); return; }

            DataRow row = Cart.Rows.Find(id);
            decimal oldQty = Convert.ToDecimal(row["Qty"]);
            decimal difference = qty - oldQty;
            if (difference != 0 && !ChangeReservedStock(id, difference)) { ShowMessage("Quantity exceeds available stock.", false); BindCart(); return; }
            row["Qty"] = qty; row["Total"] = qty * Convert.ToDecimal(row["Price"]); BindCart(); LoadProducts();
        }

        protected void gvCart_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            DataRow row = Cart.Rows.Find(id);
            if (row == null) return;
            decimal qty = Convert.ToDecimal(row["Qty"]);
            if (e.CommandName == "IncreaseQty")
            {
                if (!ChangeReservedStock(id, 1m)) { ShowMessage("No more stock is available for this item.", false); return; }
                row["Qty"] = qty + 1m; row["Total"] = Convert.ToDecimal(row["Qty"]) * Convert.ToDecimal(row["Price"]);
            }
            else if (e.CommandName == "DecreaseQty")
            {
                if (qty <= 1m) { ChangeReservedStock(id, -qty); Cart.Rows.Remove(row); }
                else { ChangeReservedStock(id, -1m); row["Qty"] = qty - 1m; row["Total"] = Convert.ToDecimal(row["Qty"]) * Convert.ToDecimal(row["Price"]); }
            }
            else if (e.CommandName == "RemoveItem") { ChangeReservedStock(id, -qty); Cart.Rows.Remove(row); }
            else return;
            BindCart();
            LoadProducts();
        }

        // A positive quantity reserves stock; a negative quantity returns it.
        private bool ChangeReservedStock(int productId, decimal quantity)
        {
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(quantity > 0
                ? "UPDATE Product_TBL SET Stock=Stock-@qty WHERE ser=@id AND Stock>=@qty"
                : "UPDATE Product_TBL SET Stock=Stock+@qty WHERE ser=@id", con))
            {
                cmd.Parameters.Add("@qty", SqlDbType.Decimal).Value = Math.Abs(quantity);
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = productId;
                con.Open();
                return cmd.ExecuteNonQuery() == 1;
            }
        }

        protected void btnCancelCart_Click(object sender, EventArgs e)
        {
            using (var con = new SqlConnection(ConnectionString))
            {
                con.Open();
                using (var tx = con.BeginTransaction())
                {
                    try
                    {
                        foreach (DataRow row in Cart.Rows)
                        using (var cmd = new SqlCommand("UPDATE Product_TBL SET Stock=Stock+@qty WHERE ser=@id", con, tx))
                        { cmd.Parameters.Add("@qty", SqlDbType.Decimal).Value=row["Qty"]; cmd.Parameters.Add("@id",SqlDbType.Int).Value=row["ProductId"]; cmd.ExecuteNonQuery(); }
                        tx.Commit();
                    }
                    catch { tx.Rollback(); throw; }
                }
            }
            Session["Cart"] = null; InitCart(); txtDiscount.Text="0"; txtAmountPaid.Text=""; txtAmountReturn.Text="0.00"; BindCart(); LoadProducts();
            ShowMessage("Sale cancelled and reserved stock returned.", true);
        }

        protected void txtDiscount_TextChanged(object sender, EventArgs e) { CalculateTotals(); }

        private void BindCart() { gvCart.DataSource = Cart; gvCart.DataBind(); CalculateTotals(); }

        private void CalculateTotals()
        {
            decimal subtotal = 0;
            foreach (DataRow row in Cart.Rows) subtotal += Convert.ToDecimal(row["Total"]);
            decimal discount;
            if (!TryMoney(txtDiscount.Text, out discount) || discount < 0) discount = 0;
            if (discount > subtotal) discount = subtotal;
            txtDiscount.Text = discount.ToString("0.00");
            lblSubtotal.Text = subtotal.ToString("0.00");
            lblGrandTotal.Text = (subtotal - discount).ToString("0.00");
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            if (Cart.Rows.Count == 0) { ShowMessage("Add at least one product before checkout.", false); return; }
            decimal subtotal = 0; foreach (DataRow row in Cart.Rows) subtotal += Convert.ToDecimal(row["Total"]);
            decimal discount; if (!TryMoney(txtDiscount.Text, out discount) || discount < 0 || discount > subtotal) { ShowMessage("Enter a valid discount.", false); return; }
            decimal total = subtotal - discount;
            decimal paid;
            if (!TryMoney(txtAmountPaid.Text, out paid)) paid = ddlPaymentMethod.SelectedValue == "Cash" ? 0 : total;
            if (paid < total) { ShowMessage("Amount received cannot be less than the grand total.", false); return; }
            txtAmountReturn.Text = ddlPaymentMethod.SelectedValue == "Cash" ? (paid - total).ToString("0.00") : "0.00";

            int orderNo;
            try
            {
                using (var con = new SqlConnection(ConnectionString))
                { con.Open(); using (var tx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        EnsureSalesTable(con, tx);
                        using (var lockCmd = new SqlCommand("EXEC sp_getapplock @Resource='POS_OrderNumber', @LockMode='Exclusive', @LockOwner='Transaction'", con, tx)) lockCmd.ExecuteNonQuery();
                        using (var numberCmd = new SqlCommand("SELECT ISNULL(MAX(Order_No),0)+1 FROM Sale_history WITH (UPDLOCK,HOLDLOCK)", con, tx)) orderNo = Convert.ToInt32(numberCmd.ExecuteScalar());

                        foreach (DataRow row in Cart.Rows)
                        {
                            using (var itemCmd = new SqlCommand(@"INSERT INTO Sale_history
                                (Order_no,Product_code,Product_Name,Qty,Unit_Price,Total_Price,Barcode)
                                VALUES(@order,@code,@name,@qty,@price,@total,@barcode)", con, tx))
                            { itemCmd.Parameters.Add("@order", SqlDbType.Int).Value = orderNo; itemCmd.Parameters.Add("@code", SqlDbType.NVarChar,100).Value = row["ProductCode"];
                              itemCmd.Parameters.Add("@name", SqlDbType.NVarChar,200).Value = row["Product_Name"]; itemCmd.Parameters.Add("@qty", SqlDbType.Decimal).Value = row["Qty"];
                              itemCmd.Parameters.Add("@price", SqlDbType.Decimal).Value = row["Price"]; itemCmd.Parameters.Add("@total", SqlDbType.Decimal).Value = row["Total"];
                              itemCmd.Parameters.Add("@barcode", SqlDbType.NVarChar,100).Value = row["Barcode"]; itemCmd.ExecuteNonQuery(); }
                        }
                        using (var saleCmd = new SqlCommand(@"INSERT INTO Sales
                            (Order_No,Sale_Date,Subtotal,Discount,Grand_Total,Payment_Method,Amount_Paid,Change_Amount,Payment_Reference)
                            VALUES(@order,GETDATE(),@subtotal,@discount,@total,@method,@paid,@change,@reference)", con, tx))
                        { saleCmd.Parameters.Add("@order", SqlDbType.Int).Value=orderNo; saleCmd.Parameters.Add("@subtotal", SqlDbType.Decimal).Value=subtotal;
                          saleCmd.Parameters.Add("@discount", SqlDbType.Decimal).Value=discount; saleCmd.Parameters.Add("@total", SqlDbType.Decimal).Value=total;
                          saleCmd.Parameters.Add("@method", SqlDbType.NVarChar,30).Value=ddlPaymentMethod.SelectedValue; saleCmd.Parameters.Add("@paid", SqlDbType.Decimal).Value=paid;
                          saleCmd.Parameters.Add("@change", SqlDbType.Decimal).Value=paid-total; saleCmd.Parameters.Add("@reference", SqlDbType.NVarChar,100).Value=string.IsNullOrWhiteSpace(txtPaymentReference.Text) ? (object)DBNull.Value : txtPaymentReference.Text.Trim(); saleCmd.ExecuteNonQuery(); }
                        tx.Commit();
                    }
                }
            }
            catch (Exception ex) { ShowMessage(HttpUtility.HtmlEncode(ex.Message), false); return; }

            Session["Cart"] = null;
            Response.Redirect("Receipt.aspx?order=" + orderNo + "&print=1", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private static void EnsureSalesTable(SqlConnection con, SqlTransaction tx)
        {
            const string sql = @"IF OBJECT_ID('dbo.Sales','U') IS NULL CREATE TABLE dbo.Sales(
                Sale_ID INT IDENTITY(1,1) PRIMARY KEY, Order_No INT NOT NULL UNIQUE, Sale_Date DATETIME NOT NULL,
                Subtotal DECIMAL(18,2) NOT NULL, Discount DECIMAL(18,2) NOT NULL, Grand_Total DECIMAL(18,2) NOT NULL,
                Payment_Method NVARCHAR(30) NOT NULL, Amount_Paid DECIMAL(18,2) NOT NULL, Change_Amount DECIMAL(18,2) NOT NULL,
                Payment_Reference NVARCHAR(100) NULL);";
            using (var cmd = new SqlCommand(sql, con, tx)) cmd.ExecuteNonQuery();
        }

        private static bool TryMoney(string text, out decimal value)
        { return decimal.TryParse(text, NumberStyles.Number, CultureInfo.CurrentCulture, out value) || decimal.TryParse(text, NumberStyles.Number, CultureInfo.InvariantCulture, out value); }

        private void ShowMessage(string message, bool success)
        { pnlMessage.Visible = true; pnlMessage.CssClass = "alert " + (success ? "alert-success" : "alert-danger"); litMessage.Text = message; }
    }
}
