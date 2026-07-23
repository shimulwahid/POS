using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace POS { public partial class Reports : Page {
    private string Cs { get { return ConfigurationManager.ConnectionStrings["POSDatabase"].ConnectionString; } }
    protected void Page_Load(object sender, EventArgs e) { if (!IsPostBack) LoadSales(); }
    private void LoadSales() { using(var con=new SqlConnection(Cs)) using(var da=new SqlDataAdapter("IF OBJECT_ID('dbo.Sales','U') IS NULL SELECT TOP 0 0 Order_No,GETDATE() Sale_Date,CAST(0 AS decimal) Grand_Total,'' Payment_Method ELSE SELECT Order_No,Sale_Date,Grand_Total,Payment_Method FROM Sales ORDER BY Sale_Date DESC",con)) { var dt=new DataTable(); da.Fill(dt); gvSales.DataSource=dt; gvSales.DataBind(); pnlNoSales.Visible=dt.Rows.Count==0; } }
    protected void gvSales_RowCommand(object sender, GridViewCommandEventArgs e) { if(e.CommandName=="Receipt") Response.Redirect("Receipt.aspx?order="+Convert.ToInt32(e.CommandArgument)); }
} }
