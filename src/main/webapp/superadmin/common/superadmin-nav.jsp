<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-black sticky-top shadow py-2">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/superadmin/dashboard">
            <i class="bi bi-shield-check text-warning fs-4"></i>
            <span>SUPER<span style="color: var(--accent-orange);">ADMIN</span></span>
            <span class="badge bg-danger small ms-1">Master Control</span>
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#superNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="superNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${superPage == 'dashboard' ? 'active text-warning fw-bold' : ''}" href="${pageContext.request.contextPath}/superadmin/dashboard">
                        <i class="bi bi-speedometer me-1"></i> Platform Overview
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${superPage == 'restaurants' ? 'active text-warning fw-bold' : ''}" href="${pageContext.request.contextPath}/superadmin/restaurants">
                        <i class="bi bi-shop me-1"></i> Restaurants
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${superPage == 'areas' ? 'active text-warning fw-bold' : ''}" href="${pageContext.request.contextPath}/superadmin/areas">
                        <i class="bi bi-geo-alt me-1"></i> Service Areas
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${superPage == 'admins' ? 'active text-warning fw-bold' : ''}" href="${pageContext.request.contextPath}/superadmin/admins">
                        <i class="bi bi-people me-1"></i> Admin Users
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${superPage == 'orders' ? 'active text-warning fw-bold' : ''}" href="${pageContext.request.contextPath}/superadmin/orders">
                        <i class="bi bi-receipt-cutoff me-1"></i> All Orders
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${superPage == 'reservations' ? 'active text-warning fw-bold' : ''}" href="${pageContext.request.contextPath}/superadmin/reservations">
                        <i class="bi bi-calendar2-range me-1"></i> All Reservations
                    </a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-info btn-sm">
                    <i class="bi bi-arrow-left-right me-1"></i> Restaurant Portal
                </a>
                <a href="${pageContext.request.contextPath}/home" target="_blank" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-box-arrow-up-right me-1"></i> Customer Front
                </a>
                <a href="${pageContext.request.contextPath}/admin/logout" class="btn btn-danger btn-sm">
                    <i class="bi bi-box-arrow-right me-1"></i> Logout
                </a>
            </div>
        </div>
    </div>
</nav>

