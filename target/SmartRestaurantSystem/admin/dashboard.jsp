<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - ${restaurant.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<c:set var="adminPage" value="dashboard" />
<jsp:include page="common/admin-nav.jsp" />

<div class="container-fluid px-4 py-4">
    <!-- Welcome Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1 text-dark">${restaurant.name} Operations</h2>
            <div class="text-secondary small">
                <i class="bi bi-geo-alt me-1 text-danger"></i>${restaurant.address} &bull; Area: <strong>${restaurant.primaryArea}</strong>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-primary-custom btn-sm">
                <i class="bi bi-bag-check me-1"></i> Manage Orders
            </a>
            <a href="${pageContext.request.contextPath}/admin/menu" class="btn btn-accent btn-sm">
                <i class="bi bi-plus-lg me-1"></i> Add Food Item
            </a>
        </div>
    </div>

    <!-- Statistics Cards Grid -->
    <div class="row g-3 mb-4">
        <!-- Total Orders -->
        <div class="col-sm-6 col-xl-2">
            <div class="card border-0 rounded-4 shadow-sm p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Total Orders</span>
                    <div class="rounded-circle p-2 bg-primary-subtle text-primary"><i class="bi bi-receipt"></i></div>
                </div>
                <h3 class="fw-bold mb-0 text-dark">${stats.totalOrders}</h3>
            </div>
        </div>

        <!-- Pending Orders -->
        <div class="col-sm-6 col-xl-2">
            <div class="card border-0 rounded-4 shadow-sm p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Pending / Prep</span>
                    <div class="rounded-circle p-2 bg-warning-subtle text-warning"><i class="bi bi-hourglass-split"></i></div>
                </div>
                <h3 class="fw-bold mb-0 text-warning">${stats.pendingOrders}</h3>
            </div>
        </div>

        <!-- Completed Orders -->
        <div class="col-sm-6 col-xl-2">
            <div class="card border-0 rounded-4 shadow-sm p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Delivered</span>
                    <div class="rounded-circle p-2 bg-success-subtle text-success"><i class="bi bi-check2-all"></i></div>
                </div>
                <h3 class="fw-bold mb-0 text-success">${stats.completedOrders}</h3>
            </div>
        </div>

        <!-- Today's Orders -->
        <div class="col-sm-6 col-xl-2">
            <div class="card border-0 rounded-4 shadow-sm p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Today's Orders</span>
                    <div class="rounded-circle p-2 bg-info-subtle text-info"><i class="bi bi-calendar2-day"></i></div>
                </div>
                <h3 class="fw-bold mb-0 text-info">${stats.todayOrders}</h3>
            </div>
        </div>

        <!-- Today's Revenue -->
        <div class="col-sm-6 col-xl-2">
            <div class="card border-0 rounded-4 shadow-sm p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Today Revenue</span>
                    <div class="rounded-circle p-2 bg-success-subtle text-success"><i class="bi bi-cash-stack"></i></div>
                </div>
                <h3 class="fw-bold mb-0 text-dark">Rs. ${stats.todayRevenue}</h3>
            </div>
        </div>

        <!-- Total Revenue -->
        <div class="col-sm-6 col-xl-2">
            <div class="card border-0 rounded-4 shadow-sm p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Total Revenue</span>
                    <div class="rounded-circle p-2 bg-dark-subtle text-dark"><i class="bi bi-graph-up-arrow"></i></div>
                </div>
                <h3 class="fw-bold mb-0" style="color: var(--accent-orange);">Rs. ${stats.totalRevenue}</h3>
            </div>
        </div>
    </div>

    <!-- Recent Orders & Table Reservations Split View -->
    <div class="row g-4">
        <!-- Recent Orders -->
        <div class="col-lg-7">
            <div class="card border-0 rounded-4 shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold mb-0 text-dark">Incoming & Recent Orders</h5>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary btn-sm">View All</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead class="bg-light small text-secondary">
                                <tr>
                                    <th class="ps-3">Order ID</th>
                                    <th>Customer</th>
                                    <th>Type</th>
                                    <th>Amount (COD)</th>
                                    <th>Status</th>
                                    <th class="pe-3 text-end">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ord" items="${recentOrders}">
                                    <tr>
                                        <td class="ps-3 fw-bold text-dark">${ord.orderCode}</td>
                                        <td>
                                            <div class="fw-semibold text-dark">${ord.customerName}</div>
                                            <div class="text-muted small">${ord.customerMobile}</div>
                                        </td>
                                        <td>
                                            <span class="badge ${ord.orderType == 'DINE_IN' ? 'bg-primary-subtle text-primary' : 'bg-success-subtle text-success'} small">
                                                ${ord.orderType}
                                            </span>
                                        </td>
                                        <td class="fw-bold text-dark">Rs. ${ord.grandTotal}</td>
                                        <td>
                                            <span class="badge ${ord.orderStatus == 'DELIVERED' || ord.orderStatus == 'COMPLETED' ? 'bg-success' : (ord.orderStatus == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark')}">
                                                ${ord.orderStatus}
                                            </span>
                                        </td>
                                        <td class="pe-3 text-end">
                                            <a href="${pageContext.request.contextPath}/invoice?code=${ord.orderCode}" target="_blank" class="btn btn-sm btn-outline-dark" title="Invoice">
                                                <i class="bi bi-receipt"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentOrders}">
                                    <tr>
                                        <td colspan="6" class="text-center py-4 text-muted small">No orders recorded yet.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Reservations -->
        <div class="col-lg-5">
            <div class="card border-0 rounded-4 shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold mb-0 text-dark">Recent Table Bookings</h5>
                    <a href="${pageContext.request.contextPath}/admin/reservations" class="btn btn-outline-secondary btn-sm">View All</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead class="bg-light small text-secondary">
                                <tr>
                                    <th class="ps-3">Table</th>
                                    <th>Customer</th>
                                    <th>Date & Slot</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="res" items="${recentReservations}">
                                    <tr>
                                        <td class="ps-3 fw-bold text-dark">${res.tableNumber}</td>
                                        <td>
                                            <div class="fw-semibold text-dark">${res.customerName}</div>
                                            <div class="text-muted small">${res.guestCount} guests</div>
                                        </td>
                                        <td>
                                            <div class="small fw-semibold text-dark">${res.reservationDate}</div>
                                            <div class="text-muted small" style="font-size:0.75rem;">${res.timeSlot}</div>
                                        </td>
                                        <td>
                                            <span class="badge ${res.status == 'APPROVED' ? 'bg-success' : (res.status == 'REJECTED' || res.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark')} small">
                                                ${res.status}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentReservations}">
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-muted small">No reservations placed yet.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

