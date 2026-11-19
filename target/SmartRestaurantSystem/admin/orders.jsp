<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders - ${restaurant.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<c:set var="adminPage" value="orders" />
<jsp:include page="common/admin-nav.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1 text-dark">Order Management & COD Billing</h3>
            <p class="text-secondary small mb-0">Update live cooking status, track delivery and mark Cash on Delivery settlements.</p>
        </div>
    </div>

    <c:if test="${param.updated == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-check-circle me-1"></i> Order status updated successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.paid == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-cash-stack me-1"></i> Cash on Delivery payment recorded as PAID!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Orders Table Card -->
    <div class="card border-0 rounded-4 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="bg-light small text-secondary">
                        <tr>
                            <th class="ps-3">Order Details</th>
                            <th>Customer & Delivery</th>
                            <th>Items Breakdown</th>
                            <th>Bill Total (COD)</th>
                            <th>Payment</th>
                            <th>Lifecycle Status</th>
                            <th class="pe-3 text-end">Update Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ord" items="${orders}">
                            <tr>
                                <!-- Order Code & Date -->
                                <td class="ps-3">
                                    <div class="fw-bold text-dark">${ord.orderCode}</div>
                                    <div class="text-muted small">
                                        <fmt:formatDate value="${ord.createdAt}" pattern="dd-MMM hh:mm a" />
                                    </div>
                                    <span class="badge ${ord.orderType == 'DINE_IN' ? 'bg-primary-subtle text-primary' : 'bg-success-subtle text-success'} mt-1 small">
                                        ${ord.orderType}
                                    </span>
                                </td>

                                <!-- Customer Details -->
                                <td>
                                    <div class="fw-semibold text-dark">${ord.customerName}</div>
                                    <div class="text-muted small"><i class="bi bi-telephone me-1"></i>${ord.customerMobile}</div>
                                    <c:choose>
                                        <c:when test="${ord.orderType == 'HOME_DELIVERY' && ord.address != null}">
                                            <div class="text-muted small text-truncate" style="max-width: 200px;" title="${ord.address.formattedAddress}">
                                                <i class="bi bi-geo-alt me-1 text-danger"></i>${ord.address.formattedAddress}
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-muted small"><i class="bi bi-door-open me-1 text-primary"></i>${ord.specialNotes}</div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Items -->
                                <td>
                                    <ul class="list-unstyled mb-0 small">
                                        <c:forEach var="it" items="${ord.items}">
                                            <li><strong class="text-dark">${it.quantity}x</strong> ${it.itemName}</li>
                                        </c:forEach>
                                    </ul>
                                </td>

                                <!-- Bill Total -->
                                <td>
                                    <div class="fw-bold fs-6 text-dark">Rs. ${ord.grandTotal}</div>
                                    <div class="text-muted small">Sub: Rs. ${ord.subtotal} | GST: ${ord.gstAmount}</div>
                                </td>

                                <!-- Payment Status & Collect Cash Action -->
                                <td>
                                    <span class="badge ${ord.payment.paid ? 'bg-success' : 'bg-warning text-dark'} mb-1 d-block">
                                        ${ord.payment.paymentStatus}
                                    </span>
                                    <c:if test="${!ord.payment.paid && ord.orderStatus != 'CANCELLED'}">
                                        <form action="${pageContext.request.contextPath}/admin/orders" method="POST">
                                            <input type="hidden" name="action" value="collect-cod">
                                            <input type="hidden" name="orderId" value="${ord.orderId}">
                                            <button type="submit" class="btn btn-outline-success btn-sm py-0 px-2 small w-100" style="font-size:0.75rem;">
                                                <i class="bi bi-cash me-1"></i> Mark Paid
                                            </button>
                                        </form>
                                    </c:if>
                                </td>

                                <!-- Order Status Badge -->
                                <td>
                                    <span class="badge ${ord.orderStatus == 'DELIVERED' || ord.orderStatus == 'COMPLETED' ? 'bg-success' : (ord.orderStatus == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark')} px-2 py-1">
                                        ${ord.orderStatus}
                                    </span>
                                </td>

                                <!-- Action Form for Status Lifecycle -->
                                <td class="pe-3 text-end">
                                    <div class="d-flex justify-content-end gap-1">
                                        <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="d-inline-flex gap-1">
                                            <input type="hidden" name="action" value="update-order-status">
                                            <input type="hidden" name="orderId" value="${ord.orderId}">
                                            <select name="status" class="form-select form-select-sm" style="width: 140px;" onchange="this.form.submit()">
                                                <option value="PLACED" ${ord.orderStatus == 'PLACED' ? 'selected' : ''}>PLACED</option>
                                                <option value="ACCEPTED" ${ord.orderStatus == 'ACCEPTED' ? 'selected' : ''}>ACCEPTED</option>
                                                <option value="PREPARING" ${ord.orderStatus == 'PREPARING' ? 'selected' : ''}>PREPARING</option>
                                                <option value="READY" ${ord.orderStatus == 'READY' ? 'selected' : ''}>READY</option>
                                                <c:choose>
                                                    <c:when test="${ord.orderType == 'HOME_DELIVERY'}">
                                                        <option value="OUT_FOR_DELIVERY" ${ord.orderStatus == 'OUT_FOR_DELIVERY' ? 'selected' : ''}>OUT FOR DELIVERY</option>
                                                        <option value="DELIVERED" ${ord.orderStatus == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="COMPLETED" ${ord.orderStatus == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                                    </c:otherwise>
                                                </c:choose>
                                                <option value="CANCELLED" ${ord.orderStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                            </select>
                                        </form>

                                        <a href="${pageContext.request.contextPath}/invoice?code=${ord.orderCode}" target="_blank" 
                                           class="btn btn-outline-dark btn-sm" title="View Digital Invoice">
                                            <i class="bi bi-receipt"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty orders}">
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">No orders found for this restaurant.</td>
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

