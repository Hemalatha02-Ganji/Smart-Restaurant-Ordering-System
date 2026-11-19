<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Smart Restaurant - Ordering & Billing System'}</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Custom Theme CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
    </script>
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top">
    <div class="container">
        <!-- Brand Logo -->
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-fire text-warning fs-3"></i>
            <span>Smart<span style="color: var(--accent-orange);">Restaurant</span></span>
            <span class="brand-badge d-none d-sm-inline">2.0</span>
        </a>

        <!-- Area Selector Pill -->
        <div class="ms-lg-3 me-auto d-flex align-items-center">
            <button type="button" class="area-selector-pill" data-bs-toggle="modal" data-bs-target="#areaSelectionModal">
                <i class="bi bi-geo-alt-fill text-warning"></i>
                <span class="fw-semibold">${not empty sessionScope.customerArea ? sessionScope.customerArea : 'Select Area'}</span>
                <i class="bi bi-chevron-down small opacity-75"></i>
            </button>
            <c:if test="${not empty sessionScope.customerName}">
                <span class="text-white-50 ms-2 small d-none d-md-inline">
                    Hi, <strong class="text-white">${sessionScope.customerName}</strong>!
                </span>
            </c:if>
        </div>

        <!-- Toggler Button -->
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navbar Links -->
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav align-items-center gap-1 my-2 my-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'home' ? 'active' : ''}" href="${pageContext.request.contextPath}/home">
                        <i class="bi bi-house me-1"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'restaurants' ? 'active' : ''}" href="${pageContext.request.contextPath}/restaurants">
                        <i class="bi bi-shop me-1"></i> Restaurants
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'reservation' ? 'active' : ''}" href="${pageContext.request.contextPath}/reserve-table">
                        <i class="bi bi-calendar2-check me-1"></i> Book Table
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'tracking' ? 'active' : ''}" href="${pageContext.request.contextPath}/track-order">
                        <i class="bi bi-radar me-1"></i> Track Order
                    </a>
                </li>
                <li class="nav-item ms-lg-2">
                    <a class="btn btn-accent btn-sm d-flex align-items-center gap-2 px-3 py-2" href="${pageContext.request.contextPath}/cart">
                        <i class="bi bi-cart3 fs-6"></i>
                        <span>Cart</span>
                        <c:set var="cartCount" value="${sessionScope.cart != null ? sessionScope.cart.totalCount : 0}" />
                        <span id="navCartBadge" class="badge rounded-pill bg-white text-dark fw-bold ${cartCount > 0 ? '' : 'd-none'}">
                            ${cartCount}
                        </span>
                    </a>
                </li>
                <li class="nav-item ms-lg-1">
                    <a class="btn btn-outline-light btn-sm py-2 px-2" href="${pageContext.request.contextPath}/admin/login" title="Staff & Admin Portal">
                        <i class="bi bi-shield-lock"></i>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Area & Name Selection Modal (No login required) -->
<div class="modal fade" id="areaSelectionModal" tabindex="-1" aria-labelledby="areaModalLabel" aria-hidden="true" data-prompt="${promptArea ? 'true' : 'false'}">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: var(--radius-md);">
            <div class="modal-header text-white" style="background: var(--primary-dark); border-radius: var(--radius-md) var(--radius-md) 0 0;">
                <h5 class="modal-title fw-bold" id="areaModalLabel">
                    <i class="bi bi-geo-alt-fill text-warning me-2"></i>Welcome! Select Your Area
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/select-area" method="POST">
                <div class="modal-body p-4">
                    <p class="text-muted small mb-3">
                        No login or account creation needed! Enter your name and choose your location to view restaurants serving your neighborhood.
                    </p>
                    <div class="mb-3">
                        <label class="form-label fw-semibold text-secondary small">Your Name</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-person text-muted"></i></span>
                            <input type="text" name="customerName" class="form-control border-start-0" 
                                   placeholder="e.g. Bhavani" value="${sessionScope.customerName}" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold text-secondary small">Delivery / Service Area</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-pin-map text-muted"></i></span>
                            <select name="customerArea" class="form-select border-start-0" required>
                                <option value="Mylavaram" ${sessionScope.customerArea == 'Mylavaram' ? 'selected' : ''}>Mylavaram (521230)</option>
                                <option value="Vijayawada" ${sessionScope.customerArea == 'Vijayawada' ? 'selected' : ''}>Vijayawada (520001)</option>
                                <option value="Gannavaram" ${sessionScope.customerArea == 'Gannavaram' ? 'selected' : ''}>Gannavaram (521101)</option>
                                <option value="Ibrahimpatnam" ${sessionScope.customerArea == 'Ibrahimpatnam' ? 'selected' : ''}>Ibrahimpatnam (521456)</option>
                            </select>
                        </div>
                        <div class="form-text small">Restaurants will be dynamically filtered based on your selected area.</div>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 px-4 py-3" style="border-radius: 0 0 var(--radius-md) var(--radius-md);">
                    <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-accent px-4 btn-sm">Explore Restaurants</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Multi-Restaurant Cart Conflict Modal -->
<div class="modal fade" id="cartConflictModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: var(--radius-md);">
            <div class="modal-header bg-warning text-dark" style="border-radius: var(--radius-md) var(--radius-md) 0 0;">
                <h5 class="modal-title fw-bold">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>Different Restaurant Selected
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <i class="bi bi-cart-x text-warning display-4 mb-3 d-block"></i>
                <p id="conflictMessage" class="fw-semibold text-secondary">
                    Your cart contains items from another restaurant. You cannot mix items from different restaurants in one order.
                </p>
                <p class="text-muted small">
                    Would you like to discard the previous items and start a fresh order from this restaurant?
                </p>
            </div>
            <div class="modal-footer bg-light border-0 justify-content-center p-3">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Keep Existing Cart</button>
                <button type="button" id="btnConfirmClearCart" class="btn btn-accent">Discard & Add New Item</button>
            </div>
        </div>
    </div>
</div>

