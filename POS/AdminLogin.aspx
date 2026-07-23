<%@ Page Title="Admin Login" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="POS.AdminLogin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="container py-5"><div class="card shadow-sm mx-auto" style="max-width:430px"><div class="card-body p-4"><h3 class="mb-4">Administrator login</h3>
<asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger"><asp:Literal ID="litError" runat="server" /></asp:Panel>
<label class="form-label">Username</label><asp:TextBox ID="txtUsername" runat="server" CssClass="form-control mb-3" MaxLength="50" />
<label class="form-label">Password</label><asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control mb-3" />
<asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-dark w-100" OnClick="btnLogin_Click" />
</div></div></div></asp:Content>
