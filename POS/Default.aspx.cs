using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace POS
{
    public partial class Default : System.Web.UI.Page
    {
        string cs = "Data Source=DESKTOP-G0J1RC1\\SQL17;Initial Catalog=POS;Integrated Security=True";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                setValues();
            }
        }

        protected void setValues()
        {
            
            productQty.InnerHtml = getQty("SELECT COUNT(*) FROM Product_TBL").ToString();
            low_stock_Count.InnerHtml = getQty("SELECT COUNT(*) FROM Product_TBL WHERE Stock<10 AND Stock>0")+" low stock";
            out_of_stock_Count.InnerHtml = getQty("SELECT COUNT(*) FROM Product_TBL WHERE Stock=0") + " out of stock";
        }
        protected int getQty(string query)
        {
            int count = 0;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@query, con);
                con.Open();
                count = (int)cmd.ExecuteScalar();
            }
            return count;
        }
    }
}