using System; using System.Configuration; using System.Data; using System.Data.SqlClient; using System.Text; using System.Web; using System.Web.UI;
namespace POS { public partial class Default : Page {
 private string Cs{get{return ConfigurationManager.ConnectionStrings["POSDatabase"].ConnectionString;}}
 protected void Page_Load(object sender,EventArgs e){if(!IsPostBack)LoadDashboard();}
 private void LoadDashboard(){litDate.Text=DateTime.Now.ToString("dddd, dd MMMM yyyy");lnkAddAdmin.Visible=AuthService.IsSuperAdmin;
  using(var con=new SqlConnection(Cs)){con.Open();
   using(var cmd=new SqlCommand(@"SELECT COUNT(*),ISNULL(SUM(Stock),0),ISNULL(SUM(Stock*Unit_Price),0),
    ISNULL(SUM(CASE WHEN Stock>0 AND Stock<10 THEN 1 ELSE 0 END),0),ISNULL(SUM(CASE WHEN Stock<=0 THEN 1 ELSE 0 END),0),ISNULL(SUM(CASE WHEN Stock>=10 THEN 1 ELSE 0 END),0) FROM Product_TBL",con))
   using(var r=cmd.ExecuteReader()){if(r.Read()){int products=Convert.ToInt32(r[0]), healthy=Convert.ToInt32(r[5]);productQty.InnerText=products.ToString();stockUnits.InnerText=Convert.ToDecimal(r[1]).ToString("0.##");inventoryValue.InnerText=Money(r[2]);low_stock_Count.InnerText=r[3]+" low stock";out_of_stock_Count.InnerText=r[4]+" out of stock";healthyStock.InnerText=healthy+" products";healthyBar.Style["width"]=(products==0?0:(healthy*100/products))+"%";}}
   bool salesExists;using(var cmd=new SqlCommand("SELECT CASE WHEN OBJECT_ID('dbo.Sales','U') IS NULL THEN 0 ELSE 1 END",con))salesExists=Convert.ToInt32(cmd.ExecuteScalar())==1;
   if(!salesExists){RenderEmptyChart();BindEmpty();return;}
   using(var cmd=new SqlCommand(@"SELECT ISNULL(SUM(CASE WHEN Sale_Date>=CAST(GETDATE() AS date) THEN Grand_Total ELSE 0 END),0),
    SUM(CASE WHEN Sale_Date>=CAST(GETDATE() AS date) THEN 1 ELSE 0 END),ISNULL(SUM(CASE WHEN Sale_Date>=DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),1) THEN Grand_Total ELSE 0 END),0) FROM Sales",con))
   using(var r=cmd.ExecuteReader()){if(r.Read()){decimal today=Convert.ToDecimal(r[0]);int count=Convert.ToInt32(r[1]);saleAmount.InnerText=Money(today);saleQty.InnerText=count+" transactions";monthSales.InnerText=Money(r[2]);averageSale.InnerText=Money(count==0?0:today/count);}}
   var days=new DataTable();using(var da=new SqlDataAdapter(@"WITH d AS(SELECT CAST(DATEADD(day,-6,CAST(GETDATE() AS date)) AS date) DayValue UNION ALL SELECT DATEADD(day,1,DayValue) FROM d WHERE DayValue<CAST(GETDATE() AS date)) SELECT d.DayValue,ISNULL(SUM(s.Grand_Total),0) Amount FROM d LEFT JOIN Sales s ON s.Sale_Date>=d.DayValue AND s.Sale_Date<DATEADD(day,1,d.DayValue) GROUP BY d.DayValue ORDER BY d.DayValue",con))da.Fill(days);RenderChart(days);
   BindGrid(con,gvRecentSales,"SELECT TOP 6 Order_No,Sale_Date,Payment_Method,Grand_Total FROM Sales ORDER BY Sale_Date DESC");
   BindGrid(con,gvTopProducts,"SELECT TOP 6 Product_Name,SUM(Qty) Quantity,SUM(Total_Price) Revenue FROM Sale_history GROUP BY Product_Name ORDER BY SUM(Qty) DESC");
  }}
 private void BindGrid(SqlConnection con,System.Web.UI.WebControls.GridView grid,string sql){using(var da=new SqlDataAdapter(sql,con)){var dt=new DataTable();da.Fill(dt);grid.DataSource=dt;grid.DataBind();}}
 private void BindEmpty(){gvRecentSales.DataSource=new DataTable();gvRecentSales.DataBind();gvTopProducts.DataSource=new DataTable();gvTopProducts.DataBind();saleAmount.InnerText=monthSales.InnerText=averageSale.InnerText="0.00";saleQty.InnerText="0 transactions";}
 private void RenderEmptyChart(){var dt=new DataTable();dt.Columns.Add("DayValue",typeof(DateTime));dt.Columns.Add("Amount",typeof(decimal));for(int i=6;i>=0;i--)dt.Rows.Add(DateTime.Today.AddDays(-i),0m);RenderChart(dt);}
 private void RenderChart(DataTable dt){decimal max=0;foreach(DataRow r in dt.Rows)max=Math.Max(max,Convert.ToDecimal(r["Amount"]));var html=new StringBuilder();foreach(DataRow r in dt.Rows){decimal amount=Convert.ToDecimal(r["Amount"]);int height=max==0?3:Math.Max(3,(int)(amount/max*185));html.AppendFormat("<div class='bar-col'><div class='bar' style='height:{0}px' data-value='{1}'></div><div class='bar-label'>{2}</div></div>",height,HttpUtility.HtmlAttributeEncode(Money(amount)),Convert.ToDateTime(r["DayValue"]).ToString("ddd"));}litSalesChart.Text=html.ToString();}
 private static string Money(object v){return Convert.ToDecimal(v).ToString("N2");}
 protected string GetPaymentClass(string method){switch((method??"").ToLower()){case"cash":return"cash";case"card":return"card";case"mobile banking":return"mobile";default:return"other";}}
} }
