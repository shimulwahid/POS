<%@ Page Title="Sales History" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="POS.Reports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 24px;
            padding-top: 24px;
        }
        .page-title {
            font-weight: 800;
            font-size: 1.5rem;
            letter-spacing: -.02em;
            margin: 0;
        }
        .card-table {
            background: var(--card);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
        }
        .btn-print {
            background: #fff;
            border: 1px solid var(--border);
            font-weight: 600;
            padding: 10px 20px;
            border-radius: var(--radius);
            transition: all .3s;
        }
            .btn-print:hover {
                border-color: var(--accent);
                color: var(--accent);
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <div>
            <div style="font-size: .8rem; font-weight: 700; text-transform: uppercase; letter-spacing: .1em; color: var(--accent);">
                Reports
            </div>
            <h1 class="page-title">Sales History
            </h1>
        </div>
        <button type="button"
            class="btn-print"
            onclick="window.print();">
            🖨 Print Report
        </button>
    </div>
    <div class="card-table">
        <div style="overflow-x: auto;">
            <asp:GridView
                ID="gvSales"
                runat="server"
                AutoGenerateColumns="false"
                CssClass="table table-hover"
                EmptyDataText="No completed sales yet."
                UseAccessibleHeader="true"
                OnRowCommand="gvSales_RowCommand">
                <Columns>
                    <asp:BoundField
                        DataField="Order_No"
                        HeaderText="Receipt #" />
                    <asp:BoundField
                        DataField="Sale_Date"
                        HeaderText="Date"
                        DataFormatString="{0:dd-MMM-yyyy hh:mm tt}" />
                    <asp:BoundField
                        DataField="Grand_Total"
                        HeaderText="Total"
                        DataFormatString="{0:N2}" />
                    <asp:BoundField
                        DataField="Payment_Method"
                        HeaderText="Payment" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button
                                ID="btnReceipt"
                                runat="server"
                                Text="View / Print"
                                CssClass="btn btn-sm btn-outline-dark"
                                CommandName="Receipt"
                                CommandArgument='<%# Eval("Order_No") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
    <script>
$(document).ready(function () {
                   var table = $('#<%=gvSales.ClientID%>');
    if (table.find("tbody tr").length > 0 &&
        table.find("tbody tr:first td").length == 5) {
        table.DataTable({
            order: [[1, "desc"]],
            pageLength: 10,
            responsive: true
        });
    }
});
    </script>
</asp:Content>
