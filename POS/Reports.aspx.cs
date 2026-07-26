using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace POS
{
    public partial class Reports : Page
    {
        private string Cs
        {
            get
            {
                return ConfigurationManager
                .ConnectionStrings["POSDatabase"]
                .ConnectionString;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSales();
            }
        }
        private void LoadSales()
        {
            using (SqlConnection con = new SqlConnection(Cs))
            {
                string query = @"
IF OBJECT_ID('dbo.Sales','U') IS NULL
BEGIN
SELECT
CAST(0 AS INT) AS Order_No,
GETDATE() AS Sale_Date,
CAST(0 AS DECIMAL(18,2)) AS Grand_Total,
'' AS Payment_Method
WHERE 1 = 0
END
ELSE
BEGIN
SELECT
Order_No,
Sale_Date,
Grand_Total,
Payment_Method
FROM Sales
ORDER BY Sale_Date DESC
END
";
                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvSales.DataSource = dt;
                    gvSales.DataBind();
                }
            }
        }
        protected void gvSales_RowCommand
        (object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Receipt")
            {
                int orderNo = Convert.ToInt32(e.CommandArgument);
                Response.Redirect(
                "Receipt.aspx?order=" + orderNo
                );
            }
        }
    }
}