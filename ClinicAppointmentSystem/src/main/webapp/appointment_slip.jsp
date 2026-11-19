<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Appointment Slip - ${apt.appointmentToken}" />
<%@ include file="common/header.jsp" %>

<main class="py-4">
    <div class="container">
        <!-- TOP TOOLBAR (HIDDEN ON PRINT) -->
        <div class="d-flex justify-content-between align-items-center mb-3 no-print" style="max-width: 720px; margin: 0 auto;">
            <a href="${pageContext.request.contextPath}/myAppointments" class="btn btn-outline-secondary btn-sm rounded-pill">
                <i class="bi bi-arrow-left me-1"></i> Back to My Appointments
            </a>
            <button onclick="window.print()" class="btn btn-clinic btn-sm rounded-pill px-4 shadow">
                <i class="bi bi-printer-fill me-1"></i> Print / Save as PDF
            </button>
        </div>

        <!-- MEDICAL APPOINTMENT SLIP CARD -->
        <div class="medical-slip">
            <!-- CLINIC HEADER -->
            <div class="slip-header text-center">
                <div class="d-flex align-items-center justify-content-center mb-1">
                    <i class="bi bi-hospital fs-1 text-primary me-2"></i>
                    <div>
                        <h3 class="fw-bold mb-0 text-primary">CITYCARE MULTI-SPECIALITY CLINIC</h3>
                        <small class="text-uppercase tracking-wider text-muted fw-bold">Outpatient Department (OPD) Consultation Token</small>
                    </div>
                </div>
                <p class="small text-muted mb-0">Main Road, Mylavaram, NTR District, Andhra Pradesh - 521230 | Helpline: +91 866 2469666</p>
            </div>

            <!-- TOKEN BANNER -->
            <div class="row align-items-center mb-4 text-center text-md-start">
                <div class="col-md-6 mb-3 mb-md-0">
                    <small class="text-muted text-uppercase fw-semibold d-block">Official Booking Token</small>
                    <div class="slip-token mt-1">${apt.appointmentToken}</div>
                </div>
                <div class="col-md-6 text-md-end">
                    <small class="text-muted text-uppercase fw-semibold d-block">Current Status</small>
                    <c:choose>
                        <c:when test="${apt.status eq 'Confirmed'}">
                            <span class="badge bg-success fs-6 px-3 py-2 rounded-pill mt-1">
                                <i class="bi bi-check-circle-fill me-1"></i> CONFIRMED
                            </span>
                        </c:when>
                        <c:when test="${apt.status eq 'Pending'}">
                            <span class="badge bg-warning text-dark fs-6 px-3 py-2 rounded-pill mt-1">
                                <i class="bi bi-hourglass-split me-1"></i> PENDING VERIFICATION
                            </span>
                        </c:when>
                        <c:when test="${apt.status eq 'Cancelled'}">
                            <span class="badge bg-danger fs-6 px-3 py-2 rounded-pill mt-1">
                                <i class="bi bi-x-circle-fill me-1"></i> CANCELLED
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-primary fs-6 px-3 py-2 rounded-pill mt-1">${apt.status}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- APPOINTMENT & DOCTOR DETAILS -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6">
                    <div class="p-3 bg-light rounded border h-100">
                        <small class="text-uppercase text-muted fw-bold d-block mb-2">Patient Details</small>
                        <h5 class="fw-bold text-dark mb-1">${apt.patientName}</h5>
                        <div class="small text-muted">Patient ID: <strong>${apt.patientId}</strong></div>
                        <div class="small text-muted">Phone: <strong>${apt.patientPhone}</strong></div>
                        <div class="small text-muted">Email: <strong>${apt.patientEmail}</strong></div>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="p-3 bg-light rounded border h-100">
                        <small class="text-uppercase text-muted fw-bold d-block mb-2">Doctor &amp; OPD Cabin</small>
                        <h5 class="fw-bold text-primary mb-1">${apt.doctorName}</h5>
                        <div class="small text-muted">Specialization: <strong>${apt.doctorSpecialization}</strong></div>
                        <div class="small text-muted">Consultation Cabin: <strong>${apt.doctorRoom}</strong></div>
                        <div class="small text-muted">OPD Fee: <strong class="text-success">₹${apt.consultationFee}</strong></div>
                    </div>
                </div>
            </div>

            <!-- SCHEDULE BOX -->
            <div class="card border-primary mb-4" style="background-color: #f0f9ff;">
                <div class="card-body p-3">
                    <div class="row text-center">
                        <div class="col-6 border-end border-primary">
                            <small class="text-uppercase text-muted fw-semibold d-block">Appointment Date</small>
                            <span class="fw-bold fs-5 text-dark">${apt.appointmentDate}</span>
                        </div>
                        <div class="col-6">
                            <small class="text-uppercase text-muted fw-semibold d-block">Scheduled Time Slot</small>
                            <span class="fw-bold fs-5 text-primary">${apt.timeSlot}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- REASON FOR VISIT -->
            <div class="mb-4">
                <small class="text-uppercase text-muted fw-bold d-block mb-1">Reason for Visit / Chief Complaint</small>
                <p class="p-2 bg-light rounded border small mb-0">${apt.reason}</p>
            </div>

            <!-- INSTRUCTIONS & POLICIES -->
            <div class="border-top pt-3 small text-muted">
                <strong class="text-dark d-block mb-1"><i class="bi bi-info-circle text-primary me-1"></i>Patient Instructions:</strong>
                <ol class="ps-3 mb-0">
                    <li>Please report to the Front Desk at least 15 minutes before your scheduled appointment.</li>
                    <li>Present this digital token / printed slip at <strong>${apt.doctorRoom}</strong>.</li>
                    <li>Bring your past medical history, relevant X-rays, lab reports, and current prescriptions.</li>
                    <li>If you need to reschedule or cancel, please do so at least 2 hours in advance.</li>
                </ol>
            </div>

            <div class="mt-4 pt-3 border-top d-flex justify-content-between align-items-center text-muted small">
                <span>Booked On: ${apt.createdAt}</span>
                <span class="fst-italic">CityCare Digital Hospital System</span>
            </div>
        </div>
    </div>
</main>

<%@ include file="common/footer.jsp" %>
