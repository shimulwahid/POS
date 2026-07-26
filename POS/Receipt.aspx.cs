using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace POS
{
    public partial class Receipt : Page
    {
        private string ConnectionString { get { return ConfigurationManager.ConnectionStrings["POSDatabase"].ConnectionString; } }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            int orderNo;
            if (!int.TryParse(Request.QueryString["order"], out orderNo) || orderNo < 1) { ShowError("Invalid receipt number."); return; }
            try
            {
                using (var con = new SqlConnection(ConnectionString))
                { con.Open();
                    using (var cmd = new SqlCommand("SELECT * FROM Sales WHERE Order_No=@order", con))
                    { cmd.Parameters.Add("@order", SqlDbType.Int).Value=orderNo; using (var r=cmd.ExecuteReader())
                        { if (!r.Read()) { ShowError("Receipt not found."); return; }
                          litOrderNo.Text=orderNo.ToString(); litDate.Text=Convert.ToDateTime(r["Sale_Date"]).ToString("dd-MMM-yyyy hh:mm tt");
                          litSubtotal.Text=Money(r["Subtotal"]); litDiscount.Text=Money(r["Discount"]); litTotal.Text=Money(r["Grand_Total"]);
                          litPaid.Text=Money(r["Amount_Paid"]); litChange.Text=Money(r["Change_Amount"]); litMethod.Text=HttpUtility.HtmlEncode(r["Payment_Method"].ToString());
                        } }
                    using (var da = new SqlDataAdapter("SELECT Product_Name,Qty,Unit_Price,Total_Price FROM Sale_history WHERE Order_No=@order ORDER BY Product_Name", con))
                    { da.SelectCommand.Parameters.Add("@order",SqlDbType.Int).Value=orderNo; var items=new DataTable(); da.Fill(items); gvItems.DataSource=items; gvItems.DataBind(); }
                }
                litShopName.Text=HttpUtility.HtmlEncode(ConfigurationManager.AppSettings["ShopName"] ?? "My Shop");
                litShopAddress.Text=HttpUtility.HtmlEncode(ConfigurationManager.AppSettings["ShopAddress"] ?? "Sales Receipt");

            }
            catch (Exception ex) { ShowError(HttpUtility.HtmlEncode(ex.Message)); }
        }
        private static string Money(object value) { return Convert.ToDecimal(value).ToString("N2"); }
        private void ShowError(string message) { pnlReceipt.Visible=false; pnlError.Visible=true; litError.Text=message; }
    }
}
