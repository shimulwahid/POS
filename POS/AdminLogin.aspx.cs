using System;
using System.Web;
using System.Web.UI;
namespace POS { public partial class AdminLogin : Page {
 protected void Page_Load(object sender,EventArgs e) { if(AuthService.IsAdmin) Response.Redirect(AuthService.IsSuperAdmin?"AdminUsers.aspx":"Products.aspx"); }
 protected void btnLogin_Click(object sender,EventArgs e) { try { if(AuthService.Login(txtUsername.Text,txtPassword.Text)) Response.Redirect("Products.aspx"); else Show("Invalid username or password."); } catch(Exception ex){Show(HttpUtility.HtmlEncode(ex.Message));} }
 private void Show(string text){pnlError.Visible=true;litError.Text=text;}
} }
