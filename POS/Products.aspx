<%@ Page Title="Products" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="POS.Products" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .page-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; padding-top: 24px; }
        .page-title { font-weight: 800; font-size: 1.5rem; letter-spacing: -.02em; margin: 0; }
        .dataTables_filter { margin-bottom: 14px; float: right; text-align: right; }
        .card-table { background: var(--card); border-radius: var(--radius-lg); padding: 24px; box-shadow: var(--shadow-sm); }
        .btn-add { background: linear-gradient(135deg, var(--accent), var(--accent-light)); border: 0; color: #fff; font-weight: 600; padding: 10px 20px; box-shadow: 0 4px 12px var(--accent-glow); }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 0 6px 16px var(--accent-glow); color: #fff; }
        
        .stock-badge { font-size: .75rem; font-weight: 600; padding: 4px 10px; border-radius: 999px; }
        .stock-ok { background: var(--success-surface); color: #065f46; }
        .stock-low { background: var(--warning-surface); color: #92400e; }
        .stock-out { background: var(--danger-surface); color: #991b1b; }
        
        .modal-content { background: rgba(255,255,255,0.95); backdrop-filter: blur(16px); }
        .form-label { font-size: .85rem; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px; }
    </style>
    <div class="page-header">
        <div>
            <div class="text-muted" style="font-size:.8rem;font-weight:700;text-transform:uppercase;letter-spacing:.1em;color:var(--accent)!important">Inventory</div>
            <h1 class="page-title">Manage Products</h1>
        </div>
        <button type="button" class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addProductModal">
            <svg style="width:18px;height:18px;vertical-align:-3px;margin-right:4px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Add Product
        </button>
    </div>

    <asp:Panel ID="pnlPermissions" runat="server" CssClass="alert alert-info mb-4">
        Public editing is enabled, but changing stock quantity and deleting products requires an administrator login.
    </asp:Panel>

    <div class="card-table">
        <div style="overflow-x:auto">
        <asp:GridView ID="gvProducts" runat="server"
            CssClass="table table-hover align-middle" GridLines="None"
            AutoGenerateColumns="False" OnPreRender="gvProducts_PreRender" OnRowCommand="gvProducts_RowCommand" OnRowDataBound="gvProducts_RowDataBound">
            <Columns>
                <asp:BoundField DataField="Product_Name" HeaderText="Product Name" />
                <asp:BoundField DataField="Cetagory" HeaderText="Category" />
                <asp:BoundField DataField="Unit" HeaderText="Unit" />
                <asp:BoundField DataField="Product_code" HeaderText="Code" />
                <asp:BoundField DataField="Barcode_No" HeaderText="Barcode" />
                <asp:BoundField DataField="Unit_Price" HeaderText="Unit Price" DataFormatString="{0:N2}" />
                <asp:TemplateField HeaderText="Stock"><ItemTemplate>
                    <span class='<%# GetStockBadgeClass(Eval("Stock")) %>'><%# Eval("Stock", "{0:0.##}") %></span>
                </ItemTemplate></asp:TemplateField>

                <asp:TemplateField HeaderText="Actions" ItemStyle-Width="140px">
                    <ItemTemplate>
                        <div class="d-flex gap-2">
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditRow" CommandArgument='<%# Eval("ser") %>' CssClass="btn btn-sm btn-outline-primary" ToolTip="Edit">
                                <svg viewBox="0 0 24 24" style="width:14px;height:14px;fill:none;stroke:currentColor;stroke-width:2;stroke-linecap:round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("ser") %>' CssClass="btn btn-sm btn-outline-danger" ToolTip="Delete" OnClientClick="return confirm('Are you sure you want to delete this product?');">
                                <svg viewBox="0 0 24 24" style="width:14px;height:14px;fill:none;stroke:currentColor;stroke-width:2;stroke-linecap:round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        </div>
    </div>

    <div class="modal fade" id="addProductModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">

            <div class="modal-header">
                <h4 class="modal-title" runat="server" id="modalTitle">Add New Product</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body p-4">
                <div class="row g-3">
                    <div class="col-md-12">
                        <label class="form-label">Product Name</label>
                        <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Category</label>
                        <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Unit</label>
                        <asp:TextBox ID="txtUnit" runat="server" CssClass="form-control" Placeholder="kg, liter, piece..." />
                    </div>
                    <div class="col-12"><hr class="my-1" style="border-color:var(--border-light)"/></div>
                    <div class="col-md-6">
                        <label class="form-label">Product Code</label>
                        <asp:TextBox ID="txtProduct_Code" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Barcode</label>
                        <asp:TextBox ID="txtBarcode" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Unit Price (Tk)</label>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Available Stock</label>
                        <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" />
                        <small id="stockHelp" runat="server" class="text-muted d-block mt-1" style="font-size:.75rem"></small>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                <asp:Button ID="btnAddProduct" runat="server" Text="Save Product" CssClass="btn btn-primary px-4"
                    OnClick="btnAddProduct_Click" />
            </div>

    </div>
</div>
</div>
    <script>
        $(document).ready(function () {
            $('#<%= gvProducts.ClientID %>').DataTable({
                "pageLength": 10
            });
        });
    </script>
</asp:Content>
