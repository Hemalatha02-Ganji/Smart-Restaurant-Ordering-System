<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Areas Management - Super Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<c:set var="superPage" value="areas" />
<jsp:include page="common/superadmin-nav.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1 text-dark">Service Areas & Delivery Zones</h3>
            <p class="text-secondary small mb-0">Configure operational pin codes, map restaurant delivery radii, and customize delivery charges.</p>
        </div>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-primary-custom btn-sm" data-bs-toggle="modal" data-bs-target="#addAreaModal">
                <i class="bi bi-geo-alt-fill me-1"></i> Add Service Area
            </button>
            <button type="button" class="btn btn-accent btn-sm" data-bs-toggle="modal" data-bs-target="#assignAreaModal">
                <i class="bi bi-link-45deg me-1"></i> Map Restaurant to Area
            </button>
        </div>
    </div>

    <c:if test="${param.created == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-check-circle me-1"></i> Service area created!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.assigned == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-check-circle me-1"></i> Restaurant mapped to service area successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.removed == 'true'}">
        <div class="alert alert-warning alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-x-circle me-1"></i> Restaurant delivery mapping removed.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Grid of Areas -->
    <div class="row g-4 mb-4">
        <c:forEach var="a" items="${areas}">
            <div class="col-md-6 col-lg-3">
                <div class="card border-0 rounded-4 shadow-sm p-3 bg-white h-100">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <div class="rounded-circle p-2 bg-success-subtle text-success fs-4">
                            <i class="bi bi-pin-map-fill"></i>
                        </div>
                        <span class="badge ${a.active ? 'bg-success' : 'bg-secondary'} small">
                            ${a.active ? 'Active' : 'Inactive'}
                        </span>
                    </div>
                    <h5 class="fw-bold mb-1 text-dark">${a.areaName}</h5>
                    <div class="text-muted small mb-3">PIN Code: <strong>${a.pincode}</strong></div>
                    <div class="mt-auto">
                        <a href="${pageContext.request.contextPath}/restaurants?area=${a.areaName}" target="_blank" class="btn btn-outline-dark btn-sm w-100">
                            <i class="bi bi-eye me-1"></i> View Restaurants
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Modal: Add New Area -->
<div class="modal fade" id="addAreaModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle me-2 text-warning"></i>Add Service Area</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/superadmin/areas" method="POST">
                <input type="hidden" name="action" value="add-area">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Area / Locality Name <span class="text-danger">*</span></label>
                        <input type="text" name="areaName" class="form-control" placeholder="e.g. Mylavaram" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">PIN Code</label>
                        <input type="text" name="pincode" class="form-control" placeholder="e.g. 521230" required>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-accent btn-sm">Add Area</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Assign Restaurant to Area -->
<div class="modal fade" id="assignAreaModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-link me-2 text-warning"></i>Map Restaurant to Area</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/superadmin/areas" method="POST">
                <input type="hidden" name="action" value="assign-area">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Select Restaurant</label>
                        <select name="restaurantId" class="form-select" required>
                            <c:forEach var="r" items="${restaurants}">
                                <option value="${r.restaurantId}">${r.name} (${r.primaryArea})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Select Target Service Area</label>
                        <select name="areaId" class="form-select" required>
                            <c:forEach var="a" items="${areas}">
                                <option value="${a.areaId}">${a.areaName} (${a.pincode})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="row g-2">
                        <div class="col-6">
                            <label class="form-label small fw-semibold text-secondary">Delivery Fee (INR)</label>
                            <input type="number" step="5" name="deliveryCharge" class="form-control" value="40.00" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold text-secondary">Estimated Time</label>
                            <input type="text" name="estimatedTime" class="form-control" value="30-45 mins" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-accent btn-sm">Save Mapping</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

