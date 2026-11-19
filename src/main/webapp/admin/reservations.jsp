<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Reservations - ${restaurant.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<c:set var="adminPage" value="reservations" />
<jsp:include page="common/admin-nav.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1 text-dark">Table Reservations</h3>
            <p class="text-secondary small mb-0">Approve incoming customer bookings, track arrival dates, and manage table occupancy.</p>
        </div>
    </div>

    <c:if test="${param.updated == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-check-circle me-1"></i> Reservation status updated!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Reservations Table -->
    <div class="card border-0 rounded-4 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="bg-light small text-secondary">
                        <tr>
                            <th class="ps-3">Ref ID</th>
                            <th>Table</th>
                            <th>Customer Info</th>
                            <th>Date & Time Slot</th>
                            <th>Guests</th>
                            <th>Special Requests</th>
                            <th>Status</th>
                            <th class="pe-3 text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="res" items="${reservations}">
                            <tr>
                                <td class="ps-3 fw-bold text-dark">#RES-${res.reservationId}</td>
                                <td>
                                    <div class="fw-bold text-dark">${res.tableNumber}</div>
                                    <div class="text-muted small">Max ${res.tableCapacity} seats</div>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">${res.customerName}</div>
                                    <div class="text-muted small"><i class="bi bi-telephone me-1"></i>${res.customerMobile}</div>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">${res.reservationDate}</div>
                                    <div class="text-muted small">${res.timeSlot}</div>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border px-2 py-1">
                                        <i class="bi bi-people me-1"></i>${res.guestCount}
                                    </span>
                                </td>
                                <td>
                                    <span class="small text-secondary">${not empty res.specialRequests ? res.specialRequests : 'None'}</span>
                                </td>
                                <td>
                                    <span class="badge ${res.status == 'APPROVED' ? 'bg-success' : (res.status == 'REJECTED' || res.status == 'CANCELLED' ? 'bg-danger' : (res.status == 'COMPLETED' ? 'bg-primary' : 'bg-warning text-dark'))} px-2 py-1">
                                        ${res.status}
                                    </span>
                                </td>
                                <td class="pe-3 text-end">
                                    <form action="${pageContext.request.contextPath}/admin/reservations" method="POST" class="d-inline-flex gap-1">
                                        <input type="hidden" name="action" value="update-reservation-status">
                                        <input type="hidden" name="reservationId" value="${res.reservationId}">
                                        <select name="status" class="form-select form-select-sm" style="width: 130px;" onchange="this.form.submit()">
                                            <option value="PENDING" ${res.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                            <option value="APPROVED" ${res.status == 'APPROVED' ? 'selected' : ''}>APPROVED</option>
                                            <option value="REJECTED" ${res.status == 'REJECTED' ? 'selected' : ''}>REJECTED</option>
                                            <option value="COMPLETED" ${res.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                            <option value="CANCELLED" ${res.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                        </select>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty reservations}">
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">No reservations recorded yet.</td>
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

