<%@ Page Title="Analytics & Reports" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Analytics.aspx.cs" Inherits="POS.Analytics" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .analytics-wrap { padding: 24px; }
        .page-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; }
        .page-title { font-weight: 800; font-size: 1.5rem; letter-spacing: -.02em; margin: 0; }
        
        /* Filters */
        .filter-card { background: var(--card); border-radius: var(--radius-lg); padding: 20px; margin-bottom: 24px; box-shadow: var(--shadow-sm); }
        .filter-label { font-size: .84rem; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px; }
        .filter-row { display: flex; gap: 16px; flex-wrap: wrap; align-items: flex-end; }
        
        /* Charts */
        .chart-card { background: var(--card); border-radius: var(--radius-lg); padding: 24px; margin-bottom: 24px; box-shadow: var(--shadow-sm); }
        .chart-title { font-weight: 750; font-size: 1.05rem; margin-bottom: 16px; display: flex; align-items: center; gap: 8px; }
        .chart-title svg { width: 18px; height: 18px; fill: none; stroke: var(--accent); stroke-width: 2; stroke-linecap: round; }
        .chart-container { position: relative; height: 300px; width: 100%; }
        
        /* Metrics */
        .metric-mini { padding: 16px; border-radius: var(--radius); background: var(--canvas); border: 1px solid var(--border-light); }
        .metric-mini-label { font-size: .8rem; font-weight: 600; color: var(--text-muted); }
        .metric-mini-val { font-size: 1.4rem; font-weight: 800; color: var(--text); margin-top: 4px; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="analytics-wrap">

    <div class="page-header">
        <div>
            <div class="text-muted" style="font-size:.8rem;font-weight:700;text-transform:uppercase;letter-spacing:.1em;color:var(--accent)!important">Insights</div>
            <h1 class="page-title">Sales Analytics</h1>
        </div>
    </div>
    
    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger mb-4"><asp:Literal ID="litError" runat="server" /></asp:Panel>

    <!-- Filters -->
    <div class="filter-card">
        <div class="filter-row">
            <div style="flex:1;min-width:200px">
                <div class="filter-label">Select Product (Optional)</div>
                <asp:DropDownList ID="ddlProduct" runat="server" CssClass="form-select">
                    <asp:ListItem Text="All Products (Overall Sales)" Value="" />
                </asp:DropDownList>
            </div>
            <div style="width:160px">
                <div class="filter-label">From Date</div>
                <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date" CssClass="form-control" />
            </div>
            <div style="width:160px">
                <div class="filter-label">To Date</div>
                <asp:TextBox ID="txtToDate" runat="server" TextMode="Date" CssClass="form-control" />
            </div>
            <div>
                <asp:Button ID="btnFilter" runat="server" Text="Analyze" CssClass="btn btn-primary px-4" OnClick="btnFilter_Click" />
            </div>
        </div>
    </div>

    <!-- Summary Metrics -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="metric-mini">
                <div class="metric-mini-label">Total Revenue in Range</div>
                <div class="metric-mini-val">Tk <asp:Literal ID="litTotalRev" runat="server" Text="0.00" /></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="metric-mini">
                <div class="metric-mini-label">Total Units Sold</div>
                <div class="metric-mini-val"><asp:Literal ID="litTotalQty" runat="server" Text="0" /></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="metric-mini">
                <div class="metric-mini-label" id="lblMetric3" runat="server">Average Price</div>
                <div class="metric-mini-val" id="valMetric3" runat="server">Tk 0.00</div>
            </div>
        </div>
    </div>

    <div class="row g-3">
        <!-- Sales Volume Graph -->
        <div class="col-xl-8">
            <div class="chart-card">
                <div class="chart-title">
                    <svg viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                    Sales Volume Trend
                </div>
                <div class="chart-container">
                    <canvas id="salesChart"></canvas>
                </div>
            </div>
            
            <div class="chart-card" id="priceCard" runat="server">
                <div class="chart-title">
                    <svg viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                    Price History (Selected Product)
                </div>
                <div class="chart-container">
                    <canvas id="priceChart"></canvas>
                </div>
            </div>
        </div>
        
        <!-- Detailed Table -->
        <div class="col-xl-4">
            <div class="chart-card" style="height: 100%">
                <div class="chart-title">
                    <svg viewBox="0 0 24 24"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
                    Sales Breakdown
                </div>
                <div style="overflow-x:auto; max-height: 600px;">
                    <asp:GridView ID="gvBreakdown" runat="server" AutoGenerateColumns="false" CssClass="table table-hover table-sm" GridLines="None" EmptyDataText="No data found in range.">
                        <Columns>
                            <asp:BoundField DataField="DateLabel" HeaderText="Date" />
                            <asp:BoundField DataField="Qty" HeaderText="Qty" DataFormatString="{0:0.##}" />
                            <asp:BoundField DataField="Revenue" HeaderText="Revenue" DataFormatString="{0:N2}" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Hidden Fields for JSON Data -->
    <asp:HiddenField ID="hfSalesLabels" runat="server" />
    <asp:HiddenField ID="hfSalesData" runat="server" />
    <asp:HiddenField ID="hfPriceLabels" runat="server" />
    <asp:HiddenField ID="hfPriceData" runat="server" />

</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Sales Chart
        var salesLabelsStr = document.getElementById('<%= hfSalesLabels.ClientID %>').value;
        var salesDataStr = document.getElementById('<%= hfSalesData.ClientID %>').value;
        
        if (salesLabelsStr && salesDataStr) {
            var ctxSales = document.getElementById('salesChart').getContext('2d');
            
            // Create gradient
            var gradSales = ctxSales.createLinearGradient(0, 0, 0, 300);
            gradSales.addColorStop(0, 'rgba(99, 102, 241, 0.5)');
            gradSales.addColorStop(1, 'rgba(99, 102, 241, 0.05)');
            
            new Chart(ctxSales, {
                type: 'line',
                data: {
                    labels: JSON.parse(salesLabelsStr),
                    datasets: [{
                        label: 'Revenue (Tk)',
                        data: JSON.parse(salesDataStr),
                        borderColor: '#6366f1',
                        backgroundColor: gradSales,
                        borderWidth: 3,
                        pointBackgroundColor: '#ffffff',
                        pointBorderColor: '#6366f1',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6,
                        fill: true,
                        tension: 0.3
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.04)' }, border: { display: false } },
                        x: { grid: { display: false }, border: { display: false } }
                    }
                }
            });
        }
        
        // Price Chart
        var priceLabelsStr = document.getElementById('<%= hfPriceLabels.ClientID %>').value;
        var priceDataStr = document.getElementById('<%= hfPriceData.ClientID %>').value;
        var priceCanvas = document.getElementById('priceChart');
        
        if (priceLabelsStr && priceDataStr && priceCanvas) {
            var ctxPrice = priceCanvas.getContext('2d');
            new Chart(ctxPrice, {
                type: 'line',
                data: {
                    labels: JSON.parse(priceLabelsStr),
                    datasets: [{
                        label: 'Unit Price (Tk)',
                        data: JSON.parse(priceDataStr),
                        borderColor: '#10b981',
                        backgroundColor: 'transparent',
                        borderWidth: 3,
                        pointBackgroundColor: '#ffffff',
                        pointBorderColor: '#10b981',
                        pointRadius: 4,
                        stepped: 'middle' // Great for price history (shows flat line until it changes)
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { 
                            beginAtZero: false, 
                            grid: { color: 'rgba(0,0,0,0.04)' }, 
                            border: { display: false } 
                        },
                        x: { grid: { display: false }, border: { display: false } }
                    }
                }
            });
        }
    });
</script>
</asp:Content>
