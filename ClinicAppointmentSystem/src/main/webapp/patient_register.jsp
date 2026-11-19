<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="New Patient Registration - CityCare Clinic" />
<%@ include file="common/header.jsp" %>
<%@ include file="common/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card clinic-card shadow border-0 overflow-hidden">
                    <div class="auth-header">
                        <i class="bi bi-person-plus-fill fs-1 text-warning mb-2 d-inline-block"></i>
                        <h3 class="fw-bold mb-1">New Patient Registration</h3>
                        <p class="small text-white-50 mb-0">Create your health record profile to book consultations</p>
                    </div>

                    <div class="card-body p-4 p-md-5">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/patientRegister" method="post" id="regForm">
                            <div class="row g-3">
                                <!-- Patient ID & Name -->
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Patient ID <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="bi bi-card-text text-primary"></i></span>
                                        <input type="text" name="patientId" class="form-control" placeholder="e.g. PAT105 or 24761A05S2" required>
                                    </div>
                                    <small class="text-muted">Unique Hospital Identifier or Student Roll No</small>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="bi bi-person text-primary"></i></span>
                                        <input type="text" name="patientName" class="form-control" placeholder="e.g. Hemalatha Ganji" required>
                                    </div>
                                </div>

                                <!-- DOB & Gender -->
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Date of Birth <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="bi bi-calendar text-primary"></i></span>
                                        <input type="date" name="dob" class="form-control" data-allow-past="true" required>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Gender <span class="text-danger">*</span></label>
                                    <select name="gender" class="form-select" required>
                                        <option value="" disabled selected>-- Select Gender --</option>
                                        <option value="Female">Female</option>
                                        <option value="Male">Male</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>

                                <!-- Phone & Email -->
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Phone Number <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="bi bi-telephone text-primary"></i></span>
                                        <input type="tel" name="phone" class="form-control" placeholder="10-digit mobile number" pattern="[0-9]{10}" required>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Email Address <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="bi bi-envelope text-primary"></i></span>
                                        <input type="email" name="email" class="form-control" placeholder="patient@example.com" required>
                                    </div>
                                </div>

                                <!-- Password & Blood Group -->
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Password <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="bi bi-lock text-primary"></i></span>
                                        <input type="password" name="password" class="form-control" placeholder="Create secure password" required minlength="4">
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Blood Group</label>
                                    <select name="bloodGroup" class="form-select">
                                        <option value="O+" selected>O+ (Positive)</option>
                                        <option value="O-">O- (Negative)</option>
                                        <option value="A+">A+ (Positive)</option>
                                        <option value="A-">A- (Negative)</option>
                                        <option value="B+">B+ (Positive)</option>
                                        <option value="B-">B- (Negative)</option>
                                        <option value="AB+">AB+ (Positive)</option>
                                        <option value="AB-">AB- (Negative)</option>
                                    </select>
                                </div>

                                <!-- Address -->
                                <div class="col-12">
                                    <label class="form-label fw-semibold">Residential Address</label>
                                    <textarea name="address" class="form-control" rows="2" placeholder="Street, Landmark, Area, City (e.g. Mylavaram)"></textarea>
                                </div>
                            </div>

                            <div class="mt-4 pt-2">
                                <button type="submit" class="btn btn-clinic btn-lg w-100 fw-bold">
                                    <i class="bi bi-check-circle-fill me-2"></i> Register Profile & Proceed to Login
                                </button>
                            </div>
                        </form>

                        <div class="text-center mt-4 pt-3 border-top">
                            <span class="text-muted">Already registered as a patient?</span>
                            <a href="${pageContext.request.contextPath}/patient_login.jsp" class="fw-bold text-primary text-decoration-none ms-1">
                                Click Here to Login &rarr;
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="common/footer.jsp" %>
