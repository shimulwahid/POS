<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Receipt.aspx.cs" Inherits="POS.Receipt" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>Sales Receipt</title>
    <style>
        body { font-family: 'Inter', -apple-system, sans-serif; background: #e2e8f0; margin: 0; padding: 20px; color: #1e293b; }
        .receipt-card { background: #fff; width: 100%; max-width: 420px; margin: 0 auto; padding: 30px 24px; box-shadow: 0 10px 25px rgba(0,0,0,.08); border-radius: 12px; }
        .r-header { text-align: center; margin-bottom: 24px; }
        .r-title { font-weight: 800; font-size: 1.6rem; letter-spacing: -0.03em; margin: 0 0 4px; color: #6366f1; }
        .r-subtitle { font-size: .85rem; color: #64748b; margin: 0; }
        .r-info { display: flex; justify-content: space-between; font-size: .85rem; margin-bottom: 16px; border-bottom: 1px dashed #cbd5e1; padding-bottom: 12px; }
        .r-info-val { font-weight: 600; }
        .r-table { width: 100%; border-collapse: collapse; margin-bottom: 16px; font-size: .9rem; }
        .r-table th { text-align: left; padding: 8px 0; border-bottom: 1px solid #e2e8f0; color: #64748b; font-weight: 600; font-size: .8rem; }
        .r-table td { padding: 8px 0; vertical-align: top; }
        .r-table td.qty { text-align: center; }
        .r-table td.amt { text-align: right; font-weight: 500; }
        .r-totals { margin-top: 12px; padding-top: 12px; border-top: 1px dashed #cbd5e1; }
        .r-row { display: flex; justify-content: space-between; font-size: .95rem; margin-bottom: 6px; }
        .r-grand { font-size: 1.3rem; font-weight: 800; color: #0f172a; margin: 12px 0; padding: 12px 0; border-top: 2px solid #e2e8f0; border-bottom: 2px solid #e2e8f0; }
        .r-footer { text-align: center; font-size: .8rem; color: #64748b; margin-top: 24px; }
        .btn-print { display: block; width: 100%; max-width: 420px; margin: 20px auto 0; padding: 12px; background: #6366f1; color: #fff; border: 0; border-radius: 8px; font-weight: 600; font-size: 1rem; cursor: pointer; transition: background .2s; }
        .btn-print:hover { background: #4f46e5; }
        .btn-print svg { width: 18px; height: 18px; fill: none; stroke: currentColor; stroke-width: 2; vertical-align: -3px; margin-right: 6px; }
        @media print { body { background: #fff; padding: 0; } .receipt-card { box-shadow: none; border-radius: 0; margin: 0; max-width: 80mm; padding: 5mm; } .btn-print { display: none; } }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Panel ID="pnlError" runat="server" Visible="false" style="color:#ef4444;text-align:center;padding:20px;font-weight:600;"><asp:Literal ID="litError" runat="server" /></asp:Panel>
        
        <asp:Panel ID="pnlReceipt" runat="server" CssClass="receipt-card">
            <div class="r-header">
                <h1 class="r-title"><asp:Literal ID="litShopName" runat="server" /></h1>
                <p class="r-subtitle"><asp:Literal ID="litShopAddress" runat="server" /></p>
            </div>
            
            <div class="r-info">
                <div>Receipt: <span class="r-info-val">#<asp:Literal ID="litOrderNo" runat="server" /></span></div>
                <div><span class="r-info-val"><asp:Literal ID="litDate" runat="server" /></span></div>
            </div>

            <asp:GridView ID="gvItems" runat="server" AutoGenerateColumns="false" ShowHeaderWhenEmpty="true" GridLines="None" CssClass="r-table">
                <Columns>
                    <asp:BoundField DataField="Product_Name" HeaderText="Item" />
                    <asp:BoundField DataField="Qty" HeaderText="Qty" DataFormatString="{0:0.##}" ItemStyle-CssClass="qty" HeaderStyle-CssClass="qty" />
                    <asp:BoundField DataField="Total_Price" HeaderText="Total" DataFormatString="{0:N2}" ItemStyle-CssClass="amt" HeaderStyle-CssClass="amt" />
                </Columns>
            </asp:GridView>

            <div class="r-totals">
                <div class="r-row"><span>Subtotal</span><span><asp:Literal ID="litSubtotal" runat="server" /></span></div>
                <div class="r-row"><span>Discount</span><span><asp:Literal ID="litDiscount" runat="server" /></span></div>
                <div class="r-row r-grand"><span>Grand Total</span><span>Tk <asp:Literal ID="litTotal" runat="server" /></span></div>
                <div class="r-row"><span>Payment (<asp:Literal ID="litMethod" runat="server" />)</span><span><asp:Literal ID="litPaid" runat="server" /></span></div>
                <div class="r-row"><span>Change</span><span><asp:Literal ID="litChange" runat="server" /></span></div>
            </div>

            <div class="r-footer">Please keep this receipt for your records.<br />Have a great day!</div>
        </asp:Panel>

        <button type="button" class="btn-print" onclick="window.print();">
            <svg viewBox="0 0 24 24"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
            Print Receipt
        </button>
        <div style="text-align:center;margin-top:16px;">
            <a href="POS.aspx" style="color:#6366f1;text-decoration:none;font-weight:600;font-size:.9rem;">&larr; Back to POS</a>
        </div>
    </form>
    <script>
        var params = new URLSearchParams(window.location.search);
        if(params.get('print') === '1') { window.print(); }
    </script>
</body>
</html>
