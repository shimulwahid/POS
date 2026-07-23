<%@ Page Title="Point of Sale" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="POS.aspx.cs" Inherits="POS.POS" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .pos-card { border: 0; border-radius: 1rem; box-shadow: 0 .25rem 1rem rgba(0,0,0,.08); }
        .scanner-input { font-size: 1.15rem; border-width: 2px; }
        .amount { font-variant-numeric: tabular-nums; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="container-fluid py-3 pe-4">
    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert" role="alert">
        <asp:Literal ID="litMessage" runat="server" />
    </asp:Panel>

    <div class="card pos-card mb-3">
        <div class="card-body">
            <label for="txtBarcode" class="form-label fw-semibold">Scan barcode or search products</label>
            <div class="input-group">
                <asp:TextBox ID="txtBarcode" runat="server" ClientIDMode="Static" CssClass="form-control scanner-input"
                    placeholder="Scan barcode and press Enter" autocomplete="off" />
                <asp:Button ID="btnScan" runat="server" Text="Add barcode" CssClass="btn btn-primary"
                    OnClick="btnScan_Click" UseSubmitBehavior="true" />
            </div>
            <small class="text-muted">USB barcode readers that act as a keyboard are supported. Keep this box focused while scanning.</small>
        </div>
    </div>

    <div class="row g-3">
        <div class="col-xl-7">
            <div class="card pos-card"><div class="card-body">
                <asp:GridView ID="gvProducts" runat="server" ClientIDMode="Static"
                    CssClass="table table-bordered table-hover align-middle" AutoGenerateColumns="False"
                    OnPreRender="gvProducts_PreRender" OnRowCommand="gvProducts_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Product_Name" HeaderText="Product" />
                        <asp:BoundField DataField="Product_Code" HeaderText="Code" />
                        <asp:BoundField DataField="Barcode_No" HeaderText="Barcode" />
                        <asp:BoundField DataField="Unit_Price" HeaderText="Price" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="Stock" HeaderText="Stock" DataFormatString="{0:0.##}" />
                        <asp:TemplateField HeaderText="Action"><ItemTemplate>
                            <asp:Button ID="btnAdd" runat="server" Text="Add" CssClass="btn btn-sm btn-success"
                                CommandName="AddToCart" CommandArgument='<%# Eval("ser") %>'
                                Enabled='<%# Convert.ToDecimal(Eval("Stock")) > 0 %>' />
                        </ItemTemplate></asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div></div>
        </div>

        <div class="col-xl-5">
            <div class="card pos-card"><div class="card-body">
                <h4 class="text-center fw-bold mb-3">Bill Summary</h4>
                <asp:GridView ID="gvCart" runat="server" DataKeyNames="ProductId"
                    CssClass="table table-sm table-bordered align-middle" AutoGenerateColumns="False"
                    EmptyDataText="Cart is empty" OnRowCommand="gvCart_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Product_Name" HeaderText="Item" />
                        <asp:TemplateField HeaderText="Qty" ItemStyle-Width="150px"><ItemTemplate>
                            <div class="input-group input-group-sm flex-nowrap">
                                <asp:Button ID="btnMinus" runat="server" Text="-" CssClass="btn btn-outline-secondary"
                                    CommandName="DecreaseQty" CommandArgument='<%# Eval("ProductId") %>' ToolTip="Reduce quantity" />
                                <asp:TextBox ID="txtQty" runat="server" Text='<%# Eval("Qty", "{0:0.##}") %>'
                                    CssClass="form-control text-center qtyBox" AutoPostBack="true"
                                    OnTextChanged="txtQty_TextChanged" />
                                <asp:Button ID="btnPlus" runat="server" Text="+" CssClass="btn btn-outline-secondary"
                                    CommandName="IncreaseQty" CommandArgument='<%# Eval("ProductId") %>' ToolTip="Increase quantity" />
                            </div>
                        </ItemTemplate></asp:TemplateField>
                        <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="{0:N2}" />
                        <asp:TemplateField><ItemTemplate>
                            <asp:Button ID="btnRemove" runat="server" Text="Remove" CommandName="RemoveItem"
                                CommandArgument='<%# Eval("ProductId") %>' CssClass="btn btn-danger btn-sm" />
                        </ItemTemplate></asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <div class="d-flex justify-content-between"><span>Subtotal:</span><asp:Label ID="lblSubtotal" runat="server" CssClass="amount" Text="0.00" /></div>
                <div class="row align-items-center my-2">
                    <label class="col-6">Discount:</label><div class="col-6">
                        <asp:TextBox ID="txtDiscount" runat="server" AutoPostBack="true" OnTextChanged="txtDiscount_TextChanged"
                            CssClass="form-control form-control-sm text-end amount" Text="0" />
                    </div>
                </div>
                <div class="d-flex justify-content-between fw-bold fs-5 border-top pt-2"><span>Grand Total:</span><asp:Label ID="lblGrandTotal" runat="server" CssClass="amount" Text="0.00" /></div>

                <hr />
                <div class="row g-2">
                    <div class="col-6"><label class="form-label">Payment method</label>
                        <asp:DropDownList ID="ddlPaymentMethod" runat="server" ClientIDMode="Static" CssClass="form-select">
                            <asp:ListItem Text="Cash" Value="Cash" /><asp:ListItem Text="Card" Value="Card" />
                            <asp:ListItem Text="Mobile Banking" Value="Mobile Banking" /><asp:ListItem Text="Other" Value="Other" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-6"><label class="form-label">Amount received</label>
                        <asp:TextBox ID="txtAmountPaid" runat="server" ClientIDMode="Static" CssClass="form-control text-end amount" placeholder="0.00" />
                    </div>
                    <div class="col-12" id="cashReturnField"><label class="form-label">Amount return</label>
                        <asp:TextBox ID="txtAmountReturn" runat="server" ClientIDMode="Static" CssClass="form-control text-end amount" Text="0.00" ReadOnly="true" />
                    </div>
                    <div class="col-12"><label class="form-label">Reference (optional)</label>
                        <asp:TextBox ID="txtPaymentReference" runat="server" CssClass="form-control" MaxLength="100" />
                    </div>
                </div>
                <asp:Button ID="btnCheckout" runat="server" Text="Complete payment & print receipt"
                    CssClass="btn btn-success btn-lg w-100 mt-3" OnClick="btnCheckout_Click" />
                <asp:Button ID="btnCancelCart" runat="server" Text="Cancel sale and return stock"
                    CssClass="btn btn-outline-danger w-100 mt-2" OnClick="btnCancelCart_Click"
                    OnClientClick="return confirm('Cancel this sale and return all reserved stock?');" />
            </div></div>
        </div>
    </div>
</div>
<script>
    $(function () {
        var table = $('#gvProducts').DataTable({ pageLength: 10, ordering: false });
        $('#txtBarcode').on('input', function () { table.search(this.value).draw(); });
        $('#txtBarcode').on('keydown', function (e) {
            if (e.key === 'Enter') { e.preventDefault(); document.getElementById('<%= btnScan.ClientID %>').click(); }
        });
        $('#txtBarcode').focus();
        function updateCashReturn() {
            var cash = $('#ddlPaymentMethod').val() === 'Cash';
            $('#cashReturnField').toggle(cash);
            if (cash) {
                var paid = parseFloat($('#txtAmountPaid').val()) || 0;
                var total = parseFloat('<%= lblGrandTotal.Text %>') || 0;
                $('#txtAmountReturn').val(Math.max(0, paid - total).toFixed(2));
            } else { $('#txtAmountReturn').val('0.00'); }
        }
        $('#ddlPaymentMethod, #txtAmountPaid').on('change input', updateCashReturn);
        updateCashReturn();
    });
</script>
</asp:Content>
