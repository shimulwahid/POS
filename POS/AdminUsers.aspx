<%@ Page Title="Manage Admins" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="AdminUsers.aspx.cs" Inherits="POS.AdminUsers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; padding-top: 24px; }
        .page-title { font-weight: 800; font-size: 1.5rem; letter-spacing: -.02em; margin: 0; }
        .card-table { background: var(--card); border-radius: var(--radius-lg); padding: 24px; box-shadow: var(--shadow-sm); }
        .card-form { background: var(--card); border-radius: var(--radius-lg); padding: 24px; box-shadow: var(--shadow-sm); }
        .form-label { font-size: .85rem; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px; }
        .btn-add { background: linear-gradient(135deg, var(--accent), var(--accent-light)); border: 0; color: #fff; font-weight: 600; padding: 10px 20px; box-shadow: 0 4px 12px var(--accent-glow); }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 0 6px 16px var(--accent-glow); color: #fff; }
        .admin-badge { background: var(--accent-surface); color: var(--accent); font-weight: 600; font-size: .75rem; padding: 4px 10px; border-radius: 999px; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <div>
            <div class="text-muted" style="font-size:.8rem;font-weight:700;text-transform:uppercase;letter-spacing:.1em;color:var(--accent)!important">Administration</div>
            <h1 class="page-title">Manage Admin Users</h1>
        </div>
    </div>
    
    <div class="row g-4">
        <div class="col-xl-4">
            <div class="card-form">
                <h4 class="mb-4" style="font-weight:700;font-size:1.1rem">Add New Admin</h4>
                <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert" style="font-size:.85rem;padding:12px;">
                    <asp:Literal ID="litMessage" runat="server" />
                </asp:Panel>
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" MaxLength="50" />
                </div>
                <div class="mb-4">
                    <label class="form-label">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />
                </div>
                <asp:Button ID="btnAddAdmin" runat="server" Text="Create Admin" CssClass="btn-add w-100" OnClick="btnAddAdmin_Click" />
            </div>
        </div>
        
        <div class="col-xl-8">
            <div class="card-table" style="height:100%">
                <h4 class="mb-4" style="font-weight:700;font-size:1.1rem">Current Administrators</h4>
                <asp:GridView ID="gvAdmins" runat="server" AutoGenerateColumns="false" CssClass="table table-hover align-middle" GridLines="None" OnRowCommand="gvAdmins_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Username" HeaderText="Username" />
                        <asp:BoundField DataField="Created_At" HeaderText="Date Created" DataFormatString="{0:dd MMM yyyy, hh:mm tt}" />
                        <asp:TemplateField HeaderText="Role"><ItemTemplate><span class="admin-badge">Admin</span></ItemTemplate></asp:TemplateField>
                        <asp:TemplateField HeaderText="Action" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteAdmin" CommandArgument='<%# Eval("Admin_ID") %>' CssClass="btn btn-sm btn-outline-danger" ToolTip="Delete" OnClientClick="return confirm('Are you sure you want to remove this admin?');">
                                    <svg viewBox="0 0 24 24" style="width:16px;height:16px;fill:none;stroke:currentColor;stroke-width:2;stroke-linecap:round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
