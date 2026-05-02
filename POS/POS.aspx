<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="POS.aspx.cs" Inherits="POS.POS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <!-- DataTables -->
    <%--<link href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" rel="stylesheet" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>--%>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container-fluid py-3">

    <!-- ✅ CUSTOM SEARCH BAR -->
    <div class="row mb-3">
        <div class="col-md-6">
            <input type="text" id="customSearch"
                class="form-control"
                placeholder="Scan barcode / search product..." />
        </div>
    </div>

    <div class="row g-3">

        <!-- LEFT -->
        <div class="col-md-7">

            <asp:GridView ID="gvProducts" runat="server"
                ClientIDMode="Static"
                CssClass="table table-bordered table-hover"
                AutoGenerateColumns="False"
                OnPreRender="gvProducts_PreRender"
                OnRowCommand="gvProducts_RowCommand">

                <Columns>
                    <asp:BoundField DataField="Product_Name" HeaderText="Product" />
                    <asp:BoundField DataField="Product_Code" HeaderText="Code" />
                    <asp:BoundField DataField="Barcode_No" HeaderText="Barcode" />
                    <asp:BoundField DataField="Unit_Price" HeaderText="Price" />
                    <asp:BoundField DataField="Stock" HeaderText="Stock" />

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button ID="btnAdd" runat="server"
                                Text="Add"
                                CssClass="btn btn-sm btn-success"
                                CommandName="AddToCart"
                                CommandArgument='<%# Eval("ser") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

            </asp:GridView>

        </div>

        <!-- RIGHT -->
        <div class="col-md-5">

            <div class="border rounded-4 shadow-sm bg-light p-3">

                <h5 class="text-center fw-bold mb-3">Bill Summary</h5>

                <asp:GridView ID="gvCart" runat="server"
                    DataKeyNames="ProductId"
                    CssClass="table table-sm table-bordered"
                    AutoGenerateColumns="False"
                    OnRowCommand="gvCart_RowCommand">

                    <Columns>
                        <asp:BoundField DataField="Product_Name" HeaderText="Item" />
                        
                        <asp:TemplateField HeaderText="Qty" ItemStyle-Width="80px" HeaderStyle-Width="80px">
                            <ItemTemplate>
                                <asp:TextBox ID="txtQty" runat="server"
                                    Text='<%# Eval("Qty") %>'
                                    CssClass="form-control text-center form-control-sm text-end qtyBox"
                                    AutoPostBack="true"
                                    OnTextChanged="txtQty_TextChanged"
                                    CommandArgument='<%# Eval("ProductId") %>'>
                                </asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Price" HeaderText="Price" />
                        <asp:BoundField DataField="Total" HeaderText="Total" />

                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:Button ID="btnRemove" runat="server"
                                    Text="X"
                                    CommandName="RemoveItem"
                                    CommandArgument='<%# Eval("ProductId") %>'
                                    CssClass="btn btn-danger btn-sm" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>

                </asp:GridView>

                <hr />

                <div class="d-flex justify-content-between">
                    <span>Subtotal:</span>
                    <asp:Label ID="lblSubtotal" runat="server" Text="0.00"></asp:Label>
                </div>

                <div class="d-flex justify-content-between">
                    <span>Discount:</span>
                    <asp:TextBox ID="txtDiscount" runat="server"
                        AutoPostBack="true"
                        OnTextChanged="txtDiscount_TextChanged"
                        CssClass="form-control form-control-sm w-50 text-end" Text="0" />
                </div>

                <div class="d-flex justify-content-between fw-bold fs-5 mt-2">
                    <span>Grand Total:</span>
                    <asp:Label ID="lblGrandTotal" runat="server" Text="0.00"></asp:Label>
                </div>

                <hr />

                <asp:Button ID="btnCheckout" runat="server"
                    Text="Checkout"
                    CssClass="btn btn-success w-100"
                    OnClick="btnCheckout_Click" />

            </div>

        </div>

    </div>
</div>

<!-- ✅ DATATABLES SCRIPT -->
<script>
    $(document).ready(function () {

        var table = $('#gvProducts').DataTable({
            dom: 't', // 🔥 hide default search + pagination UI
            ordering: false
        });

        // ✅ connect your custom search box
        $('#customSearch').on('keyup', function () {
            table.search(this.value).draw();
        });

        // auto focus (for barcode scanner)
        $('#customSearch').focus();
    });

    //Auto add when barcode scanned
    $('#customSearch').on('change', function () {
        var value = this.value.trim();

        if (value.length > 0) {
            // try auto click first matching row
            var table = $('#gvProducts').DataTable();
            table.search(value).draw();

            setTimeout(function () {
                $('#gvProducts tbody tr:first .btn-success').click();
            }, 200);

            $('#customSearch').val('').focus();
        }
    });
</script>

</asp:Content>