<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="POS.aspx.cs" Inherits="POS.POS" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid py-3">

    <!-- TOP SEARCH BAR -->
    <div class="row mb-3">
        <div class="col-md-8">
            <div class="input-group">
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="form-control"
                    placeholder="Scan barcode / Enter product code / search product..." />

                <asp:Button ID="btnSearch" runat="server"
                    Text="Search"
                    CssClass="btn btn-primary"
                    OnClick="btnSearch_Click" />
            </div>
        </div>
    </div>

    <!-- MAIN SECTION -->
    <div class="row g-3">

        <!-- LEFT: PRODUCT LIST -->
        <div class="col-md-7">

            <asp:GridView ID="gvProducts" runat="server"
                CssClass="table table-bordered table-hover"
                AutoGenerateColumns="False"
                OnRowCommand="gvProducts_RowCommand">

                <Columns>

                    <asp:BoundField DataField="Product_Name" HeaderText="Product" />
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

        <!-- RIGHT: BILL PANEL -->
        <div class="col-md-5">

            <div class="border rounded-4 shadow-sm bg-light p-3">

                <h5 class="text-center fw-bold mb-3">Bill Summary</h5>

                <!-- CART TABLE -->
                <asp:GridView ID="gvCart" runat="server"
                    CssClass="table table-sm table-bordered"
                    AutoGenerateColumns="False">

                    <Columns>
                        <asp:BoundField DataField="Product_Name" HeaderText="Item" />
                        <asp:BoundField DataField="Qty" HeaderText="Qty" />
                        <asp:BoundField DataField="Price" HeaderText="Price" />
                        <asp:BoundField DataField="Total" HeaderText="Total" />
                    </Columns>

                </asp:GridView>

                <hr />

                <!-- TOTALS -->
                <div class="d-flex justify-content-between">
                    <span>Subtotal:</span>
                    <asp:Label ID="lblSubtotal" runat="server" Text="0.00"></asp:Label>
                </div>

                <div class="d-flex justify-content-between">
                    <span>Discount:</span>
                    <asp:TextBox ID="txtDiscount" runat="server"
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
</asp:Content>
