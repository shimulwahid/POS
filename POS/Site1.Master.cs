using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace POS
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lnkAdminLogin.Visible = !AuthService.IsAdmin;
            btnLogout.Visible = AuthService.IsAdmin;
            lnkAdminUsers.Visible = AuthService.IsSuperAdmin;
            lnkChangePassword.Visible = AuthService.IsAdmin;
            lblCurrentUser.Text = "<span class='user-dot'></span>" + (AuthService.IsAdmin ? AuthService.Username + " · " + (AuthService.IsSuperAdmin ? "Super Admin" : "Admin") : "Cashier mode");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Remove("AdminUsername"); Session.Remove("AdminRole");
            Response.Redirect("AdminLogin.aspx");
        }

    }
}
