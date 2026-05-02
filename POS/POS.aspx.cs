using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace POS
{
    public partial class POS : System.Web.UI.Page
    {
        string cs = "Data Source=DESKTOP-G0J1RC1\\SQL17;Initial Catalog=POS;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts();
                InitCart();
            }
        }

        private void InitCart()
        {
            if (Session["Cart"] == null)
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("ProductId");
                dt.Columns.Add("Product_Name");
                dt.Columns.Add("Qty", typeof(decimal));
                dt.Columns.Add("Price", typeof(decimal));
                dt.Columns.Add("Total", typeof(decimal));

                Session["Cart"] = dt;
            }
        }

        private void LoadProducts(string keyword = "")
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT * FROM Product_TBL";

                if (!string.IsNullOrEmpty(keyword))
                {
                    query += @" WHERE 
                        Product_Name LIKE @key OR 
                        Product_Code LIKE @key OR 
                        Barcode_No LIKE @key OR 
                        ser LIKE @key";
                }

                SqlDataAdapter da = new SqlDataAdapter(query, con);

                if (!string.IsNullOrEmpty(keyword))
                {
                    da.SelectCommand.Parameters.AddWithValue("@key", "%" + keyword + "%");
                }

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvProducts.DataSource = dt;
                gvProducts.DataBind();
            }
        }
        protected void txtQty_TextChanged(object sender, EventArgs e)
        {
            TextBox txt = (TextBox)sender;
            GridViewRow row = (GridViewRow)txt.NamingContainer;

            int productId = Convert.ToInt32(gvCart.DataKeys[row.RowIndex].Value);

            decimal qty;
            if (!decimal.TryParse(txt.Text, out qty))
                qty = 1;

            if (qty <= 0)
                qty = 1;

            DataTable cart = (DataTable)Session["Cart"];

            DataRow[] rows = cart.Select("ProductId=" + productId);

            if (rows.Length > 0)
            {
                decimal price = Convert.ToDecimal(rows[0]["Price"]);

                rows[0]["Qty"] = qty;
                rows[0]["Total"] = qty * price;
            }

            Session["Cart"] = cart;
            BindCart();
        }

        protected void gvProducts_PreRender(object sender, EventArgs e)
        {
            if (gvProducts.Rows.Count > 0)
            {
                gvProducts.UseAccessibleHeader = true;
                gvProducts.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }
        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                AddToCart(productId);
            }
        }

        private void AddToCart(int productId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Product_TBL WHERE ser=@id", con);
                cmd.Parameters.AddWithValue("@id", productId);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    DataTable cart = (DataTable)Session["Cart"];

                    string name = dr["Product_Name"].ToString();
                    decimal price = Convert.ToDecimal(dr["Unit_Price"]);

                    DataRow[] existing = cart.Select("ProductId=" + productId);

                    if (existing.Length > 0)
                    {
                        existing[0]["Qty"] = Convert.ToInt32(existing[0]["Qty"]) + 1;
                        existing[0]["Total"] = Convert.ToInt32(existing[0]["Qty"]) * price;
                    }
                    else
                    {
                        DataRow row = cart.NewRow();
                        row["ProductId"] = productId;
                        row["Product_Name"] = name;
                        row["Qty"] = 1;
                        row["Price"] = price;
                        row["Total"] = price;

                        cart.Rows.Add(row);
                    }

                    Session["Cart"] = cart;
                    BindCart();
                }
            }
        }

        private void BindCart()
        {
            DataTable cart = (DataTable)Session["Cart"];
            gvCart.DataSource = cart;
            gvCart.DataBind();

            CalculateTotals();
        }
        protected void gvCart_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RemoveItem")
            {
                int productId = Convert.ToInt32(e.CommandArgument);

                DataTable cart = (DataTable)Session["Cart"];

                DataRow[] rows = cart.Select("ProductId=" + productId);

                foreach (DataRow row in rows)
                {
                    cart.Rows.Remove(row);
                }

                Session["Cart"] = cart;
                BindCart();
            }
        }
        private void CalculateTotals()
        {
            DataTable cart = (DataTable)Session["Cart"];
            decimal subtotal = 0;

            foreach (DataRow row in cart.Rows)
            {
                subtotal += Convert.ToDecimal(row["Total"]);
            }

            lblSubtotal.Text = subtotal.ToString("0.00");

            decimal discount = 0;
            decimal.TryParse(txtDiscount.Text, out discount);

            decimal grand = subtotal - discount;
            lblGrandTotal.Text = grand.ToString("0.00");
        }

        protected void txtDiscount_TextChanged(object sender, EventArgs e)
        {
            CalculateTotals();
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            DataTable cart = (DataTable)Session["Cart"];

            if (cart.Rows.Count == 0) return;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlTransaction trans = con.BeginTransaction();

                try
                {
                    foreach (DataRow row in cart.Rows)
                    {
                        // Insert Order Item
                        SqlCommand cmd = new SqlCommand(
                            "INSERT INTO Order_TBL(ProductId, Qty, Price) VALUES(@pid,@qty,@price)",
                            con, trans);

                        cmd.Parameters.AddWithValue("@pid", row["ProductId"]);
                        cmd.Parameters.AddWithValue("@qty", row["Qty"]);
                        cmd.Parameters.AddWithValue("@price", row["Price"]);
                        cmd.ExecuteNonQuery();

                        // Update Stock
                        SqlCommand stockCmd = new SqlCommand(
                            "UPDATE Product_TBL SET Stock = Stock - @qty WHERE ser=@id",
                            con, trans);

                        stockCmd.Parameters.AddWithValue("@qty", row["Qty"]);
                        stockCmd.Parameters.AddWithValue("@id", row["ProductId"]);
                        stockCmd.ExecuteNonQuery();
                    }

                    trans.Commit();

                    Session["Cart"] = null;
                    InitCart();
                    BindCart();

                    lblSubtotal.Text = "0.00";
                    lblGrandTotal.Text = "0.00";
                }
                catch
                {
                    trans.Rollback();
                }
            }
        }
    }
}