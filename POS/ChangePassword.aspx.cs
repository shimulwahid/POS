using System;using System.Web;using System.Web.UI;
namespace POS { public partial class ChangePassword : Page {
 protected void Page_Load(object sender,EventArgs e){if(!AuthService.IsAdmin){Response.Redirect("AdminLogin.aspx");return;}litUsername.Text=HttpUtility.HtmlEncode(AuthService.Username);}
 protected void btnChange_Click(object sender,EventArgs e){if(txtNew.Text!=txtConfirm.Text){Show("New passwords do not match.",false);return;}try{if(AuthService.ChangePassword(AuthService.Username,txtCurrent.Text,txtNew.Text)){Show("Password changed successfully. Use the new password next time you log in.",true);txtCurrent.Text=txtNew.Text=txtConfirm.Text="";}else Show("Current password is incorrect.",false);}catch(Exception ex){Show(HttpUtility.HtmlEncode(ex.Message),false);}}
 private void Show(string text,bool ok){pnlMessage.Visible=true;pnlMessage.CssClass="alert "+(ok?"alert-success":"alert-danger");litMessage.Text=text;}
} }
