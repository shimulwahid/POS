<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="POS.Products" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
        <h1>List of products</h1>
        <button type="button" class="btn btn-primary" 
        data-bs-toggle="modal" 
        data-bs-target="#addProductModal">
    + Add Product
        </button>
    </div>

    <div>
        <asp:GridView ID="gvProducts" runat="server" CssClass="table table-bordered table-striped">
</asp:GridView>
    </div>


    <div class="modal fade" id="addProductModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">

            <div class="modal-header">
                <h4 class="modal-title">Add New Product</h4>
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
</asp:Content>
