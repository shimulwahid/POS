using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace POS
{
    public partial class POS : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string keyword = txtSearch.Text.Trim();

            // test first
            System.Diagnostics.Debug.WriteLine("Search clicked: " + keyword);
        }
        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                int productId = Convert.ToInt32(e.CommandArgument);

                System.Diagnostics.Debug.WriteLine("AddToCart clicked: " + productId);

                // TODO: load product and add to cart
            }
        }
        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            // test first
            System.Diagnostics.Debug.WriteLine("Checkout clicked");

            // TODO:
            // 1. Save order to database
            // 2. Deduct stock
            // 3. Clear cart (Session)
        }
    }
}