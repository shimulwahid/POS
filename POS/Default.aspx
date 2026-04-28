<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="POS.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <h1 class="text-center mt-3">Welcome to Shop</h1>
        <p class="text-center mt-3 ms-0">Here's what's happening with your shop today</p>
    </div>
    <div class="d-flex gap-3 justify-content-center">
        <div class="border-3 rounded-5 border border-dark-subtle w-25 bg-secondary bg-opacity-25">
            <p class="rounded-top-5 text-center bg-success text-white ms-0">Today's Sales</p>
            <p id="saleAmount" runat="server" class="text-center text-success fw-bold fs-4 ms-0">0.00 Taka</p>
            <p class="text-start text-dark ms-0">0 transactions</p>
        </div>

        <div class="border-3 rounded-5 border border-dark-subtle w-25 ">
            <p class="rounded-top-5 text-center bg-secondary text-white ms-0">Products in Stock</p>
            <p id="saleQty" class="text-center text-success fw-bold fs-4 ms-0">10</p>
            <div class="d-flex gap-2">
                <p class="text-bg-warning text-dark ms-0">0 low stock</p>
                <p class="text-bg-danger text-white ms-0">0 out of stock</p>
            </div>
        </div>
        <div class="border-3 rounded-5 border border-dark-subtle w-25 ">
            <p class="rounded-top-5 text-center bg-secondary text-white ms-0">Total sales today</p>
            <p id="saleQty" class="text-center text-success fw-bold fs-4 ms-0">3</p>
    
        </div>
    </div>

</asp:Content>
