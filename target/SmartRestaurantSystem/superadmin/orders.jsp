<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Orders - Super Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<c:set var="superPage" value="orders" />
<jsp:include page="common/superadmin-nav.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1 text-dark">Platform Orders Audit</h3>
            <p class="text-secondary small mb-0">Cross-restaurant orders history, Cash on Delivery settlement tracking, and order items audit.</p>
        </div>
    </div>

    <!-- Orders Table Card -->
    <div class="card border-0 rounded-4 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="bg-light small text-secondary">
                        <tr>
                            <th class="ps-3">Order ID & Date</th>
                            <th>Restaurant</th>
                            <th>Customer & Contact</th>
                            <th>Type</th>
                            <th>Grand Total (COD)</th>
                            <th>Payment Status</th>
                            <th>Order Status</th>
                            <th class="pe-3 text-end">Invoice</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ord" items="${orders}">
                            <tr>
                                <td class="ps-3">
                                    <div class="fw-bold text-dark">${ord.orderCode}</div>
                                    <div class="text-muted small">
                                        <fmt:formatDate value="${ord.createdAt}" pattern="dd-MMM-yyyy hh:mm a" />
                                    </div>
                                </td>
                                <td>
                                    <span class="fw-semibold text-dark"><i class="bi bi-shop me-1 text-warning"></i>${ord.restaurantName}</span>
                                    <div class="text-muted small">${ord.customerArea}</div>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">${ord.customerName}</div>
                                    <div class="text-muted small"><i class="bi bi-telephone me-1"></i>${ord.customerMobile}</div>
                                </td>
                                <td>
                                    <span class="badge ${ord.orderType == 'DINE_IN' ? 'bg-primary-subtle text-primary' : 'bg-success-subtle text-success'}">
                                        ${ord.orderType}
                                    </span>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark fs-6">Rs. ${ord.grandTotal}</div>
                                    <div class="text-muted small">Sub: ${ord.subtotal} | GST: ${ord.gstAmount}</div>
                                </td>
                                <td>
                                    <span class="badge ${ord.payment.paid ? 'bg-success' : 'bg-warning text-dark'}">
                                        ${ord.payment.paymentStatus}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge ${ord.orderStatus == 'DELIVERED' || ord.orderStatus == 'COMPLETED' ? 'bg-success' : (ord.orderStatus == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark')} px-2 py-1">
                                        ${ord.orderStatus}
                                    </span>
                                </td>
                                <td class="pe-3 text-end">
                                    <a href="${pageContext.request.contextPath}/invoice?code=${ord.orderCode}" target="_blank" class="btn btn-sm btn-outline-dark" title="View Digital Invoice">
                                        <i class="bi bi-receipt"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

