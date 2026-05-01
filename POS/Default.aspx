<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="POS.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
 <div class="container-fluid py-3">

    <!-- Header -->
    <div class="text-center mb-4">
        <h2 class="fw-bold">Welcome to Shop</h2>
        <p class="text-muted mb-0">Here's what's happening with your shop today</p>
    </div>

    <!-- Dashboard Cards -->
    <div class="row g-4 justify-content-center">

        <!-- Sales -->
        <div class="col-md-4 col-12">
            <div class="border border-success border-2 rounded-4 bg-success bg-opacity-10 shadow-sm h-100">

                <div class="bg-success text-white text-center py-2 rounded-top-4 fw-semibold">
                    Today's Sales
                </div>

                <div class="p-4 text-center">
                    <div id="saleAmount" runat="server" class="text-success fw-bold fs-2">
                        0.00 Taka
                    </div>
                    <div class="text-muted small mt-2">
                        0 transactions
                    </div>
                </div>

            </div>
        </div>

        <!-- Stock -->
        <div class="col-md-4 col-12">
            <div class="border border-primary border-2 rounded-4 bg-primary bg-opacity-10 shadow-sm h-100">

                <div class="bg-primary text-white text-center py-2 rounded-top-4 fw-semibold">
                    Products in Stock
                </div>

                <div class="p-4 text-center">

                    <div id="productQty" runat="server" class="text-primary fw-bold fs-2">
                        10
                    </div>

                    <div class="d-flex justify-content-center gap-2 mt-3 flex-wrap">

                        <span id="low_stock_Count" runat="server" class="badge bg-warning text-dark">
                            0 Low Stock
                        </span>

                        <span id="out_of_stock_Count" runat="server" class="badge bg-danger">
                            0 Out of Stock
                        </span>

                    </div>

                </div>

            </div>
        </div>

        <!-- Total Sales -->
        <div class="col-md-4 col-12">
            <div class="border border-dark border-2 rounded-4 bg-dark bg-opacity-10 shadow-sm h-100">

                <div class="bg-dark text-white text-center py-2 rounded-top-4 fw-semibold">
                    Total Sales Today
                </div>

                <div class="p-4 text-center">
                    <div id="saleQty" runat="server" class="text-dark fw-bold fs-2">
                        3
                    </div>
                </div>

            </div>
        </div>

    </div>

</div>

</asp:Content>
