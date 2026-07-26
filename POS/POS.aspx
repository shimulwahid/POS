<%@ Page Title="Point of Sale" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="POS.aspx.cs" Inherits="POS.POS" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .pos-wrap { padding: 20px 24px 24px; }
        .pos-card { border: 0; border-radius: var(--radius-lg); box-shadow: var(--shadow-sm); }
        .amount { font-variant-numeric: tabular-nums; }

        /* ── Scanner Bar ── */
        .scanner-card { background: linear-gradient(135deg, #eef2ff 0%, #e0e7ff 100%); border: 1px solid #c7d2fe; }
        .scanner-input {
            font-size: 1.1rem; border-width: 2px; border-color: var(--accent-light);
            padding: 12px 16px 12px 44px; background: #fff;
        }
        .scanner-input:focus { border-color: var(--accent); box-shadow: 0 0 0 4px var(--accent-glow), 0 0 20px rgba(99,102,241,.1); }
        .scanner-icon {
            position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
            color: var(--accent); z-index: 2;
        }
        .scanner-icon svg { width: 20px; height: 20px; fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; }

        /* ── Catalog Panel ── */
        .panel-header {
            padding: 16px 20px; border-bottom: 1px solid var(--border-light);
            display: flex; justify-content: space-between; align-items: center;
        }
        .panel-title { font-weight: 700; font-size: 1rem; margin: 0; display: flex; align-items: center; gap: 8px; }
        .panel-title svg { width: 18px; height: 18px; fill: none; stroke: var(--accent); stroke-width: 2; stroke-linecap: round; }
        .panel-body { padding: 16px 20px; }
        .product-table-wrap { width: 100%; overflow-x: auto; }
        #gvProducts { width: 100% !important; margin: 0 !important; }
        #gvProducts thead th {
            color: #334155; font-size: .78rem; font-weight: 700;
            text-transform: uppercase; white-space: nowrap;
        }
        #gvProducts tbody td { white-space: nowrap; }
        #gvProducts_wrapper .dataTables_length,
        #gvProducts_wrapper .dataTables_filter { margin-bottom: 12px; }
        #gvProducts_wrapper .dt-toolbar,
        #gvProducts_wrapper .dt-footer {
            display: flex; align-items: center; justify-content: space-between;
            gap: 12px; flex-wrap: wrap;
        }
        #gvProducts_wrapper .dataTables_length label,
        #gvProducts_wrapper .dataTables_filter label {
            color: #0f172a; font-size: .9rem; font-weight: 500;
        }
        #gvProducts_wrapper .dataTables_length select {
            min-width: 64px; margin: 0 5px; padding: 6px 25px 6px 9px;
            background-color: #fff;
        }
        #gvProducts_wrapper .dataTables_filter input {
            min-width: 190px; margin-left: 8px; padding: 7px 10px;
            background: #fff;
        }
        #gvProducts_wrapper .dataTables_info,
        #gvProducts_wrapper .dataTables_paginate {
            margin-top: 10px; font-size: .86rem;
        }
        #gvProducts_wrapper .dataTables_paginate .paginate_button {
            border-radius: 6px !important;
        }
        .btn-add-cart {
            background: linear-gradient(135deg, #10b981, #059669); border: 0; color: #fff;
            padding: 5px 14px; border-radius: 8px; font-weight: 600; font-size: .82rem;
            display: inline-flex; align-items: center; gap: 5px; transition: all var(--transition);
        }
        .btn-add-cart:hover { background: linear-gradient(135deg, #34d399, #10b981); transform: translateY(-1px); box-shadow: 0 4px 12px rgba(16,185,129,.3); color:#fff; }
        .btn-add-cart:disabled { opacity: .4; transform: none; box-shadow: none; }
        .btn-add-cart svg { width: 14px; height: 14px; fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; }
        .stock-badge { font-size: .75rem; font-weight: 600; padding: 3px 10px; border-radius: 999px; }
        .stock-ok { background: #ecfdf5; color: #065f46; }
        .stock-low { background: #fffbeb; color: #92400e; }
        .stock-out { background: #fef2f2; color: #991b1b; }

        /* ── Cart Panel ── */
        .cart-panel { position: sticky; top: 80px; }
        .cart-header {
            background: linear-gradient(135deg, #0f172a, #1e293b); color: #fff;
            padding: 18px 20px; border-radius: var(--radius-lg) var(--radius-lg) 0 0;
            display: flex; justify-content: space-between; align-items: center;
        }
        .cart-title { font-weight: 700; font-size: 1.05rem; display: flex; align-items: center; gap: 8px; }
        .cart-title svg { width: 18px; height: 18px; fill: none; stroke: #818cf8; stroke-width: 2; stroke-linecap: round; }
        .cart-count {
            background: var(--accent); color: #fff; font-size: .72rem; font-weight: 700;
            padding: 2px 8px; border-radius: 999px; min-width: 22px; text-align: center;
        }
        .cart-body { padding: 16px 20px; }

        /* Qty Controls */
        .qty-wrap { display: inline-flex; align-items: center; gap: 4px; }
        .qty-btn {
            width: 30px; height: 30px; border-radius: 50%; border: 1.5px solid var(--border);
            background: #fff; color: var(--text); font-weight: 700; font-size: .9rem;
            display: flex; align-items: center; justify-content: center; cursor: pointer;
            transition: all var(--transition); padding: 0;
        }
        .qty-btn:hover { border-color: var(--accent); color: var(--accent); background: var(--accent-surface); }
        .qty-input { width: 50px; text-align: center; border: 1.5px solid var(--border); border-radius: 8px; font-weight: 600; padding: 4px; font-size: .88rem; }
        .qty-input:focus { border-color: var(--accent); outline: none; box-shadow: 0 0 0 2px var(--accent-glow); }
        .btn-remove {
            background: none; border: 0; color: #ef4444; cursor: pointer; padding: 4px;
            border-radius: 6px; transition: all var(--transition);
        }
        .btn-remove:hover { background: #fef2f2; }
        .btn-remove svg { width: 16px; height: 16px; fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; }

        /* Totals */
        .totals-row { display: flex; justify-content: space-between; align-items: center; padding: 8px 0; font-size: .92rem; }
        .totals-row.grand {
            background: linear-gradient(135deg, #eef2ff, #e0e7ff);
            margin: 12px -20px; padding: 14px 20px;
            font-size: 1.15rem; font-weight: 800; color: var(--accent);
            border-radius: 10px;
        }
        .pay-section { border-top: 1px solid var(--border-light); padding-top: 16px; margin-top: 8px; }
        .pay-label { font-size: .84rem; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px; }
        .currency-input { position: relative; }
        .currency-input .prefix {
            position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
            color: var(--text-muted); font-weight: 600; font-size: .88rem;
        }
        .currency-input input { padding-left: 32px; }

        .btn-checkout {
            background: linear-gradient(135deg, #10b981, #059669); border: 0;
            font-weight: 700; font-size: 1rem; padding: 14px;
            box-shadow: 0 4px 16px rgba(16,185,129,.3);
            transition: all var(--transition); display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        .btn-checkout:hover { background: linear-gradient(135deg, #34d399, #10b981); transform: translateY(-2px); box-shadow: 0 6px 24px rgba(16,185,129,.4); }
        .btn-checkout svg { width: 20px; height: 20px; fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; }
        .btn-cancel { font-weight: 600; font-size: .88rem; }

        @media (max-width: 768px) {
            .pos-wrap { padding: 14px; }
            .cart-panel { position: static; }
            #gvProducts_wrapper .dt-toolbar,
            #gvProducts_wrapper .dt-footer { align-items: stretch; flex-direction: column; }
            #gvProducts_wrapper .dataTables_filter,
            #gvProducts_wrapper .dataTables_length { text-align: left; }
            #gvProducts_wrapper .dataTables_filter input { min-width: 0; width: calc(100% - 68px); }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<asp:UpdatePanel ID="upSale" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
<ContentTemplate>
<div class="pos-wrap">
    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert" role="alert">
        <asp:Literal ID="litMessage" runat="server" />
    </asp:Panel>

    <!-- Scanner Bar -->
    <div class="card pos-card scanner-card mb-3">
        <div class="card-body py-3 px-4">
            <label for="txtBarcode" class="form-label fw-semibold" style="color:var(--accent-text)">
                <svg style="width:16px;height:16px;vertical-align:-2px;margin-right:4px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="4 7 4 4 20 4 20 7"/><polyline points="4 17 4 20 20 20 20 17"/><line x1="6" y1="9" x2="6" y2="15"/><line x1="10" y1="9" x2="10" y2="15"/><line x1="14" y1="9" x2="14" y2="15"/><line x1="18" y1="9" x2="18" y2="15"/></svg>
                Scan barcode or search products
            </label>
            <div class="input-group">
                <div style="position:relative;flex:1">
                    <span class="scanner-icon"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg></span>
                    <asp:TextBox ID="txtBarcode" runat="server" ClientIDMode="Static" CssClass="form-control scanner-input"
                        placeholder="Scan barcode or type product name and press Enter" autocomplete="off" />
                </div>
                <asp:Button ID="btnScan" runat="server" Text="Add" CssClass="btn btn-primary px-4"
                    OnClick="btnScan_Click" UseSubmitBehavior="true" />
            </div>
            <small class="text-muted mt-1 d-block" style="font-size:.78rem">USB barcode readers are supported. Keep this box focused while scanning.</small>
        </div>
    </div>

    <div class="row g-3">
        <!-- Product Catalog -->
        <div class="col-xl-7">
            <div class="card pos-card">
                <div class="panel-header">
                    <div class="panel-title">
                        <svg viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                        Product Catalog
                    </div>
                </div>
                <div class="panel-body">
                <div class="product-table-wrap">
                    <asp:GridView ID="gvProducts" runat="server" ClientIDMode="Static"
                        CssClass="table table-hover align-middle" AutoGenerateColumns="False"
                        OnPreRender="gvProducts_PreRender" OnRowCommand="gvProducts_RowCommand" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="Product_Name" HeaderText="Product" />
                            <asp:BoundField DataField="Product_Code" HeaderText="Code" />
                            <asp:BoundField DataField="Barcode_No" HeaderText="Barcode" />
                            <asp:BoundField DataField="Unit_Price" HeaderText="Price" DataFormatString="{0:N2}" />
                            <asp:TemplateField HeaderText="Stock"><ItemTemplate>
                                <span class='<%# GetStockBadgeClass(Eval("Stock")) %>'><%# Eval("Stock", "{0:0.##}") %></span>
                            </ItemTemplate></asp:TemplateField>
                            <asp:TemplateField HeaderText="Action"><ItemTemplate>
                                <asp:Button ID="btnAdd" runat="server" Text="Add" CssClass="btn-add-cart"
                                    CommandName="AddToCart" CommandArgument='<%# Eval("ser") %>'
                                    Enabled='<%# Convert.ToDecimal(Eval("Stock")) > 0 %>' />
                            </ItemTemplate></asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                </div>
            </div>
        </div>

        <!-- Cart / Bill Summary -->
        <div class="col-xl-5">
            <div class="card pos-card cart-panel">
                <div class="cart-header">
                    <div class="cart-title">
                        <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
                        Bill Summary
                    </div>
                    <span class="cart-count" id="cartCount" runat="server">0</span>
                </div>
                <div class="cart-body">
                <asp:GridView ID="gvCart" runat="server" DataKeyNames="ProductId"
                    CssClass="table table-sm align-middle" AutoGenerateColumns="False"
                    EmptyDataText="Cart is empty - scan a barcode to begin" OnRowCommand="gvCart_RowCommand" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="Product_Name" HeaderText="Item" />
                        <asp:TemplateField HeaderText="Qty" ItemStyle-Width="140px"><ItemTemplate>
                            <div class="qty-wrap">
                                <asp:Button ID="btnMinus" runat="server" Text="-" CssClass="qty-btn"
                                    CommandName="DecreaseQty" CommandArgument='<%# Eval("ProductId") %>' ToolTip="Reduce quantity" />
                                <asp:TextBox ID="txtQty" runat="server" Text='<%# Eval("Qty", "{0:0.##}") %>'
                                    CssClass="qty-input" AutoPostBack="true"
                                    OnTextChanged="txtQty_TextChanged" />
                                <asp:Button ID="btnPlus" runat="server" Text="+" CssClass="qty-btn"
                                    CommandName="IncreaseQty" CommandArgument='<%# Eval("ProductId") %>' ToolTip="Increase quantity" />
                            </div>
                        </ItemTemplate></asp:TemplateField>
                        <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="{0:N2}" />
                        <asp:TemplateField><ItemTemplate>
                            <asp:LinkButton ID="btnRemove" runat="server" CommandName="RemoveItem"
                                CommandArgument='<%# Eval("ProductId") %>' CssClass="btn-remove" ToolTip="Remove item">
                                <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                            </asp:LinkButton>
                        </ItemTemplate></asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <div class="totals-row"><span>Subtotal</span><asp:Label ID="lblSubtotal" runat="server" CssClass="amount fw-semibold" Text="0.00" /></div>
                <div class="totals-row">
                    <span>Discount</span>
                    <asp:TextBox ID="txtDiscount" runat="server" AutoPostBack="true" OnTextChanged="txtDiscount_TextChanged"
                        CssClass="form-control form-control-sm text-end amount" Text="0" style="width:100px" />
                </div>
                <div class="totals-row grand"><span>Grand Total</span><asp:Label ID="lblGrandTotal" runat="server" CssClass="amount" Text="0.00" /></div>

                <div class="pay-section">
                    <div class="row g-2">
                        <div class="col-6">
                            <div class="pay-label">Payment method</div>
                            <asp:DropDownList ID="ddlPaymentMethod" runat="server" ClientIDMode="Static" CssClass="form-select">
                                <asp:ListItem Text="Cash" Value="Cash" /><asp:ListItem Text="Card" Value="Card" />
                                <asp:ListItem Text="Mobile Banking" Value="Mobile Banking" /><asp:ListItem Text="Other" Value="Other" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-6">
                            <div class="pay-label">Amount received</div>
                            <div class="currency-input">
                                <span class="prefix">Tk</span>
                                <asp:TextBox ID="txtAmountPaid" runat="server" ClientIDMode="Static" CssClass="form-control text-end amount" placeholder="0.00" />
                            </div>
                        </div>
                        <div class="col-12" id="cashReturnField">
                            <div class="pay-label">Amount return</div>
                            <div class="currency-input">
                                <span class="prefix">Tk</span>
                                <asp:TextBox ID="txtAmountReturn" runat="server" ClientIDMode="Static" CssClass="form-control text-end amount" Text="0.00" ReadOnly="true" />
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="pay-label">Reference (optional)</div>
                            <asp:TextBox ID="txtPaymentReference" runat="server" CssClass="form-control" MaxLength="100" placeholder="Transaction ID, receipt number..." />
                        </div>
                    </div>
                </div>

                <asp:Button ID="btnCheckout" runat="server" Text="Complete Payment & Print Receipt"
                    CssClass="btn btn-checkout btn-lg w-100 mt-3 text-white" OnClick="btnCheckout_Click" />
                <asp:Button ID="btnCancelCart" runat="server" Text="Cancel sale & return stock"
                    CssClass="btn btn-outline-danger btn-cancel w-100 mt-2" OnClick="btnCancelCart_Click"
                    OnClientClick="return confirm('Cancel this sale and return all reserved stock?');" />
                </div>
            </div>
        </div>
    </div>
</div>
</ContentTemplate>
</asp:UpdatePanel>
<script>
    function initializeSalePage() {
        if (!window.jQuery || !$.fn.DataTable) return;

        if ($.fn.DataTable.isDataTable('#gvProducts')) {
            $('#gvProducts').DataTable().destroy();
        }

        var table = $('#gvProducts').DataTable({
            pageLength: 10,
            lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
            paging: true,
            searching: true,
            info: true,
            ordering: false,
            autoWidth: false,
            dom: '<"dt-toolbar"lf>rt<"dt-footer"ip>',
            language: {
                lengthMenu: 'Show _MENU_ entries',
                search: 'Search:',
                searchPlaceholder: '',
                info: 'Showing _START_ to _END_ of _TOTAL_ entries',
                infoEmpty: 'Showing 0 to 0 of 0 entries',
                zeroRecords: 'No matching products found',
                paginate: { previous: 'Previous', next: 'Next' }
            }
        });
        $('#txtBarcode').off('.posSale');
        $('#ddlPaymentMethod, #txtAmountPaid').off('.posSale');

        $('#txtBarcode').on('input.posSale', function () { table.search(this.value).draw(); });
        $('#txtBarcode').on('keydown.posSale', function (e) {
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
        $('#ddlPaymentMethod, #txtAmountPaid').on('change.posSale input.posSale', updateCashReturn);
        updateCashReturn();
    }

    $(initializeSalePage);

    if (window.Sys && Sys.WebForms) {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            initializeSalePage();
        });
    }
</script>
</asp:Content>
