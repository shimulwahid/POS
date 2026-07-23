using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace POS
{
    public class Global : HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e) { }

        protected void Session_End(object sender, EventArgs e)
        {
            DataTable cart = Session["Cart"] as DataTable;
            if (cart == null || cart.Rows.Count == 0) return;
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["POSDatabase"].ConnectionString;
                using (var con = new SqlConnection(cs))
                {
                    con.Open();
                    using (var tx = con.BeginTransaction())
                    {
                        foreach (DataRow row in cart.Rows)
                        using (var cmd = new SqlCommand("UPDATE Product_TBL SET Stock=Stock+@qty WHERE ser=@id", con, tx))
                        {
                            cmd.Parameters.Add("@qty", SqlDbType.Decimal).Value = row["Qty"];
                            cmd.Parameters.Add("@id", SqlDbType.Int).Value = row["ProductId"];
                            cmd.ExecuteNonQuery();
                        }
                        tx.Commit();
                    }
                }
            }
            catch { }
        }
    }
}
