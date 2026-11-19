<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="CityCare Clinic - Smart Appointment Scheduling Platform" />
<%@ include file="common/header.jsp" %>
<%@ include file="common/navbar.jsp" %>

<main>
    <!-- HERO SECTION WITH INTEGRATED PATIENT LOGIN -->
    <section class="clinic-hero">
        <div class="container">
            <div class="row align-items-center gy-4">
                <div class="col-lg-7 text-center text-lg-start">
                    <span class="badge bg-light text-primary px-3 py-2 rounded-pill fw-bold mb-3 shadow-sm">
                        <i class="bi bi-heart-pulse-fill text-danger me-1"></i> Multi-Speciality Outpatient Services
                    </span>
                    <h1 class="display-4 fw-bold mb-3 text-white">Smart Clinic Appointment Scheduling System</h1>
                    <p class="lead text-white-50 mb-4" style="max-width: 600px;">
                        Effortless healthcare consultations without long queues. Book appointments with top medical specialists, receive verified digital tokens, and track real-time schedule statuses.
                    </p>
                    <div class="d-flex flex-wrap gap-3 justify-content-center justify-content-lg-start">
                        <a href="${pageContext.request.contextPath}/patient_register.jsp" class="btn btn-warning btn-lg px-4 py-3 fw-bold rounded-pill text-dark shadow">
                            <i class="bi bi-person-plus-fill me-2"></i> Register New Patient
                        </a>
                        <a href="${pageContext.request.contextPath}/receptionist_login.jsp" class="btn btn-outline-light btn-lg px-4 py-3 rounded-pill fw-semibold">
                            <i class="bi bi-shield-lock me-2"></i> Receptionist Desk
                        </a>
                    </div>
                </div>

                <!-- FAST PATIENT LOGIN CARD -->
                <div class="col-lg-5">
                    <div class="card clinic-card shadow-lg border-0 overflow-hidden">
                        <div class="auth-header">
                            <h4 class="fw-bold mb-1"><i class="bi bi-person-circle me-2"></i>Patient Login</h4>
                            <p class="small text-white-50 mb-0">Access your appointments & medical slips</p>
                        </div>
                        <div class="card-body p-4">
                            <c:if test="${not empty param.msg and param.msg eq 'logged_out'}">
                                <div class="alert alert-success alert-dismissible fade show small" role="alert">
                                    <i class="bi bi-check-circle-fill me-1"></i> You have logged out successfully.
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty param.msg and param.msg eq 'unauthorized'}">
                                <div class="alert alert-warning alert-dismissible fade show small" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill me-1"></i> Please log in to access this page.
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/patientLogin" method="post">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold small text-muted">Patient ID or Email Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="bi bi-person text-primary"></i></span>
                                        <input type="text" name="idOrEmail" class="form-control" placeholder="e.g. PAT101 or email@example.com" required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold small text-muted">Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="bi bi-lock text-primary"></i></span>
                                        <input type="password" name="password" class="form-control" placeholder="Enter password" required>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-clinic w-100 py-2 fw-bold">
                                    <i class="bi bi-box-arrow-in-right me-1"></i> Sign In to Patient Portal
                                </button>
                            </form>

                            <div class="mt-3 text-center small">
                                <span class="text-muted">New Patient?</span>
                                <a href="${pageContext.request.contextPath}/patient_register.jsp" class="fw-bold text-primary text-decoration-none">
                                    Register Account Here &rarr;
                                </a>
                            </div>

                            <hr class="my-3">
                            <div class="bg-light p-2 rounded small text-muted">
                                <strong><i class="bi bi-info-circle text-primary me-1"></i>Quick Test Accounts:</strong><br>
                                <span>Patient: <code>PAT101</code> / <code>pass123</code></span><br>
                                <span>Student: <code>24761A05S2</code> / <code>pass123</code></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- KEY FEATURES SECTION -->
    <section class="py-5">
        <div class="container">
            <div class="text-center mb-5">
                <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill fw-bold">Enterprise Healthcare Workflow</span>
                <h2 class="fw-bold mt-2">Why CityCare Appointment Platform?</h2>
                <p class="text-muted">A robust, full-stack clinic management system engineered for zero scheduling conflicts.</p>
            </div>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card clinic-card h-100 p-4 text-center">
                        <div class="rounded-circle bg-primary bg-opacity-10 text-primary p-3 d-inline-block mx-auto mb-3" style="width: 70px; height: 70px;">
                            <i class="bi bi-calendar-check fs-2"></i>
                        </div>
                        <h5 class="fw-bold">Zero Double-Booking</h5>
                        <p class="text-muted small">Transactional concurrency checks ensure that no two patients can ever reserve the same doctor and time slot simultaneously.</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card clinic-card h-100 p-4 text-center">
                        <div class="rounded-circle bg-success bg-opacity-10 text-success p-3 d-inline-block mx-auto mb-3" style="width: 70px; height: 70px;">
                            <i class="bi bi-receipt-cutoff fs-2"></i>
                        </div>
                        <h5 class="fw-bold">Digital Appointment Slips</h5>
                        <p class="text-muted small">Instant printable medical tokens with room numbers, doctor details, scheduled time, and patient details for smooth OPD check-in.</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card clinic-card h-100 p-4 text-center">
                        <div class="rounded-circle bg-warning bg-opacity-10 text-warning p-3 d-inline-block mx-auto mb-3" style="width: 70px; height: 70px;">
                            <i class="bi bi-shield-check fs-2"></i>
                        </div>
                        <h5 class="fw-bold">Front-Desk Dashboard</h5>
                        <p class="text-muted small">Receptionists can filter schedules by date and doctor, confirm or cancel appointments, and monitor patient footfalls in real time.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- AVAILABLE MEDICAL SPECIALISTS -->
    <section class="py-5 bg-white border-top">
        <div class="container">
            <div class="text-center mb-5">
                <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill fw-bold">Outpatient Departments</span>
                <h2 class="fw-bold mt-2">Specialist Doctors On Duty</h2>
                <p class="text-muted">Consult experienced medical practitioners across multiple medical disciplines.</p>
            </div>

            <div class="row g-4">
                <div class="col-md-4 col-sm-6">
                    <div class="card clinic-card p-3 h-100">
                        <div class="d-flex align-items-center mb-3">
                            <div class="bg-primary text-white rounded-circle p-3 me-3 text-center" style="width: 55px; height: 55px;">
                                <i class="bi bi-heart-pulse fs-4"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-0">Dr. Arvind Swamy</h6>
                                <span class="badge bg-info bg-opacity-25 text-primary small">Cardiology</span>
                            </div>
                        </div>
                        <p class="small text-muted mb-2">MBBS, MD, DM (Cardiology) • 14 Years Exp</p>
                        <div class="d-flex justify-content-between small text-muted border-top pt-2 mt-auto">
                            <span><i class="bi bi-geo-alt text-primary"></i> Room 101</span>
                            <span class="fw-bold text-success">Fee: ₹500</span>
                        </div>
                    </div>
                </div>

                <div class="col-md-4 col-sm-6">
                    <div class="card clinic-card p-3 h-100">
                        <div class="d-flex align-items-center mb-3">
                            <div class="bg-success text-white rounded-circle p-3 me-3 text-center" style="width: 55px; height: 55px;">
                                <i class="bi bi-emoji-smile fs-4"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-0">Dr. Sneha Reddy</h6>
                                <span class="badge bg-success bg-opacity-25 text-success small">Pediatrics</span>
                            </div>
                        </div>
                        <p class="small text-muted mb-2">MBBS, MD (Pediatrics) • 9 Years Exp</p>
                        <div class="d-flex justify-content-between small text-muted border-top pt-2 mt-auto">
                            <span><i class="bi bi-geo-alt text-primary"></i> Room 102</span>
                            <span class="fw-bold text-success">Fee: ₹400</span>
                        </div>
                    </div>
                </div>

                <div class="col-md-4 col-sm-6">
                    <div class="card clinic-card p-3 h-100">
                        <div class="d-flex align-items-center mb-3">
                            <div class="bg-danger text-white rounded-circle p-3 me-3 text-center" style="width: 55px; height: 55px;">
                                <i class="bi bi-capsule fs-4"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-0">Dr. Rajesh Varma</h6>
                                <span class="badge bg-danger bg-opacity-25 text-danger small">General Medicine</span>
                            </div>
                        </div>
                        <p class="small text-muted mb-2">MBBS, MD (Internal Medicine) • 16 Years Exp</p>
                        <div class="d-flex justify-content-between small text-muted border-top pt-2 mt-auto">
                            <span><i class="bi bi-geo-alt text-primary"></i> Room 103</span>
                            <span class="fw-bold text-success">Fee: ₹300</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<%@ include file="common/footer.jsp" %>
