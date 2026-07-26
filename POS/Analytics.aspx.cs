using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Web;

namespace POS
{
    public partial class Analytics : Page
    {
        private string Cs { get { return ConfigurationManager.ConnectionStrings["POSDatabase"].ConnectionString; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Default date range: Last 30 days
                txtFromDate.Text = DateTime.Today.AddDays(-30).ToString("yyyy-MM-dd");
                txtToDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
                LoadProducts();
                LoadAnalytics();
            }
        }

        private void LoadProducts()
        {
            using (var con = new SqlConnection(Cs))
            {
                using (var da = new SqlDataAdapter("SELECT Product_code, Product_Name FROM Product_TBL ORDER BY Product_Name", con))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    foreach (DataRow row in dt.Rows)
                    {
                        ddlProduct.Items.Add(new System.Web.UI.WebControls.ListItem(row["Product_Name"].ToString(), row["Product_code"].ToString()));
                    }
                }
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadAnalytics();
        }

        private void LoadAnalytics()
        {
            DateTime fromDate, toDate;
            if (!DateTime.TryParse(txtFromDate.Text, out fromDate)) fromDate = DateTime.Today.AddDays(-30);
            if (!DateTime.TryParse(txtToDate.Text, out toDate)) toDate = DateTime.Today;
            // Include entire end day
            toDate = toDate.Date.AddDays(1).AddSeconds(-1);

            string productCode = ddlProduct.SelectedValue;
            bool specificProduct = !string.IsNullOrEmpty(productCode);
            
            priceCard.Visible = specificProduct; // Only show price history for specific products
            
            if (specificProduct) {
                lblMetric3.InnerText = "Average Selling Price";
            } else {
                lblMetric3.InnerText = "Average Sale (Per Order)";
            }

            using (var con = new SqlConnection(Cs))
            {
                con.Open();

                // 1. Get Metrics & Breakdown
                string sqlMetrics = "";
                string sqlGraph = "";
                
                if (specificProduct)
                {
                    // Specific product logic
                    sqlMetrics = @"SELECT 
                                    ISNULL(SUM(Total_Price),0) as TotalRev, 
                                    ISNULL(SUM(Qty),0) as TotalQty, 
                                    CASE WHEN SUM(Qty) > 0 THEN SUM(Total_Price)/SUM(Qty) ELSE 0 END as AvgMetric 
                                   FROM Sale_history h 
                                   INNER JOIN Sales s ON h.Order_No = s.Order_No 
                                   WHERE h.Product_code = @pcode AND s.Sale_Date BETWEEN @from AND @to";
                                   
                    sqlGraph = @"SELECT CAST(s.Sale_Date as DATE) as DateLabel, ISNULL(SUM(h.Qty),0) as Qty, ISNULL(SUM(h.Total_Price),0) as Revenue
                                 FROM Sales s
                                 LEFT JOIN Sale_history h ON s.Order_No = h.Order_No AND h.Product_code = @pcode
                                 WHERE s.Sale_Date BETWEEN @from AND @to
                                 GROUP BY CAST(s.Sale_Date as DATE) ORDER BY DateLabel";
                                 
                    // Price history graph logic
                    using (var cmdPrice = new SqlCommand(@"
                                SELECT s.Sale_Date, h.Unit_Price 
                                FROM Sale_history h 
                                INNER JOIN Sales s ON h.Order_No = s.Order_No 
                                WHERE h.Product_code = @pcode AND s.Sale_Date BETWEEN @from AND @to
                                ORDER BY s.Sale_Date", con))
                    {
                        cmdPrice.Parameters.AddWithValue("@pcode", productCode);
                        cmdPrice.Parameters.AddWithValue("@from", fromDate);
                        cmdPrice.Parameters.AddWithValue("@to", toDate);
                        
                        var pLabels = new List<string>();
                        var pData = new List<decimal>();
                        using (var r = cmdPrice.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                pLabels.Add(Convert.ToDateTime(r["Sale_Date"]).ToString("dd MMM yyyy"));
                                pData.Add(Convert.ToDecimal(r["Unit_Price"]));
                            }
                        }
                        var js = new JavaScriptSerializer();
                        hfPriceLabels.Value = js.Serialize(pLabels);
                        hfPriceData.Value = js.Serialize(pData);
                    }
                }
                else
                {
                    // Global logic
                    sqlMetrics = @"SELECT 
                                    ISNULL(SUM(Grand_Total),0) as TotalRev, 
                                    COUNT(Order_No) as TotalQty, 
                                    CASE WHEN COUNT(Order_No) > 0 THEN SUM(Grand_Total)/COUNT(Order_No) ELSE 0 END as AvgMetric 
                                   FROM Sales 
                                   WHERE Sale_Date BETWEEN @from AND @to";
                                   
                    sqlGraph = @"SELECT CAST(Sale_Date as DATE) as DateLabel, COUNT(Order_No) as Qty, ISNULL(SUM(Grand_Total),0) as Revenue
                                 FROM Sales 
                                 WHERE Sale_Date BETWEEN @from AND @to
                                 GROUP BY CAST(Sale_Date as DATE) ORDER BY DateLabel";
                }

                // Execute Metrics
                using (var cmd = new SqlCommand(sqlMetrics, con))
                {
                    if (specificProduct) cmd.Parameters.AddWithValue("@pcode", productCode);
                    cmd.Parameters.AddWithValue("@from", fromDate);
                    cmd.Parameters.AddWithValue("@to", toDate);
                    
                    using (var r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            litTotalRev.Text = Convert.ToDecimal(r["TotalRev"]).ToString("N2");
                            if (specificProduct)
                                litTotalQty.Text = Convert.ToDecimal(r["TotalQty"]).ToString("0.##");
                            else
                                litTotalQty.Text = r["TotalQty"].ToString() + " Orders";
                                
                            valMetric3.InnerText = "Tk " + Convert.ToDecimal(r["AvgMetric"]).ToString("N2");
                        }
                    }
                }

                // Execute Graph & Breakdown
                using (var cmd = new SqlCommand(sqlGraph, con))
                {
                    if (specificProduct) cmd.Parameters.AddWithValue("@pcode", productCode);
                    cmd.Parameters.AddWithValue("@from", fromDate);
                    cmd.Parameters.AddWithValue("@to", toDate);
                    
                    var dt = new DataTable();
                    using (var da = new SqlDataAdapter(cmd)) { da.Fill(dt); }
                    
                    // Add formatted date for GridView
                    dt.Columns.Add("DateFormatted", typeof(string));
                    
                    var labels = new List<string>();
                    var data = new List<decimal>();
                    
                    foreach (DataRow row in dt.Rows)
                    {
                        DateTime d = Convert.ToDateTime(row["DateLabel"]);
                        string formatted = d.ToString("dd MMM yyyy");
                        row["DateFormatted"] = formatted;
                        labels.Add(d.ToString("dd MMM"));
                        data.Add(Convert.ToDecimal(row["Revenue"]));
                    }
                    
                    // Swap column for rendering
                    dt.Columns["DateLabel"].ColumnName = "DateLabelOld";
                    dt.Columns["DateFormatted"].ColumnName = "DateLabel";
                    
                    gvBreakdown.DataSource = dt;
                    gvBreakdown.DataBind();
                    
                    var js = new JavaScriptSerializer();
                    hfSalesLabels.Value = js.Serialize(labels);
                    hfSalesData.Value = js.Serialize(data);
                }
            }
        }
    }
}
