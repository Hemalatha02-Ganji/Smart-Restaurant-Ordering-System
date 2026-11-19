<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoices & Billing - ${restaurant.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<c:set var="adminPage" value="invoices" />
<jsp:include page="common/admin-nav.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1 text-dark">Digital Invoices & Billing Archive</h3>
            <p class="text-secondary small mb-0">View tax invoices, print receipts, and download PDF copies for accounting.</p>
        </div>
    </div>

    <!-- Invoices Table -->
    <div class="card border-0 rounded-4 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="bg-light small text-secondary">
                        <tr>
                            <th class="ps-3">Invoice Number</th>
                            <th>Order ID</th>
                            <th>Date & Time</th>
                            <th>Customer</th>
                            <th>Order Type</th>
                            <th>Amount Breakdown</th>
                            <th>Payment Status</th>
                            <th class="pe-3 text-end">Documents</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="inv" items="${invoices}">
                            <tr>
                                <td class="ps-3 fw-bold text-dark">${inv.invoiceNumber}</td>
                                <td>
                                    <span class="badge bg-light text-dark border">${inv.orderCode}</span>
                                </td>
                                <td>
                                    <div class="small fw-semibold text-dark">
                                        <fmt:formatDate value="${inv.invoiceDate}" pattern="dd-MMM-yyyy" />
                                    </div>
                                    <div class="text-muted small">
                                        <fmt:formatDate value="${inv.invoiceDate}" pattern="hh:mm a" />
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">${inv.customerName}</div>
                                    <div class="text-muted small">${inv.customerMobile}</div>
                                </td>
                                <td>
                                    <span class="badge ${inv.orderType == 'DINE_IN' ? 'bg-primary-subtle text-primary' : 'bg-success-subtle text-success'}">
                                        ${inv.orderType}
                                    </span>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark fs-6">Rs. ${inv.grandTotal}</div>
                                    <div class="text-muted small">Sub: Rs. ${inv.subtotal} | Tax: Rs. ${inv.gstAmount}</div>
                                </td>
                                <td>
                                    <span class="badge ${inv.paymentStatus == 'PAID' ? 'bg-success' : 'bg-warning text-dark'}">
                                        ${inv.paymentStatus} (COD)
                                    </span>
                                </td>
                                <td class="pe-3 text-end">
                                    <div class="btn-group btn-group-sm">
                                        <a href="${pageContext.request.contextPath}/invoice?num=${inv.invoiceNumber}" target="_blank" class="btn btn-outline-dark" title="View / Print">
                                            <i class="bi bi-printer"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/invoice/pdf?num=${inv.invoiceNumber}" class="btn btn-outline-danger" title="Download PDF">
                                            <i class="bi bi-file-earmark-pdf"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty invoices}">
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">No invoices generated yet.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

