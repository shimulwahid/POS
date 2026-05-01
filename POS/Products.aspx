<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="POS.Products" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .dataTables_filter {
        margin-bottom: 10px;
        }
        .dataTables_wrapper{
            margin-right:20px;
        }
        .dataTables_filter {
            float: right;
            text-align: right;
        }
    </style>
    <div class="d-flex align-items-center position-relative">
    <h1 class="mx-auto">List of products</h1>

    <button type="button"
        class="btn btn-primary position-absolute end-0 me-4"
        data-bs-toggle="modal"
        data-bs-target="#addProductModal">
        + Add Product
    </button>
</div>

    <div>
        <asp:GridView ID="gvProducts" runat="server"
    CssClass="table table-bordered table-striped datatable"
    AutoGenerateColumns="False" OnPreRender="gvProducts_PreRender" OnRowCommand="gvProducts_RowCommand" OnRowDataBound="gvProducts_RowDataBound">

    <Columns>
        <asp:BoundField DataField="ser" HeaderText="ID" />
        <asp:BoundField DataField="Product_Name" HeaderText="Product Name" />
        <asp:BoundField DataField="Cetagory" HeaderText="Category" />
        <asp:BoundField DataField="Unit" HeaderText="Unit" />
        <asp:BoundField DataField="Stock" HeaderText="Stock" />
        <asp:BoundField DataField="Unit_Price" HeaderText="Unit Price" />
        <asp:BoundField DataField="Product_code" HeaderText="Product Code" />
        <asp:BoundField DataField="Barcode_No" HeaderText="Barcode" />

        <asp:TemplateField HeaderText="Edit">
            <ItemTemplate>
                <asp:Button 
                    ID="btnEdit" 
                    runat="server" 
                    Text="Edit"
                    CssClass="btn btn-sm btn-warning"
                    CommandName="EditRow"
                    CommandArgument='<%# Eval("ser") %>' />
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Delete">
            <ItemTemplate>
                <asp:Button 
                    ID="btnDelete" 
                    runat="server" 
                    Text="Delete"
                    CssClass="btn btn-sm btn-danger"
                    CommandName="DeleteRow"
                    CommandArgument='<%# Eval("ser") %>'
                    OnClientClick="return confirm('Are you sure?');" />
            </ItemTemplate>
        </asp:TemplateField>

    </Columns>
</asp:GridView>
    </div>

    <div class="modal fade" id="addProductModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
        <div class="modal-content">

            <div class="modal-header">
                <h4 class="modal-title" runat="server" id="modalTitle">Add New Product</h4></asp:>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <div class="row">

                    <div class="col-md-12">
                        <label>Product Name</label>
                        <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control" />
                    </div>

                    <div class="col-md-6">
                        <label>Category</label>
                        <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control" />
                    </div>

                    <div class="col-md-6">
                        <label>Unit</label>
                        <asp:TextBox ID="txtUnit" runat="server" CssClass="form-control" Placeholder="kg, liter, piece..." />
                    </div>

                    <div class="col-md-6">
                        <label>Product Code</label>
                        <asp:TextBox ID="txtProduct_Code" runat="server" CssClass="form-control" />
                    </div>

                    <div class="col-md-6">
                        <label>Barcode</label>
                        <asp:TextBox ID="txtBarcode" runat="server" CssClass="form-control" />
                    </div>

                    <div class="col-md-6">
                        <label>Price</label>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" />
                    </div>

                    <div class="col-md-6">
                        <label>Stock</label>
                        <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" />
                    </div>

                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    Cancel
                </button>
                <asp:Button ID="btnAddProduct" runat="server" Text="Add Product" CssClass="btn btn-dark"
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
