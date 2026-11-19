<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Appointments - CityCare Clinic" />
<%@ include file="common/header.jsp" %>
<%@ include file="common/navbar.jsp" %>

<main class="py-4">
    <div class="container">
        <!-- HEADER -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h3 class="fw-bold mb-1 text-dark">
                    <i class="bi bi-calendar2-heart text-primary me-2"></i>My Consultations &amp; Schedules
                </h3>
                <p class="text-muted small mb-0">Track real-time appointment confirmations and download digital slips</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/patientHome#bookingSection" class="btn btn-clinic rounded-pill fw-semibold">
                    <i class="bi bi-plus-circle me-1"></i> Book Another Appointment
                </a>
            </div>
        </div>

        <!-- SUCCESS / STATUS NOTIFICATIONS -->
        <c:if test="${not empty param.msg and param.msg eq 'booked'}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill fs-5 me-2"></i>
                <strong>Success!</strong> Your appointment request has been submitted with Token <code>${param.token}</code>. Status is initially <strong>Pending</strong> awaiting front-desk confirmation.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.msg and param.msg eq 'cancelled'}">
            <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-info-circle-fill fs-5 me-2"></i>
                <strong>Cancelled:</strong> Your appointment has been cancelled and the slot has been released.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- APPOINTMENTS TABLE -->
        <div class="card clinic-card shadow border-0 overflow-hidden">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Token &amp; ID</th>
                                <th>Doctor Details</th>
                                <th>Consultation Date</th>
                                <th>Time Slot</th>
                                <th>Reason for Visit</th>
                                <th>Status</th>
                                <th class="text-end pe-4">Actions</th>
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
                                                <strong class="text-dark d-block">${apt.doctorName}</strong>
                                                <small class="text-muted">${apt.doctorSpecialization} • ${apt.doctorRoom}</small>
                                            </td>
                                            <td>
                                                <i class="bi bi-calendar3 text-muted me-1"></i>
                                                <span class="fw-semibold">${apt.appointmentDate}</span>
                                            </td>
                                            <td>
                                                <i class="bi bi-clock text-muted me-1"></i>
                                                <span>${apt.timeSlot}</span>
                                            </td>
                                            <td>
                                                <span class="d-inline-block text-truncate" style="max-width: 180px;" title="${apt.reason}">
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
                                                <div class="d-inline-flex gap-2">
                                                    <!-- Printable Slip -->
                                                    <a href="${pageContext.request.contextPath}/appointmentSlip?id=${apt.appointmentId}" 
                                                       class="btn btn-outline-primary btn-sm rounded-pill" title="Print / Download Slip" target="_blank">
                                                        <i class="bi bi-printer me-1"></i> Slip
                                                    </a>

                                                    <!-- Cancel button (allowed if Pending) -->
                                                    <c:if test="${apt.status eq 'Pending'}">
                                                        <form action="${pageContext.request.contextPath}/appointmentAction" method="post" class="d-inline" onsubmit="return confirmCancelAction(this);">
                                                            <input type="hidden" name="appointmentId" value="${apt.appointmentId}">
                                                            <input type="hidden" name="action" value="PATIENT_CANCEL">
                                                            <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill" title="Cancel Appointment">
                                                                <i class="bi bi-x-circle"></i> Cancel
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
                                        <td colspan="7" class="text-center py-5">
                                            <i class="bi bi-calendar-x fs-1 text-muted d-block mb-3"></i>
                                            <h5 class="text-muted">No appointments found.</h5>
                                            <p class="text-muted small">You haven't scheduled any doctor consultations yet.</p>
                                            <a href="${pageContext.request.contextPath}/patientHome#bookingSection" class="btn btn-clinic btn-sm rounded-pill px-4 mt-2">
                                                Book Your First Consultation Now
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
