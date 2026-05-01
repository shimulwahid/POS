using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace POS
{
    public partial class Products : System.Web.UI.Page
    {
        string cs = "Data Source=DESKTOP-G0J1RC1\\SQL17;Initial Catalog=POS;Integrated Security=True";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts();
            }
        }
        private void LoadProducts()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Product_TBL", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvProducts.DataSource = dt;
                gvProducts.DataBind();
                //if (gvProducts.Rows.Count > 0)
                //{
                //    gvProducts.UseAccessibleHeader = true;
                //    gvProducts.HeaderRow.TableSection = TableRowSection.TableHeader;
                //}
            }
        }
        protected void gvProducts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Get Stock value from current row
                int stock = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Stock"));

                if (stock == 0)
                {
                    // 🔴 Out of stock → red row
                    e.Row.CssClass = "table-danger";
                }
                else if (stock < 10)
                {
                    // 🟡 Low stock → yellow row (optional)
                    e.Row.CssClass = "table-warning";
                }
            }
        }

        protected void gvProducts_PreRender(object sender, EventArgs e)
        {
            if (gvProducts.Rows.Count > 0)
            {
                gvProducts.UseAccessibleHeader = true;
                gvProducts.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            string name = txtProductName.Text;
            string category = txtCategory.Text;
            string unit = txtUnit.Text;
            string product_Code = txtProduct_Code.Text;
            string barcode = txtBarcode.Text;
            decimal price = Convert.ToDecimal(txtPrice.Text);
            decimal stock = Convert.ToDecimal(txtStock.Text);

            if (ViewState["EditID"] != null)
            {
                // UPDATE
                int id = Convert.ToInt32(ViewState["EditID"]);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlCommand cmd = new SqlCommand(@"UPDATE Product_TBL SET 
                Product_Name=@name,
                Cetagory=@category,
                Unit=@unit,
                Product_code=@product_Code,
                Barcode_No=@barcode,
                Unit_Price=@price,
                Stock=@stock
                WHERE ser=@id", con);

                    cmd.Parameters.AddWithValue("@name", name);
                    cmd.Parameters.AddWithValue("@category", category);
                    cmd.Parameters.AddWithValue("@unit", unit);
                    cmd.Parameters.AddWithValue("@stock", stock);
                    cmd.Parameters.AddWithValue("@price", price);
                    cmd.Parameters.AddWithValue("@product_Code", product_Code);
                    cmd.Parameters.AddWithValue("@barcode", barcode);
                    cmd.Parameters.AddWithValue("@id", id);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                ViewState["EditID"] = null;
                btnAddProduct.Text = "Add Product";
            }
            else
            {
                // Save to DB

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = "insert into Product_TBL (Product_Name, Cetagory, Unit, Stock, Unit_Price, Product_code, Barcode_No) Values (@name, @category, @unit, @stock, @price, @product_Code, @barcode)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@name", name);
                        cmd.Parameters.AddWithValue("@category", category);
                        cmd.Parameters.AddWithValue("@unit", unit);
                        cmd.Parameters.AddWithValue("@stock", stock);
                        cmd.Parameters.AddWithValue("@price", price);
                        cmd.Parameters.AddWithValue("@product_Code", product_Code);
                        cmd.Parameters.AddWithValue("@barcode", barcode);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
            }

            ClearForm();   // 🔥 reset fields
            ResetModal();  // 🔥 reset title/button
            // Reload grid
            LoadProducts();

            // Close modal after save
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideModal", "$('#addProductModal').modal('hide');", true);
        }
        private void ClearForm()
        {
            txtProductName.Text = "";
            txtCategory.Text = "";
            txtUnit.Text = "";
            txtProduct_Code.Text = "";
            txtBarcode.Text = "";
            txtPrice.Text = "";
            txtStock.Text = "";
        }
        private void ResetModal()
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "reset",
            @"
            document.querySelector('#addProductModal .modal-title').innerText = 'Add New Product';
            document.getElementById('" + btnAddProduct.ClientID + @"').value = 'Add Product';
            ",
            true);
        }
        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditRow")
            {
                modalTitle.InnerText = "Edit Product";
                btnAddProduct.Text = "Update Product";
                
                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM Product_TBL WHERE ser=@id", con);
                    cmd.Parameters.AddWithValue("@id", productId);

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        txtProductName.Text = dr["Product_Name"].ToString();
                        txtCategory.Text = dr["Cetagory"].ToString();
                        txtUnit.Text = dr["Unit"].ToString();
                        txtProduct_Code.Text = dr["Product_code"].ToString();
                        txtBarcode.Text = dr["Barcode_No"].ToString();
                        txtPrice.Text = dr["Unit_Price"].ToString();
                        txtStock.Text = dr["Stock"].ToString();
                    }
                }

                // Store ID for update later
                ViewState["EditID"] = productId;

                // 🔥 Re-open modal after postback
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop",
   "var modal = new bootstrap.Modal(document.getElementById('addProductModal')); modal.show();" +
   "document.querySelector('#addProductModal .modal-title').innerText='Edit Product';",
   true);

            }
            else if (e.CommandName == "DeleteRow")
            {
                System.Diagnostics.Debug.WriteLine("DeleteRow");
                Response.Write("DeleteRow<br/>");
                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Product_TBL WHERE ser=@id", con);
                    cmd.Parameters.AddWithValue("@id", productId);
                    Console.WriteLine("ProductID=" + productId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadProducts(); // refresh grid
            }
        }
    }
}