<%@ Page Title="Sales" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="POS.Reports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="container-fluid py-4 pe-4"><div class="d-flex justify-content-between align-items-center mb-3"><h2>Sales history</h2></div>
<asp:Panel ID="pnlNoSales" runat="server" Visible="false" CssClass="alert alert-info">No completed sales yet.</asp:Panel>
<asp:GridView ID="gvSales" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-striped" OnRowCommand="gvSales_RowCommand">
<Columns><asp:BoundField DataField="Order_No" HeaderText="Receipt #" /><asp:BoundField DataField="Sale_Date" HeaderText="Date" DataFormatString="{0:dd-MMM-yyyy hh:mm tt}" />
<asp:BoundField DataField="Grand_Total" HeaderText="Total" DataFormatString="{0:N2}" /><asp:BoundField DataField="Payment_Method" HeaderText="Payment" />
<asp:TemplateField><ItemTemplate><asp:Button ID="btnReceipt" runat="server" Text="View / print" CssClass="btn btn-sm btn-outline-dark" CommandName="Receipt" CommandArgument='<%# Eval("Order_No") %>' /></ItemTemplate></asp:TemplateField></Columns>
</asp:GridView></div></asp:Content>
