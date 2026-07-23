using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace POS
{
    public static class AuthService
    {
        private const int Iterations = 100000;
        private static string Cs { get { return ConfigurationManager.ConnectionStrings["POSDatabase"].ConnectionString; } }
        public static bool IsAdmin { get { return HttpContext.Current.Session["AdminRole"] != null; } }
        public static bool IsSuperAdmin { get { return string.Equals(HttpContext.Current.Session["AdminRole"] as string, "SuperAdmin", StringComparison.Ordinal); } }
        public static string Username { get { return HttpContext.Current.Session["AdminUsername"] as string ?? ""; } }

        public static void EnsureAdminTable()
        {
            using (var con = new SqlConnection(Cs))
            using (var cmd = new SqlCommand(@"IF OBJECT_ID('dbo.AdminUsers','U') IS NULL
                CREATE TABLE dbo.AdminUsers(Admin_ID INT IDENTITY(1,1) PRIMARY KEY, Username NVARCHAR(50) NOT NULL UNIQUE,
                Password_Hash VARBINARY(32) NOT NULL, Password_Salt VARBINARY(16) NOT NULL,
                User_Role NVARCHAR(20) NOT NULL, Is_Active BIT NOT NULL DEFAULT(1), Created_At DATETIME NOT NULL DEFAULT(GETDATE()));", con))
            { con.Open(); cmd.ExecuteNonQuery(); }
        }

        public static void EnsureSuperAdmin()
        {
            EnsureAdminTable();
            using (var con = new SqlConnection(Cs))
            using (var cmd = new SqlCommand("SELECT COUNT(*) FROM AdminUsers", con))
            { con.Open(); if (Convert.ToInt32(cmd.ExecuteScalar()) == 0)
                CreateUser(ConfigurationManager.AppSettings["BootstrapSuperAdminUser"] ?? "superadmin",
                    ConfigurationManager.AppSettings["BootstrapSuperAdminPassword"], "SuperAdmin"); }
        }

        public static bool Login(string username, string password)
        {
            EnsureSuperAdmin();
            using (var con = new SqlConnection(Cs))
            using (var cmd = new SqlCommand("SELECT Password_Hash,Password_Salt,User_Role FROM AdminUsers WHERE Username=@user AND Is_Active=1", con))
            {
                cmd.Parameters.Add("@user", SqlDbType.NVarChar, 50).Value = username.Trim(); con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.Read()) return false;
                    byte[] expected=(byte[])reader["Password_Hash"], salt=(byte[])reader["Password_Salt"];
                    if (!SlowEquals(expected, Hash(password, salt))) return false;
                    HttpContext.Current.Session["AdminUsername"] = username.Trim();
                    HttpContext.Current.Session["AdminRole"] = reader["User_Role"].ToString(); return true;
                }
            }
        }

        public static void CreateUser(string username, string password, string role)
        {
            if (string.IsNullOrWhiteSpace(username) || username.Trim().Length < 3) throw new ArgumentException("Username must contain at least 3 characters.");
            if (string.IsNullOrEmpty(password) || password.Length < 8) throw new ArgumentException("Password must contain at least 8 characters.");
            byte[] salt = new byte[16]; using (var rng=RandomNumberGenerator.Create()) rng.GetBytes(salt);
            using (var con=new SqlConnection(Cs)) using(var cmd=new SqlCommand(@"INSERT INTO AdminUsers
                (Username,Password_Hash,Password_Salt,User_Role,Is_Active) VALUES(@user,@hash,@salt,@role,1)",con))
            { cmd.Parameters.Add("@user",SqlDbType.NVarChar,50).Value=username.Trim(); cmd.Parameters.Add("@hash",SqlDbType.VarBinary,32).Value=Hash(password,salt);
              cmd.Parameters.Add("@salt",SqlDbType.VarBinary,16).Value=salt; cmd.Parameters.Add("@role",SqlDbType.NVarChar,20).Value=role; con.Open(); cmd.ExecuteNonQuery(); }
        }

        public static bool ChangePassword(string username, string currentPassword, string newPassword)
        {
            if (string.IsNullOrEmpty(newPassword) || newPassword.Length < 8) throw new ArgumentException("New password must contain at least 8 characters.");
            byte[] oldHash, oldSalt;
            using (var con=new SqlConnection(Cs)) using(var cmd=new SqlCommand("SELECT Password_Hash,Password_Salt FROM AdminUsers WHERE Username=@user AND Is_Active=1",con))
            { cmd.Parameters.Add("@user",SqlDbType.NVarChar,50).Value=username; con.Open(); using(var r=cmd.ExecuteReader())
              { if(!r.Read())return false;oldHash=(byte[])r[0];oldSalt=(byte[])r[1]; } }
            if (!SlowEquals(oldHash, Hash(currentPassword, oldSalt))) return false;
            byte[] newSalt=new byte[16];using(var rng=RandomNumberGenerator.Create())rng.GetBytes(newSalt);
            using(var con=new SqlConnection(Cs))using(var cmd=new SqlCommand("UPDATE AdminUsers SET Password_Hash=@hash,Password_Salt=@salt WHERE Username=@user",con))
            {cmd.Parameters.Add("@hash",SqlDbType.VarBinary,32).Value=Hash(newPassword,newSalt);cmd.Parameters.Add("@salt",SqlDbType.VarBinary,16).Value=newSalt;cmd.Parameters.Add("@user",SqlDbType.NVarChar,50).Value=username;con.Open();return cmd.ExecuteNonQuery()==1;}
        }

        private static byte[] Hash(string password, byte[] salt)
        {
            string pepper = ConfigurationManager.AppSettings["PasswordPepperKey"];
            using (var derive=new Rfc2898DeriveBytes(password + pepper, salt, Iterations)) return derive.GetBytes(32);
        }
        private static bool SlowEquals(byte[] a, byte[] b) { uint diff=(uint)a.Length^(uint)b.Length; for(int i=0;i<a.Length&&i<b.Length;i++) diff|=(uint)(a[i]^b[i]); return diff==0; }
    }
}
