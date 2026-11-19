<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Super Admin Dashboard - Smart Restaurant Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<c:set var="superPage" value="dashboard" />
<jsp:include page="common/superadmin-nav.jsp" />

<div class="container-fluid px-4 py-4">
    <!-- Super Admin Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1 text-dark">Platform Executive Overview</h2>
            <p class="text-secondary small mb-0">Multi-restaurant central metrics, partner onboarding, and network operations.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/superadmin/restaurants" class="btn btn-accent btn-sm">
                <i class="bi bi-plus-lg me-1"></i> Add New Restaurant
            </a>
            <a href="${pageContext.request.contextPath}/superadmin/admins" class="btn btn-dark btn-sm">
                <i class="bi bi-person-plus me-1"></i> Assign Managers
            </a>
        </div>
    </div>

    <!-- Platform Stats Cards -->
    <div class="row g-3 mb-4">
        <div class="col-sm-6 col-xl">
            <div class="card border-0 rounded-4 shadow-sm p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Restaurants</span>
                    <div class="rounded-circle p-2 bg-primary-subtle text-primary"><i class="bi bi-shop"></i></div>
                </div>
                <h3 class="fw-bold mb-0 text-dark">${stats.totalRestaurants}</h3>
            </div>
        </div>

        <div class="col-sm-6 col-xl">
            <div class="card border-0 rounded-4 shadow-sm p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Total Orders</span>
                    <div class="rounded-circle p-2 bg-warning-subtle text-warning"><i class="bi bi-bag-check"></i></div>
                </div>
                <h3 class="fw-bold mb-0 text-dark">${stats.totalOrders}</h3>
            </div>
        </div>

        <div class="col-sm-6 col-xl">
            <div class="card border-0 rounded-4 shadow-sm p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Unique Customers</span>
                    <div class="rounded-circle p-2 bg-info-subtle text-info"><i class="bi bi-people"></i></div>
                </div>
                <h3 class="fw-bold mb-0 text-dark">${stats.totalCustomers}</h3>
            </div>
        </div>

        <div class="col-sm-6 col-xl">
            <div class="card border-0 rounded-4 shadow-sm p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Reservations</span>
                    <div class="rounded-circle p-2 bg-secondary-subtle text-secondary"><i class="bi bi-calendar-check"></i></div>
                </div>
                <h3 class="fw-bold mb-0 text-dark">${stats.totalReservations}</h3>
            </div>
        </div>

        <div class="col-sm-6 col-xl">
            <div class="card border-0 rounded-4 shadow-sm p-3 bg-white h-100">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Total Platform Revenue</span>
                    <div class="rounded-circle p-2 bg-success-subtle text-success"><i class="bi bi-cash-stack"></i></div>
                </div>
                <h3 class="fw-bold mb-0" style="color: var(--accent-orange);">Rs. ${stats.totalRevenue}</h3>
            </div>
        </div>
    </div>

    <!-- Partner Restaurants Overview Table -->
    <div class="card border-0 rounded-4 shadow-sm mb-4">
        <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
            <h5 class="fw-bold mb-0 text-dark">Platform Partner Restaurants</h5>
            <a href="${pageContext.request.contextPath}/superadmin/restaurants" class="btn btn-outline-secondary btn-sm">Manage All</a>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="bg-light small text-secondary">
                        <tr>
                            <th class="ps-3">Restaurant</th>
                            <th>Cuisine</th>
                            <th>Primary Area</th>
                            <th>Rating</th>
                            <th>Contact</th>
                            <th>Status</th>
                            <th class="pe-3 text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${restaurants}">
                            <tr>
                                <td class="ps-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="${r.imageUrl}" alt="${r.name}" class="rounded-3 shadow-sm"
                                             style="width: 45px; height: 45px; object-fit: cover;">
                                        <div>
                                            <div class="fw-bold text-dark">${r.name}</div>
                                            <div class="text-muted small">${r.address}</div>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-light text-dark border">${r.cuisine}</span></td>
                                <td><strong>${r.primaryArea}</strong></td>
                                <td><i class="bi bi-star-fill text-warning me-1"></i>${r.rating}</td>
                                <td>${r.contactNumber}</td>
                                <td>
                                    <span class="badge ${r.active ? 'bg-success' : 'bg-danger'}">
                                        ${r.active ? 'Active' : 'Deactivated'}
                                    </span>
                                </td>
                                <td class="pe-3 text-end">
                                    <a href="${pageContext.request.contextPath}/menu?id=${r.restaurantId}" target="_blank" class="btn btn-sm btn-outline-dark me-1" title="Storefront Menu">
                                        <i class="bi bi-box-arrow-up-right"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/superadmin/restaurants" class="btn btn-sm btn-outline-primary" title="Edit Info">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Recent Platform Activity Split View -->
    <div class="row g-4">
        <!-- Recent Orders Across All Restaurants -->
        <div class="col-lg-7">
            <div class="card border-0 rounded-4 shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold mb-0 text-dark">Recent Cross-Restaurant Orders</h5>
                    <a href="${pageContext.request.contextPath}/superadmin/orders" class="btn btn-outline-secondary btn-sm">All Orders</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead class="bg-light small text-secondary">
                                <tr>
                                    <th class="ps-3">Order ID</th>
                                    <th>Restaurant</th>
                                    <th>Customer</th>
                                    <th>Grand Total (COD)</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${recentOrders}">
                                    <tr>
                                        <td class="ps-3 fw-bold text-dark">${o.orderCode}</td>
                                        <td>${o.restaurantName}</td>
                                        <td>${o.customerName}</td>
                                        <td class="fw-bold text-dark">Rs. ${o.grandTotal}</td>
                                        <td>
                                            <span class="badge ${o.orderStatus == 'DELIVERED' || o.orderStatus == 'COMPLETED' ? 'bg-success' : (o.orderStatus == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark')} small">
                                                ${o.orderStatus}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Reservations Across All Restaurants -->
        <div class="col-lg-5">
            <div class="card border-0 rounded-4 shadow-sm h-100">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold mb-0 text-dark">Recent Platform Reservations</h5>
                    <a href="${pageContext.request.contextPath}/superadmin/reservations" class="btn btn-outline-secondary btn-sm">All Bookings</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead class="bg-light small text-secondary">
                                <tr>
                                    <th class="ps-3">Restaurant</th>
                                    <th>Customer</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${recentReservations}">
                                    <tr>
                                        <td class="ps-3 fw-bold text-dark">${r.restaurantName}</td>
                                        <td>
                                            <div>${r.customerName}</div>
                                            <div class="text-muted small">${r.guestCount} guests</div>
                                        </td>
                                        <td>
                                            <div class="small fw-semibold text-dark">${r.reservationDate}</div>
                                            <div class="text-muted small">${r.timeSlot}</div>
                                        </td>
                                        <td>
                                            <span class="badge ${r.status == 'APPROVED' ? 'bg-success' : (r.status == 'REJECTED' || r.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark')} small">
                                                ${r.status}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
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

