<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark navbar-clinic sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-hospital me-2 fs-3 text-warning"></i>
            <div>
                <span class="fw-bold">CityCare Clinic</span>
                <small class="d-block text-white-50" style="font-size: 0.72rem; letter-spacing: 0.5px;">APPOINTMENT SCHEDULING</small>
            </div>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#clinicNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="clinicNavbar">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">
                        <i class="bi bi-house-door me-1"></i> Home
                    </a>
                </li>

                <c:choose>
                    <c:when test="${not empty sessionScope.patient}">
                        <!-- Patient Logged In -->
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/patientHome">
                                <i class="bi bi-calendar2-plus me-1"></i> Book Appointment
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/myAppointments">
                                <i class="bi bi-card-checklist me-1"></i> My Appointments
                            </a>
                        </li>
                        <li class="nav-item ms-lg-3 my-2 my-lg-0">
                            <span class="badge bg-light text-primary px-3 py-2 rounded-pill fw-semibold shadow-sm">
                                <i class="bi bi-person-circle me-1"></i> ${sessionScope.patient.patientName} (${sessionScope.patient.patientId})
                            </span>
                        </li>
                        <li class="nav-item ms-lg-2">
                            <a class="btn btn-outline-light btn-sm rounded-pill px-3" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right me-1"></i> Logout
                            </a>
                        </li>
                    </c:when>

                    <c:when test="${not empty sessionScope.receptionist}">
                        <!-- Receptionist Logged In -->
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/receptionistDashboard">
                                <i class="bi bi-speedometer2 me-1"></i> Front Desk Dashboard
                            </a>
                        </li>
                        <li class="nav-item ms-lg-3 my-2 my-lg-0">
                            <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold shadow-sm">
                                <i class="bi bi-shield-lock me-1"></i> Reception Desk (${sessionScope.receptionist.username})
                            </span>
                        </li>
                        <li class="nav-item ms-lg-2">
                            <a class="btn btn-outline-light btn-sm rounded-pill px-3" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right me-1"></i> Logout
                            </a>
                        </li>
                    </c:when>

                    <c:otherwise>
                        <!-- Visitor (Not Logged In) -->
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/patient_login.jsp">
                                <i class="bi bi-person-fill me-1"></i> Patient Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/patient_register.jsp">
                                <i class="bi bi-person-plus me-1"></i> Register
                            </a>
                        </li>
                        <li class="nav-item ms-lg-3">
                            <a class="btn btn-warning btn-sm rounded-pill px-3 text-dark fw-bold" href="${pageContext.request.contextPath}/receptionist_login.jsp">
                                <i class="bi bi-shield-check me-1"></i> Receptionist Portal
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
