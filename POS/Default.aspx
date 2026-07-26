<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="POS.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"><style>
.dashboard { padding: 28px; }
.eyebrow { color: var(--accent); font-weight: 800; font-size: .72rem; text-transform: uppercase; letter-spacing: .12em; margin-bottom: 4px; }
.page-heading { font-weight: 800; font-size: 1.6rem; margin: 0 0 2px; letter-spacing: -.02em; }

/* ── Metric Cards ── */
.metric-card {
    padding: 22px 24px; height: 100%; position: relative; overflow: hidden;
    border-left: 4px solid transparent; transition: transform .2s, box-shadow .2s;
}
.metric-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-lg) !important; }
.metric-card.mc-revenue { border-left-color: #6366f1; }
.metric-card.mc-month { border-left-color: #8b5cf6; }
.metric-card.mc-average { border-left-color: #06b6d4; }
.metric-card.mc-inventory { border-left-color: #10b981; }
.metric-label { color: var(--text-muted); font-size: .82rem; font-weight: 600; }
.metric-value { font-size: 1.75rem; font-weight: 800; margin-top: 6px; letter-spacing: -.02em; color: var(--text); }
.metric-note { color: var(--text-muted); font-size: .78rem; margin-top: 6px; }
.metric-badge {
    position: absolute; right: 20px; top: 20px;
    width: 44px; height: 44px; border-radius: 12px;
    display: flex; align-items: center; justify-content: center;
}
.metric-badge svg { width: 22px; height: 22px; fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
.metric-badge.mb-revenue { background: #eef2ff; color: #6366f1; }
.metric-badge.mb-month { background: #f5f3ff; color: #8b5cf6; }
.metric-badge.mb-average { background: #ecfeff; color: #06b6d4; }
.metric-badge.mb-inventory { background: #ecfdf5; color: #10b981; }

/* ── Section Cards ── */
.section-card { padding: 24px; height: 100%; }
.section-title { font-weight: 750; font-size: 1rem; margin: 0; letter-spacing: -.01em; }

/* ── Chart ── */
.chart {
    height: 220px; display: flex; align-items: flex-end; gap: 14px;
    padding-top: 24px; border-bottom: 2px solid var(--border-light);
}
.bar-col { height: 100%; flex: 1; display: flex; flex-direction: column; justify-content: flex-end; align-items: center; min-width: 24px; }
.bar {
    width: min(42px, 80%); min-height: 4px;
    background: linear-gradient(180deg, #818cf8, #4f46e5);
    border-radius: 8px 8px 3px 3px; position: relative;
    transition: height .5s cubic-bezier(.4,0,.2,1);
}
.bar:hover { background: linear-gradient(180deg, #a5b4fc, #6366f1); }
.bar:hover::after {
    content: attr(data-value); position: absolute; bottom: 100%; left: 50%;
    transform: translate(-50%, -8px);
    background: #0f172a; color: #fff; padding: 5px 10px;
    border-radius: 7px; font-size: .72rem; font-weight: 600;
    white-space: nowrap; pointer-events: none;
    box-shadow: 0 4px 12px rgba(0,0,0,.15);
}
.bar-label { font-size: .72rem; color: var(--text-muted); margin-top: 10px; font-weight: 600; }

/* ── Stock Health ── */
.progress-thin { height: 8px; background: var(--border-light); border-radius: 99px; overflow: hidden; }
.progress-thin span { height: 100%; display: block; background: linear-gradient(90deg, #6366f1, #8b5cf6); border-radius: 99px; transition: width .6s ease-out; }

/* ── Quick Actions ── */
.quick-btn {
    padding: 14px 18px; border: 1px solid var(--border); border-radius: var(--radius);
    color: var(--text); text-decoration: none; font-weight: 600; font-size: .9rem;
    display: flex; justify-content: space-between; align-items: center;
    background: #fff; transition: all var(--transition);
}
.quick-btn:hover { border-color: var(--accent-light); color: var(--accent); background: var(--accent-surface); transform: translateX(4px); }
.quick-btn .arrow { transition: transform var(--transition); font-size: 1.1rem; }
.quick-btn:hover .arrow { transform: translateX(4px); }

/* ── Payment Pill ── */
.pay-pill {
    display: inline-block; padding: 3px 10px; border-radius: 999px;
    font-size: .75rem; font-weight: 600;
}
.pay-cash { background: #ecfdf5; color: #065f46; }
.pay-card { background: #eff6ff; color: #1e40af; }
.pay-mobile { background: #faf5ff; color: #6b21a8; }
.pay-other { background: #f1f5f9; color: #475569; }

@media (max-width: 768px) { .dashboard { padding: 16px; } .metric-value { font-size: 1.4rem; } }
</style></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server"><div class="dashboard">

<!-- Header -->
<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
    <div>
        <div class="eyebrow">Business overview</div>
        <h2 class="page-heading">Good to see you</h2>
        <div class="text-muted" style="font-size:.9rem"><asp:Literal ID="litDate" runat="server" /></div>
    </div>
    <div class="d-flex gap-2">
        <asp:HyperLink ID="lnkAddAdmin" runat="server" Visible="false" NavigateUrl="~/AdminUsers.aspx" CssClass="btn btn-outline-primary">
            <svg style="width:16px;height:16px;vertical-align:-2px;margin-right:4px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="23" y1="11" x2="17" y2="11"/><line x1="20" y1="8" x2="20" y2="14"/></svg>
            Add administrator
        </asp:HyperLink>
        <a href="POS.aspx" class="btn btn-primary" style="padding:10px 20px">
            <svg style="width:16px;height:16px;vertical-align:-2px;margin-right:4px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
            New sale
        </a>
    </div>
</div>

<!-- Metric Cards -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-sm-6"><div class="card metric-card mc-revenue">
        <div class="metric-badge mb-revenue"><svg viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></div>
        <div class="metric-label">Today's revenue</div>
        <div class="metric-value" id="saleAmount" runat="server">0.00</div>
        <div class="metric-note" id="saleQty" runat="server">0 transactions</div>
    </div></div>
    <div class="col-xl-3 col-sm-6"><div class="card metric-card mc-month">
        <div class="metric-badge mb-month"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg></div>
        <div class="metric-label">This month's revenue</div>
        <div class="metric-value" id="monthSales" runat="server">0.00</div>
        <div class="metric-note">Completed sales this month</div>
    </div></div>
    <div class="col-xl-3 col-sm-6"><div class="card metric-card mc-average">
        <div class="metric-badge mb-average"><svg viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg></div>
        <div class="metric-label">Average sale today</div>
        <div class="metric-value" id="averageSale" runat="server">0.00</div>
        <div class="metric-note">Per transaction</div>
    </div></div>
    <div class="col-xl-3 col-sm-6"><div class="card metric-card mc-inventory">
        <div class="metric-badge mb-inventory"><svg viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg></div>
        <div class="metric-label">Inventory value</div>
        <div class="metric-value" id="inventoryValue" runat="server">0.00</div>
        <div class="metric-note"><span id="productQty" runat="server">0</span> products &middot; <span id="stockUnits" runat="server">0</span> units</div>
    </div></div>
</div>

<!-- Chart + Stock Health -->
<div class="row g-3 mb-4">
    <div class="col-xl-8"><div class="card section-card">
        <div class="d-flex justify-content-between align-items-center mb-1">
            <h3 class="section-title">Sales &mdash; last 7 days</h3>
            <span class="text-muted" style="font-size:.8rem;font-weight:500">Revenue (Taka)</span>
        </div>
        <div class="chart"><asp:Literal ID="litSalesChart" runat="server" /></div>
    </div></div>
    <div class="col-xl-4"><div class="card section-card">
        <h3 class="section-title mb-3">Stock health</h3>
        <div class="d-flex justify-content-between mb-2"><span style="font-weight:500">Healthy stock</span><strong id="healthyStock" runat="server">0</strong></div>
        <div class="progress-thin mb-4"><span id="healthyBar" runat="server"></span></div>
        <div class="d-flex gap-2 mb-4">
            <span id="low_stock_Count" runat="server" class="pill pill-warning">0 low</span>
            <span id="out_of_stock_Count" runat="server" class="pill pill-danger">0 out</span>
        </div>
        <h3 class="section-title mb-3">Quick actions</h3>
        <div class="d-grid gap-2">
            <a class="quick-btn" href="POS.aspx"><span>Start checkout</span><span class="arrow">&rsaquo;</span></a>
            <a class="quick-btn" href="Products.aspx"><span>Manage products</span><span class="arrow">&rsaquo;</span></a>
            <a class="quick-btn" href="Reports.aspx"><span>View all sales</span><span class="arrow">&rsaquo;</span></a>
        </div>
    </div></div>
</div>

<!-- Recent Transactions + Top Products -->
<div class="row g-3">
    <div class="col-xl-7"><div class="card section-card">
        <h3 class="section-title mb-3">Recent transactions</h3>
        <div style="overflow-x:auto">
        <asp:GridView ID="gvRecentSales" runat="server" AutoGenerateColumns="false" CssClass="table table-hover align-middle mb-0" GridLines="None" EmptyDataText="No sales yet">
            <Columns>
                <asp:BoundField DataField="Order_No" HeaderText="Receipt" DataFormatString="#{0}"/>
                <asp:BoundField DataField="Sale_Date" HeaderText="Time" DataFormatString="{0:dd MMM, hh:mm tt}"/>
                <asp:TemplateField HeaderText="Payment"><ItemTemplate>
                    <span class='<%# "pay-pill pay-" + GetPaymentClass(Eval("Payment_Method").ToString()) %>'><%# Eval("Payment_Method") %></span>
                </ItemTemplate></asp:TemplateField>
                <asp:BoundField DataField="Grand_Total" HeaderText="Amount" DataFormatString="{0:N2}"/>
            </Columns>
        </asp:GridView>
        </div>
    </div></div>
    <div class="col-xl-5"><div class="card section-card">
        <h3 class="section-title mb-3">Top-selling products</h3>
        <div style="overflow-x:auto">
        <asp:GridView ID="gvTopProducts" runat="server" AutoGenerateColumns="false" CssClass="table table-hover align-middle mb-0" GridLines="None" EmptyDataText="No sales yet">
            <Columns>
                <asp:BoundField DataField="Product_Name" HeaderText="Product"/>
                <asp:BoundField DataField="Quantity" HeaderText="Qty" DataFormatString="{0:0.##}"/>
                <asp:BoundField DataField="Revenue" HeaderText="Revenue" DataFormatString="{0:N2}"/>
            </Columns>
        </asp:GridView>
        </div>
    </div></div>
</div>

</div></asp:Content>
