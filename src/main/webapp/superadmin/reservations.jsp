<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Table Reservations - Super Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<c:set var="superPage" value="reservations" />
<jsp:include page="common/superadmin-nav.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1 text-dark">Platform Table Reservations</h3>
            <p class="text-secondary small mb-0">Overview of all customer dining table bookings across all registered venues.</p>
        </div>
    </div>

    <!-- Reservations Table Card -->
    <div class="card border-0 rounded-4 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="bg-light small text-secondary">
                        <tr>
                            <th class="ps-3">Booking ID</th>
                            <th>Restaurant</th>
                            <th>Table</th>
                            <th>Customer Name & Contact</th>
                            <th>Date & Time Slot</th>
                            <th>Guests</th>
                            <th>Special Requests</th>
                            <th class="pe-3 text-end">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="res" items="${reservations}">
                            <tr>
                                <td class="ps-3 fw-bold text-dark">#RES-${res.reservationId}</td>
                                <td>
                                    <span class="fw-semibold text-dark"><i class="bi bi-shop me-1 text-warning"></i>${res.restaurantName}</span>
                                </td>
                                <td><strong>${res.tableNumber}</strong></td>
                                <td>
                                    <div class="fw-semibold text-dark">${res.customerName}</div>
                                    <div class="text-muted small"><i class="bi bi-telephone me-1"></i>${res.customerMobile}</div>
                                </td>
                                <td>
                                    <div class="small fw-semibold text-dark">${res.reservationDate}</div>
                                    <div class="text-muted small">${res.timeSlot}</div>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border">
                                        <i class="bi bi-people me-1"></i>${res.guestCount}
                                    </span>
                                </td>
                                <td>
                                    <span class="small text-secondary">${not empty res.specialRequests ? res.specialRequests : 'None'}</span>
                                </td>
                                <td class="pe-3 text-end">
                                    <span class="badge ${res.status == 'APPROVED' ? 'bg-success' : (res.status == 'REJECTED' || res.status == 'CANCELLED' ? 'bg-danger' : (res.status == 'COMPLETED' ? 'bg-primary' : 'bg-warning text-dark'))} px-3 py-2">
                                        ${res.status}
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

