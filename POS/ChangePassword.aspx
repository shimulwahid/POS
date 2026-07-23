<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="POS.ChangePassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server"><div class="container py-5"><div class="card mx-auto" style="max-width:480px"><div class="card-body p-4"><h3 class="fw-bold mb-1">Change password</h3><p class="text-muted mb-4">Update the password for <asp:Literal ID="litUsername" runat="server" />.</p>
<asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert"><asp:Literal ID="litMessage" runat="server" /></asp:Panel>
<label class="form-label">Current password</label><asp:TextBox ID="txtCurrent" runat="server" TextMode="Password" CssClass="form-control mb-3" />
<label class="form-label">New password</label><asp:TextBox ID="txtNew" runat="server" TextMode="Password" CssClass="form-control mb-3" /><div class="form-text mt-n2 mb-3">Use at least 8 characters.</div>
<label class="form-label">Confirm new password</label><asp:TextBox ID="txtConfirm" runat="server" TextMode="Password" CssClass="form-control mb-4" />
<asp:Button ID="btnChange" runat="server" Text="Change password" CssClass="btn btn-primary w-100" OnClick="btnChange_Click" />
</div></div></div></asp:Content>
