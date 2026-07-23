using System; using System.Configuration; using System.Data; using System.Data.SqlClient; using System.Web; using System.Web.UI;
namespace POS { public partial class AdminUsers : Page { private string Cs{get{return ConfigurationManager.ConnectionStrings["POSDatabase"].ConnectionString;}}
 protected void Page_Load(object sender,EventArgs e){if(!AuthService.IsSuperAdmin){Response.Redirect("AdminLogin.aspx?returnUrl=AdminUsers.aspx");return;} if(!IsPostBack)LoadUsers();}
 protected void btnAdd_Click(object sender,EventArgs e){try{AuthService.CreateUser(txtUsername.Text,txtPassword.Text,ddlRole.SelectedValue);Show("Administrator created.",true);txtUsername.Text="";LoadUsers();}catch(Exception ex){Show(HttpUtility.HtmlEncode(ex.Message),false);}}
 private void LoadUsers(){AuthService.EnsureAdminTable();using(var con=new SqlConnection(Cs))using(var da=new SqlDataAdapter("SELECT Username,User_Role,Is_Active,Created_At FROM AdminUsers ORDER BY Created_At",con)){var dt=new DataTable();da.Fill(dt);gvAdmins.DataSource=dt;gvAdmins.DataBind();}}
 private void Show(string t,bool ok){pnlMessage.Visible=true;pnlMessage.CssClass="alert "+(ok?"alert-success":"alert-danger");litMessage.Text=t;}
} }
