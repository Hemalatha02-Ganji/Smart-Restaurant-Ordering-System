<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Restaurants - Super Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<c:set var="superPage" value="restaurants" />
<jsp:include page="common/superadmin-nav.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1 text-dark">Partner Restaurants Registry</h3>
            <p class="text-secondary small mb-0">Onboard new dining kitchens, edit metadata, or toggle live network activity.</p>
        </div>
        <button type="button" class="btn btn-accent" data-bs-toggle="modal" data-bs-target="#addRestaurantModal">
            <i class="bi bi-plus-circle me-1"></i> Register New Restaurant
        </button>
    </div>

    <c:if test="${param.created == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-check-circle me-1"></i> New restaurant registered successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.updated == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-check-circle me-1"></i> Restaurant details updated!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.toggled == 'true'}">
        <div class="alert alert-info alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-toggle-on me-1"></i> Restaurant operational status changed.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Restaurants Table Card -->
    <div class="card border-0 rounded-4 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="bg-light small text-secondary">
                        <tr>
                            <th class="ps-3">Restaurant Details</th>
                            <th>Cuisine</th>
                            <th>Primary Area</th>
                            <th>Operating Hours</th>
                            <th>Contact</th>
                            <th>Rating</th>
                            <th>Status</th>
                            <th class="pe-3 text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${restaurants}">
                            <tr>
                                <td class="ps-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="${r.imageUrl}" alt="${r.name}" class="rounded-3 shadow-sm"
                                             style="width: 50px; height: 50px; object-fit: cover;">
                                        <div>
                                            <div class="fw-bold text-dark">${r.name}</div>
                                            <div class="text-muted small text-truncate" style="max-width: 200px;" title="${r.address}">
                                                ${r.address}
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-light text-dark border">${r.cuisine}</span></td>
                                <td><strong>${r.primaryArea}</strong></td>
                                <td class="small text-secondary">${r.openingHours}</td>
                                <td class="small">${r.contactNumber}</td>
                                <td><i class="bi bi-star-fill text-warning me-1"></i>${r.rating}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/superadmin/restaurants" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="toggle-restaurant">
                                        <input type="hidden" name="restaurantId" value="${r.restaurantId}">
                                        <input type="hidden" name="isActive" value="${!r.active}">
                                        <button type="submit" class="btn btn-sm ${r.active ? 'btn-outline-success' : 'btn-outline-danger'}" title="Click to toggle status">
                                            ${r.active ? 'Active' : 'Deactivated'}
                                        </button>
                                    </form>
                                </td>
                                <td class="pe-3 text-end">
                                    <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editRestaurantModal-${r.restaurantId}">
                                        <i class="bi bi-pencil-square"></i> Edit
                                    </button>
                                    <a href="${pageContext.request.contextPath}/menu?id=${r.restaurantId}" target="_blank" class="btn btn-sm btn-outline-dark" title="View Storefront">
                                        <i class="bi bi-box-arrow-up-right"></i>
                                    </a>
                                </td>
                            </tr>

                            <!-- Edit Modal for Restaurant -->
                            <div class="modal fade" id="editRestaurantModal-${r.restaurantId}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered modal-lg">
                                    <div class="modal-content border-0 rounded-4 shadow">
                                        <div class="modal-header bg-dark text-white">
                                            <h5 class="modal-title fw-bold">Edit Restaurant: ${r.name}</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/superadmin/restaurants" method="POST">
                                            <input type="hidden" name="action" value="edit-restaurant">
                                            <input type="hidden" name="restaurantId" value="${r.restaurantId}">
                                            <div class="modal-body p-4">
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <label class="form-label small fw-semibold text-secondary">Restaurant Name</label>
                                                        <input type="text" name="name" class="form-control" value="${r.name}" required>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="form-label small fw-semibold text-secondary">Cuisine Type</label>
                                                        <input type="text" name="cuisine" class="form-control" value="${r.cuisine}" required>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label class="form-label small fw-semibold text-secondary">Primary Area</label>
                                                        <select name="primaryArea" class="form-select" required>
                                                            <c:forEach var="a" items="${areas}">
                                                                <option value="${a.areaName}" ${r.primaryArea == a.areaName ? 'selected' : ''}>${a.areaName}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label class="form-label small fw-semibold text-secondary">Rating</label>
                                                        <input type="number" step="0.1" name="rating" class="form-control" value="${r.rating}" min="1" max="5" required>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label class="form-label small fw-semibold text-secondary">Status</label>
                                                        <select name="isActive" class="form-select">
                                                            <option value="true" ${r.active ? 'selected' : ''}>Active</option>
                                                            <option value="false" ${!r.active ? 'selected' : ''}>Deactivated</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="form-label small fw-semibold text-secondary">Opening Hours</label>
                                                        <input type="text" name="openingHours" class="form-control" value="${r.openingHours}" required>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="form-label small fw-semibold text-secondary">Contact Phone</label>
                                                        <input type="text" name="contactNumber" class="form-control" value="${r.contactNumber}" required>
                                                    </div>
                                                    <div class="col-12">
                                                        <label class="form-label small fw-semibold text-secondary">Full Street Address</label>
                                                        <input type="text" name="address" class="form-control" value="${r.address}" required>
                                                    </div>
                                                    <div class="col-12">
                                                        <label class="form-label small fw-semibold text-secondary">Banner Image URL</label>
                                                        <input type="url" name="imageUrl" class="form-control" value="${r.imageUrl}" required>
                                                    </div>
                                                    <div class="col-12">
                                                        <label class="form-label small fw-semibold text-secondary">Description</label>
                                                        <textarea name="description" class="form-control" rows="2">${r.description}</textarea>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer bg-light">
                                                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-accent btn-sm">Save Changes</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Register New Restaurant -->
<div class="modal fade" id="addRestaurantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle me-2 text-warning"></i>Register New Restaurant</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/superadmin/restaurants" method="POST">
                <input type="hidden" name="action" value="add-restaurant">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-secondary">Restaurant Name <span class="text-danger">*</span></label>
                            <input type="text" name="name" class="form-control" placeholder="e.g. Royal Sweets & Chaat" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-secondary">Cuisine Type <span class="text-danger">*</span></label>
                            <input type="text" name="cuisine" class="form-control" placeholder="e.g. Sweets, Chaat & Snacks" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-secondary">Primary Area <span class="text-danger">*</span></label>
                            <select name="primaryArea" class="form-select" required>
                                <c:forEach var="a" items="${areas}">
                                    <option value="${a.areaName}">${a.areaName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-secondary">Initial Rating</label>
                            <input type="number" step="0.1" name="rating" class="form-control" value="4.5" min="1" max="5" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-secondary">Opening Hours</label>
                            <input type="text" name="openingHours" class="form-control" value="10:00 AM - 10:30 PM" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-secondary">Contact Phone</label>
                            <input type="text" name="contactNumber" class="form-control" placeholder="+91 98765 00000" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-secondary">Banner Image URL</label>
                            <input type="url" name="imageUrl" class="form-control" 
                                   value="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=80" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold text-secondary">Full Street Address</label>
                            <input type="text" name="address" class="form-control" placeholder="Building, Street, Landmark" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold text-secondary">Description</label>
                            <textarea name="description" class="form-control" rows="2" placeholder="Describe the restaurant specialty and ambiance"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-accent btn-sm">Onboard Restaurant</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

