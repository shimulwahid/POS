<%@ Page Title="Administrators" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="AdminUsers.aspx.cs" Inherits="POS.AdminUsers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server"><div class="container py-4"><div class="card shadow-sm"><div class="card-body">
<h3>Add administrator</h3><asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert"><asp:Literal ID="litMessage" runat="server" /></asp:Panel>
<div class="row g-3"><div class="col-md-4"><label>Username</label><asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" /></div>
<div class="col-md-4"><label>Password</label><asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" /></div>
<div class="col-md-3"><label>Role</label><asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select"><asp:ListItem Value="Admin">Admin</asp:ListItem><asp:ListItem Value="SuperAdmin">Super Admin</asp:ListItem></asp:DropDownList></div>
<div class="col-md-1 d-flex align-items-end"><asp:Button ID="btnAdd" runat="server" Text="Add" CssClass="btn btn-primary" OnClick="btnAdd_Click" /></div></div>
<hr/><asp:GridView ID="gvAdmins" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered"><Columns><asp:BoundField DataField="Username" HeaderText="Username"/><asp:BoundField DataField="User_Role" HeaderText="Role"/><asp:CheckBoxField DataField="Is_Active" HeaderText="Active"/><asp:BoundField DataField="Created_At" HeaderText="Created" DataFormatString="{0:dd-MMM-yyyy}"/></Columns></asp:GridView>
</div></div></div></asp:Content>
