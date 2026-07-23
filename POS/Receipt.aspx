<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Receipt.aspx.cs" Inherits="POS.Receipt" %>
<!DOCTYPE html>
<html><head runat="server"><title>Sales Receipt</title>
<style>
    * { box-sizing:border-box; } body { margin:0; background:#eee; font-family:Consolas,'Courier New',monospace; color:#000; }
    .receipt { width:80mm; min-height:100mm; margin:12px auto; padding:5mm; background:#fff; font-size:12px; }
    h1 { font:700 20px Arial,sans-serif; text-align:center; margin:0 0 3px; } .center{text-align:center}.right{text-align:right}
    table { width:100%; border-collapse:collapse; } th,td { padding:2px 0; vertical-align:top; } th { border-bottom:1px dashed #000; text-align:left; }
    .rule { border-top:1px dashed #000; margin:6px 0; } .totals td:first-child{text-align:right;padding-right:8px}.grand{font-size:15px;font-weight:bold}
    .actions { text-align:center; margin:12px; font-family:Arial,sans-serif; } button,a { padding:9px 14px;margin:3px; }
    @page { size:80mm auto; margin:0; }
    @media print { body{background:#fff}.receipt{margin:0;width:80mm;box-shadow:none}.actions{display:none} }
</style></head><body>
<form id="form1" runat="server">
<asp:Panel ID="pnlReceipt" runat="server" CssClass="receipt">
    <h1><asp:Literal ID="litShopName" runat="server" /></h1>
    <div class="center"><asp:Literal ID="litShopAddress" runat="server" /></div><div class="rule"></div>
    <table><tr><td>Receipt #</td><td class="right"><asp:Literal ID="litOrderNo" runat="server" /></td></tr>
    <tr><td>Date</td><td class="right"><asp:Literal ID="litDate" runat="server" /></td></tr></table>
    <div class="rule"></div>
    <asp:GridView ID="gvItems" runat="server" AutoGenerateColumns="false" ShowHeaderWhenEmpty="true" GridLines="None">
        <Columns><asp:BoundField DataField="Product_Name" HeaderText="Item" />
        <asp:BoundField DataField="Qty" HeaderText="Qty" DataFormatString="{0:0.##}" ItemStyle-CssClass="right" />
        <asp:BoundField DataField="Unit_Price" HeaderText="Price" DataFormatString="{0:N2}" ItemStyle-CssClass="right" />
        <asp:BoundField DataField="Total_Price" HeaderText="Total" DataFormatString="{0:N2}" ItemStyle-CssClass="right" /></Columns>
    </asp:GridView>
    <div class="rule"></div><table class="totals">
        <tr><td>Subtotal</td><td class="right"><asp:Literal ID="litSubtotal" runat="server" /></td></tr>
        <tr><td>Discount</td><td class="right"><asp:Literal ID="litDiscount" runat="server" /></td></tr>
        <tr class="grand"><td>TOTAL</td><td class="right"><asp:Literal ID="litTotal" runat="server" /></td></tr>
        <tr><td>Paid</td><td class="right"><asp:Literal ID="litPaid" runat="server" /></td></tr>
        <tr><td>Change</td><td class="right"><asp:Literal ID="litChange" runat="server" /></td></tr>
        <tr><td>Payment</td><td class="right"><asp:Literal ID="litMethod" runat="server" /></td></tr>
        <asp:PlaceHolder ID="phReference" runat="server"><tr><td>Reference</td><td class="right"><asp:Literal ID="litReference" runat="server" /></td></tr></asp:PlaceHolder>
    </table><div class="rule"></div><div class="center">Thank you for shopping with us!</div>
</asp:Panel>
<asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="receipt center"><asp:Literal ID="litError" runat="server" /></asp:Panel>
<div class="actions"><button type="button" onclick="window.print()">Print receipt</button><a href="POS.aspx">New sale</a></div>
</form>
<asp:Literal ID="litAutoPrint" runat="server" />
</body></html>
