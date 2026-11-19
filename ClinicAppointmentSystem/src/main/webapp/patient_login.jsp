<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Patient Login - CityCare Clinic" />
<%@ include file="common/header.jsp" %>
<%@ include file="common/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <div class="auth-container">
            <div class="card clinic-card shadow border-0 overflow-hidden">
                <div class="auth-header">
                    <i class="bi bi-heart-pulse-fill fs-1 text-warning mb-2 d-inline-block"></i>
                    <h3 class="fw-bold mb-1">Patient Sign In</h3>
                    <p class="small text-white-50 mb-0">Enter your Patient ID or registered Email</p>
                </div>

                <div class="card-body p-4">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty param.msg and param.msg eq 'registered'}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> Registration successful! You can now log in using your Patient ID (${param.newId}) or Email.
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty param.msg and param.msg eq 'unauthorized'}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            <i class="bi bi-lock-fill me-2"></i> Please log in to view or book your appointments.
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/patientLogin" method="post">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Patient ID or Email Address <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-person text-primary"></i></span>
                                <input type="text" name="idOrEmail" class="form-control form-control-lg" 
                                       value="${prevUser != null ? prevUser : ''}" placeholder="e.g. PAT101 or bhavani@example.com" required autofocus>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Password <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-key text-primary"></i></span>
                                <input type="password" name="password" class="form-control form-control-lg" placeholder="Enter your password" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-clinic btn-lg w-100 fw-bold mt-2">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Sign In to Portal
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-3 border-top">
                        <p class="text-muted mb-1">Don't have a registered patient profile?</p>
                        <a href="${pageContext.request.contextPath}/patient_register.jsp" class="btn btn-outline-primary btn-sm rounded-pill px-4 fw-semibold">
                            <i class="bi bi-person-plus me-1"></i> Create New Patient Profile
                        </a>
                    </div>

                    <div class="bg-light p-3 rounded mt-4 small border">
                        <strong class="text-dark"><i class="bi bi-shield-check text-success me-1"></i>Pre-Configured Demo Credentials:</strong>
                        <ul class="mb-0 mt-1 ps-3 text-muted">
                            <li>Patient: <code>PAT101</code> / <code>pass123</code> (Bhavani Krishna)</li>
                            <li>Student: <code>24761A05S2</code> / <code>pass123</code> (Hemalatha Ganji)</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="common/footer.jsp" %>
