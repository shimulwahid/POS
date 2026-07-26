<%@ Page Title="Admin Login" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="POS.AdminLogin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .login-wrap { min-height: calc(100vh - 120px); display: flex; align-items: center; justify-content: center; padding: 20px; }
        .login-card { background: var(--card); border-radius: var(--radius-lg); box-shadow: var(--shadow-lg); width: 100%; max-width: 420px; overflow: hidden; }
        .login-top { height: 6px; background: linear-gradient(90deg, #6366f1, #a855f7); width: 100%; }
        .login-body { padding: 40px 32px; }
        .login-icon { width: 56px; height: 56px; background: var(--accent-surface); color: var(--accent); border-radius: 16px; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; }
        .login-icon svg { width: 28px; height: 28px; fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; }
        .login-title { font-weight: 800; font-size: 1.5rem; text-align: center; margin-bottom: 8px; letter-spacing: -.02em; }
        .login-subtitle { color: var(--text-muted); text-align: center; font-size: .9rem; margin-bottom: 28px; }
        .form-label { font-size: .85rem; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px; }
        .btn-login { background: linear-gradient(135deg, #4f46e5, #7c3aed); border: 0; color: #fff; font-weight: 600; padding: 12px; font-size: 1rem; border-radius: var(--radius); transition: all var(--transition); box-shadow: 0 4px 12px rgba(99,102,241,.3); }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(99,102,241,.4); color: #fff; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="login-wrap">
    <div class="login-card">
        <div class="login-top"></div>
        <div class="login-body">
            <div class="login-icon">
                <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            </div>
            <h3 class="login-title">Administrator Login</h3>
            <p class="login-subtitle">Sign in to access privileged actions</p>
            
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger" style="font-size:.85rem;padding:10px;"><asp:Literal ID="litError" runat="server" /></asp:Panel>
            
            <div class="mb-3">
                <label class="form-label">Username</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control form-control-lg" MaxLength="50" placeholder="admin" />
            </div>
            <div class="mb-4">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control form-control-lg" placeholder="••••••••" />
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="Sign in securely" CssClass="btn-login w-100" OnClick="btnLogin_Click" />
        </div>
    </div>
</div>
</asp:Content>
