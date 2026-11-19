<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="bi bi-fire text-warning fs-4"></i>
            <span>${restaurant != null ? restaurant.name : 'Restaurant'} <span class="badge bg-secondary small ms-1">Manager</span></span>
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="adminNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${adminPage == 'dashboard' ? 'active text-warning fw-bold' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${adminPage == 'orders' ? 'active text-warning fw-bold' : ''}" href="${pageContext.request.contextPath}/admin/orders">
                        <i class="bi bi-bag-check me-1"></i> Orders
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${adminPage == 'menu' ? 'active text-warning fw-bold' : ''}" href="${pageContext.request.contextPath}/admin/menu">
                        <i class="bi bi-journal-text me-1"></i> Menu Items
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${adminPage == 'tables' ? 'active text-warning fw-bold' : ''}" href="${pageContext.request.contextPath}/admin/tables">
                        <i class="bi bi-grid-3x3-gap me-1"></i> Dining Tables
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${adminPage == 'reservations' ? 'active text-warning fw-bold' : ''}" href="${pageContext.request.contextPath}/admin/reservations">
                        <i class="bi bi-calendar-event me-1"></i> Reservations
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${adminPage == 'invoices' ? 'active text-warning fw-bold' : ''}" href="${pageContext.request.contextPath}/admin/invoices">
                        <i class="bi bi-receipt me-1"></i> Invoices
                    </a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-3">
                <span class="text-white-50 small d-none d-md-inline">
                    Logged as: <strong class="text-white">${sessionScope.loggedAdmin.fullName}</strong>
                </span>
                <c:if test="${sessionScope.loggedAdmin.superAdmin}">
                    <a href="${pageContext.request.contextPath}/superadmin/dashboard" class="btn btn-outline-warning btn-sm">
                        <i class="bi bi-gear-wide-connected me-1"></i> Super Admin Panel
                    </a>
                </c:if>
                <a href="${pageContext.request.contextPath}/home" target="_blank" class="btn btn-outline-light btn-sm" title="View Storefront">
                    <i class="bi bi-box-arrow-up-right me-1"></i> Storefront
                </a>
                <a href="${pageContext.request.contextPath}/admin/logout" class="btn btn-danger btn-sm">
                    <i class="bi bi-box-arrow-right me-1"></i> Logout
                </a>
            </div>
        </div>
    </div>
</nav>

