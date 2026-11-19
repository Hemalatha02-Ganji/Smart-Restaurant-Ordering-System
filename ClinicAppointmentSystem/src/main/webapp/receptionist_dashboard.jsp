<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Front Desk Receptionist Console - CityCare Clinic" />
<%@ include file="common/header.jsp" %>
<%@ include file="common/navbar.jsp" %>

<main class="py-4">
    <div class="container-fluid px-lg-5">
        <!-- TOP WELCOME BAR -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <span class="badge bg-warning text-dark px-3 py-1 rounded-pill fw-bold mb-1">
                    <i class="bi bi-shield-lock-fill me-1"></i> FRONT DESK OPERATIONS
                </span>
                <h3 class="fw-bold mb-0 text-dark">Clinic Appointment Master Console</h3>
                <small class="text-muted">Manage patient queues, schedule confirmations, and doctor cabin allocations</small>
            </div>
            <div class="d-flex align-items-center gap-2 mt-2 mt-md-0">
                <span class="badge bg-light text-dark border px-3 py-2 rounded-pill">
                    <i class="bi bi-person-badge text-primary me-1"></i> Staff: <strong>${sessionScope.receptionist.fullName}</strong>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm rounded-pill px-3">
                    <i class="bi bi-box-arrow-right me-1"></i> Sign Out
                </a>
            </div>
        </div>

        <!-- NOTIFICATION ALERTS -->
        <c:if test="${not empty param.msg and param.msg eq 'confirmed'}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill fs-5 me-2"></i>
                <strong>Appointment Confirmed:</strong> The patient's schedule has been confirmed and locked.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.msg and param.msg eq 'cancelled'}">
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-x-circle-fill fs-5 me-2"></i>
                <strong>Appointment Cancelled:</strong> The consultation slot has been released back into the available pool.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.msg and param.msg eq 'completed'}">
            <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check2-all fs-5 me-2"></i>
                <strong>Consultation Finished:</strong> Marked as completed.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- KPI METRICS -->
        <div class="row g-3 mb-4">
            <div class="col-md-2 col-sm-6">
                <div class="metric-card primary">
                    <div class="display-6 fw-bold">${metrics['total'] != null ? metrics['total'] : 0}</div>
                    <div class="small fw-semibold text-uppercase tracking-wider">Total Bookings</div>
                    <i class="bi bi-calendar3 metric-icon"></i>
                </div>
            </div>
            <div class="col-md-2 col-sm-6">
                <div class="metric-card info">
                    <div class="display-6 fw-bold">${metrics['today'] != null ? metrics['today'] : 0}</div>
                    <div class="small fw-semibold text-uppercase tracking-wider">Today's Visits</div>
                    <i class="bi bi-calendar-check metric-icon"></i>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="metric-card warning">
                    <div class="display-6 fw-bold">${metrics['pending'] != null ? metrics['pending'] : 0}</div>
                    <div class="small fw-semibold text-uppercase tracking-wider">Pending Verification</div>
                    <i class="bi bi-hourglass-split metric-icon"></i>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="metric-card success">
                    <div class="display-6 fw-bold">${metrics['confirmed'] != null ? metrics['confirmed'] : 0}</div>
                    <div class="small fw-semibold text-uppercase tracking-wider">Confirmed Slots</div>
                    <i class="bi bi-patch-check-fill metric-icon"></i>
                </div>
            </div>
            <div class="col-md-2 col-sm-6">
                <div class="metric-card danger">
                    <div class="display-6 fw-bold">${metrics['cancelled'] != null ? metrics['cancelled'] : 0}</div>
                    <div class="small fw-semibold text-uppercase tracking-wider">Cancelled</div>
                    <i class="bi bi-x-octagon metric-icon"></i>
                </div>
            </div>
        </div>

        <!-- FILTER & SORT TOOLBAR (CASE STUDY REQUIREMENT) -->
        <div class="card clinic-card border-0 mb-4 p-3 shadow-sm bg-white">
            <form action="${pageContext.request.contextPath}/receptionistDashboard" method="get" class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted">Filter / Sort by Date</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-calendar text-primary"></i></span>
                        <input type="date" name="filterDate" class="form-control" value="${filterDate}" data-allow-past="true">
                    </div>
                </div>

                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted">Filter by Doctor</label>
                    <select name="filterDoctor" class="form-select">
                        <option value="">-- All Doctors --</option>
                        <c:forEach var="d" items="${doctors}">
                            <option value="${d.doctorId}" ${filterDoctor eq d.doctorId ? 'selected' : ''}>
                                ${d.doctorName} (${d.specialization})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="form-label small fw-semibold text-muted">Filter by Status</label>
                    <select name="filterStatus" class="form-select">
                        <option value="ALL" ${filterStatus eq 'ALL' ? 'selected' : ''}>-- All Statuses --</option>
                        <option value="Pending" ${filterStatus eq 'Pending' ? 'selected' : ''}>Pending</option>
                        <option value="Confirmed" ${filterStatus eq 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                        <option value="Cancelled" ${filterStatus eq 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                        <option value="Completed" ${filterStatus eq 'Completed' ? 'selected' : ''}>Completed</option>
                    </select>
                </div>

                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-clinic flex-grow-1 fw-bold">
                        <i class="bi bi-funnel-fill me-1"></i> Apply Filters
                    </button>
                    <a href="${pageContext.request.contextPath}/receptionistDashboard" class="btn btn-outline-secondary" title="Reset Filters">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </a>
                </div>
            </form>
        </div>

        <!-- MASTER SCHEDULE TABLE -->
        <div class="card clinic-card shadow border-0 overflow-hidden">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h5 class="fw-bold text-dark mb-0">
                    <i class="bi bi-table text-primary me-2"></i>Patient Appointments Schedule
                </h5>
                <span class="badge bg-primary rounded-pill px-3 py-2">${appointments.size()} Records Found</span>
            </div>

            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Token</th>
                                <th>Patient Info</th>
                                <th>Doctor Assigned</th>
                                <th>Consultation Date</th>
                                <th>Time Slot</th>
                                <th>Reason for Visit</th>
                                <th>Status</th>
                                <th class="text-end pe-4">Front-Desk Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty appointments}">
                                    <c:forEach var="apt" items="${appointments}">
                                        <tr>
                                            <td class="ps-4">
                                                <span class="badge bg-light text-primary border fw-bold">${apt.appointmentToken}</span>
                                            </td>
                                            <td>
                                                <strong class="text-dark d-block">${apt.patientName}</strong>
                                                <small class="text-muted"><i class="bi bi-telephone text-secondary me-1"></i>${apt.patientPhone} | ID: ${apt.patientId}</small>
                                            </td>
                                            <td>
                                                <strong class="text-primary d-block">${apt.doctorName}</strong>
                                                <small class="text-muted">${apt.doctorSpecialization} • <strong>${apt.doctorRoom}</strong></small>
                                            </td>
                                            <td>
                                                <i class="bi bi-calendar3 text-muted me-1"></i>
                                                <span class="fw-semibold">${apt.appointmentDate}</span>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark border"><i class="bi bi-clock me-1"></i>${apt.timeSlot}</span>
                                            </td>
                                            <td>
                                                <span class="d-inline-block text-truncate" style="max-width: 170px;" title="${apt.reason}">
                                                    ${apt.reason}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${apt.status eq 'Confirmed'}">
                                                        <span class="badge badge-status badge-status-confirmed">
                                                            <i class="bi bi-check-circle-fill me-1"></i> Confirmed
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${apt.status eq 'Pending'}">
                                                        <span class="badge badge-status badge-status-pending">
                                                            <i class="bi bi-hourglass-split me-1"></i> Pending
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${apt.status eq 'Cancelled'}">
                                                        <span class="badge badge-status badge-status-cancelled">
                                                            <i class="bi bi-x-circle-fill me-1"></i> Cancelled
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-status badge-status-completed">
                                                            <i class="bi bi-check2-all me-1"></i> ${apt.status}
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-4">
                                                <div class="d-inline-flex gap-1">
                                                    <!-- Slip Button -->
                                                    <a href="${pageContext.request.contextPath}/appointmentSlip?id=${apt.appointmentId}" 
                                                       target="_blank" class="btn btn-outline-secondary btn-sm" title="View / Print Token Slip">
                                                        <i class="bi bi-printer"></i>
                                                    </a>

                                                    <!-- Confirm Action (if Pending) -->
                                                    <c:if test="${apt.status eq 'Pending'}">
                                                        <form action="${pageContext.request.contextPath}/appointmentAction" method="post" class="d-inline">
                                                            <input type="hidden" name="appointmentId" value="${apt.appointmentId}">
                                                            <input type="hidden" name="action" value="CONFIRM">
                                                            <input type="hidden" name="remarks" value="Confirmed at Reception">
                                                            <button type="submit" class="btn btn-success btn-sm" title="Confirm Schedule">
                                                                <i class="bi bi-check-lg"></i> Confirm
                                                            </button>
                                                        </form>
                                                    </c:if>

                                                    <!-- Cancel Action (if not already cancelled) -->
                                                    <c:if test="${apt.status ne 'Cancelled' and apt.status ne 'Completed'}">
                                                        <form action="${pageContext.request.contextPath}/appointmentAction" method="post" class="d-inline" onsubmit="return confirm('Cancel this appointment? Slot will be released.');">
                                                            <input type="hidden" name="appointmentId" value="${apt.appointmentId}">
                                                            <input type="hidden" name="action" value="CANCEL">
                                                            <input type="hidden" name="remarks" value="Cancelled by Reception Desk">
                                                            <button type="submit" class="btn btn-outline-danger btn-sm" title="Cancel Schedule">
                                                                <i class="bi bi-x"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>

                                                    <!-- Complete Action (if Confirmed) -->
                                                    <c:if test="${apt.status eq 'Confirmed'}">
                                                        <form action="${pageContext.request.contextPath}/appointmentAction" method="post" class="d-inline">
                                                            <input type="hidden" name="appointmentId" value="${apt.appointmentId}">
                                                            <input type="hidden" name="action" value="COMPLETE">
                                                            <input type="hidden" name="remarks" value="Consultation completed">
                                                            <button type="submit" class="btn btn-outline-primary btn-sm" title="Mark Consultation Completed">
                                                                <i class="bi bi-check2-circle"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5">
                                            <i class="bi bi-calendar-x fs-1 text-muted d-block mb-3"></i>
                                            <h5 class="text-muted">No appointments found matching your filter criteria.</h5>
                                            <p class="text-muted small">Try adjusting your date, doctor, or status filter.</p>
                                            <a href="${pageContext.request.contextPath}/receptionistDashboard" class="btn btn-outline-primary btn-sm rounded-pill">
                                                Reset Filters
                                            </a>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="common/footer.jsp" %>
