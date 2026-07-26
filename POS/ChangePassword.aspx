<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="POS.ChangePassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; padding-top: 24px; }
        .page-title { font-weight: 800; font-size: 1.5rem; letter-spacing: -.02em; margin: 0; }
        .card-form { background: var(--card); border-radius: var(--radius-lg); padding: 32px; box-shadow: var(--shadow-sm); max-width: 500px; }
        .form-label { font-size: .85rem; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px; }
        .btn-save { background: linear-gradient(135deg, var(--accent), var(--accent-light)); border: 0; color: #fff; font-weight: 600; padding: 12px; font-size: 1rem; border-radius: var(--radius); transition: all var(--transition); box-shadow: 0 4px 12px var(--accent-glow); }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 6px 16px var(--accent-glow); color: #fff; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <div>
            <div class="text-muted" style="font-size:.8rem;font-weight:700;text-transform:uppercase;letter-spacing:.1em;color:var(--accent)!important">Security</div>
            <h1 class="page-title">Change Password</h1>
        </div>
    </div>
    
    <div class="card-form">
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert" style="font-size:.85rem;padding:12px;">
            <asp:Literal ID="litMessage" runat="server" />
        </asp:Panel>
        
        <div class="mb-3">
            <label class="form-label">Old Password</label>
            <asp:TextBox ID="txtOldPassword" runat="server" TextMode="Password" CssClass="form-control form-control-lg" />
        </div>
        <div class="mb-3">
            <label class="form-label">New Password</label>
            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control form-control-lg" />
        </div>
        <div class="mb-4">
            <label class="form-label">Confirm New Password</label>
            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control form-control-lg" />
        </div>
        <asp:Button ID="btnChange" runat="server" Text="Update Password" CssClass="btn-save w-100" OnClick="btnChange_Click" />
    </div>
</asp:Content>
