<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff & Admin Sign In - Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center min-vh-100 py-5">

<div class="container" style="max-width: 440px;">
    <div class="text-center mb-4">
        <a href="${pageContext.request.contextPath}/home" class="d-inline-flex align-items-center gap-2 text-decoration-none">
            <i class="bi bi-fire text-warning fs-1"></i>
            <span class="fs-3 fw-bold text-dark">Smart<span style="color: var(--accent-orange);">Restaurant</span></span>
        </a>
        <div class="text-secondary small mt-1">Management & Administration Portal</div>
    </div>

    <div class="card border-0 rounded-4 shadow-lg overflow-hidden">
        <div class="card-header py-4 text-white text-center" style="background: var(--primary-dark);">
            <i class="bi bi-shield-lock display-5 mb-2 d-block text-warning"></i>
            <h4 class="fw-bold mb-0">Authorized Sign In</h4>
            <div class="text-white-50 small">Restaurant Admins & Super Admins</div>
        </div>

        <div class="card-body p-4 p-md-5">
            <c:if test="${not empty error}">
                <div class="alert alert-danger small py-2 rounded-3 mb-3">
                    <i class="bi bi-exclamation-circle me-1"></i>${error}
                </div>
            </c:if>

            <c:if test="${param.logged_out == 'true'}">
                <div class="alert alert-success small py-2 rounded-3 mb-3">
                    <i class="bi bi-check-circle me-1"></i>You have been logged out successfully.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/login" method="POST">
                <div class="mb-3">
                    <label class="form-label small fw-semibold text-secondary">Username</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="bi bi-person text-muted"></i></span>
                        <input type="text" name="username" class="form-control border-start-0" 
                               placeholder="Enter admin username" required autofocus>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label small fw-semibold text-secondary">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="bi bi-key text-muted"></i></span>
                        <input type="password" name="password" class="form-control border-start-0" 
                               placeholder="Enter password" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-accent w-100 py-2 fw-bold">
                    <i class="bi bi-box-arrow-in-right me-1"></i> Log In to Portal
                </button>
            </form>

            <!-- Test Credentials Hint for Examiners -->
            <div class="mt-4 p-3 bg-light rounded-3 border small">
                <div class="fw-bold text-dark mb-1"><i class="bi bi-info-circle me-1 text-primary"></i> Demo Credentials:</div>
                <div class="text-secondary"><strong class="text-dark">Super Admin:</strong> <code>superadmin</code> / <code>admin123</code></div>
                <div class="text-secondary"><strong class="text-dark">Spice Garden:</strong> <code>admin_spice</code> / <code>admin123</code></div>
                <div class="text-secondary"><strong class="text-dark">Royal Biryani:</strong> <code>admin_royal</code> / <code>admin123</code></div>
            </div>
        </div>
    </div>

    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/home" class="text-muted small text-decoration-none">
            <i class="bi bi-arrow-left me-1"></i> Back to Customer Storefront
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

