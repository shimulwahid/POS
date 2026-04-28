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
            // Reload grid
            LoadProducts();

            // Close modal after save
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideModal", "$('#addProductModal').modal('hide');", true);
        }
    }
}