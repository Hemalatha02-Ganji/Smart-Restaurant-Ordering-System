<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu Management - ${restaurant.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<c:set var="adminPage" value="menu" />
<jsp:include page="common/admin-nav.jsp" />

<div class="container-fluid px-4 py-4">
    <!-- Header with Add Button -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1 text-dark">Menu Management</h3>
            <p class="text-secondary small mb-0">Add new culinary items, adjust prices, edit descriptions, and toggle stock availability.</p>
        </div>
        <button type="button" class="btn btn-accent" data-bs-toggle="modal" data-bs-target="#addMenuItemModal">
            <i class="bi bi-plus-circle me-1"></i> Add New Food Item
        </button>
    </div>

    <c:if test="${param.created == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-check-circle me-1"></i> New menu item added successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.updated == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-check-circle me-1"></i> Menu item updated successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.toggled == 'true'}">
        <div class="alert alert-info alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-toggle-on me-1"></i> Food item availability changed.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.deleted == 'true'}">
        <div class="alert alert-warning alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-trash3 me-1"></i> Item deleted from menu.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Menu Items Table Card -->
    <div class="card border-0 rounded-4 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="bg-light small text-secondary">
                        <tr>
                            <th class="ps-3">Item Details</th>
                            <th>Category</th>
                            <th>Type</th>
                            <th>Price</th>
                            <th>Availability Status</th>
                            <th class="pe-3 text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${menuItems}">
                            <tr>
                                <td class="ps-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="${item.imageUrl}" alt="${item.name}" class="rounded-3 shadow-sm"
                                             style="width: 50px; height: 50px; object-fit: cover;">
                                        <div>
                                            <div class="fw-bold text-dark">${item.name}</div>
                                            <div class="text-muted small text-truncate" style="max-width: 250px;" title="${item.description}">
                                                ${item.description}
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border">${item.categoryName}</span>
                                </td>
                                <td>
                                    <span class="badge ${item.veg ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'}">
                                        ${item.foodType}
                                    </span>
                                </td>
                                <td class="fw-bold text-dark fs-6">Rs. ${item.price}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/menu" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="toggle-availability">
                                        <input type="hidden" name="itemId" value="${item.itemId}">
                                        <input type="hidden" name="isAvailable" value="${!item.available}">
                                        <button type="submit" class="btn btn-sm ${item.available ? 'btn-outline-success' : 'btn-outline-danger'}" 
                                                title="Click to toggle availability">
                                            <i class="bi ${item.available ? 'bi-check-circle-fill' : 'bi-x-circle-fill'} me-1"></i>
                                            ${item.available ? 'In Stock' : 'Out of Stock'}
                                        </button>
                                    </form>
                                </td>
                                <td class="pe-3 text-end">
                                    <button type="button" class="btn btn-sm btn-outline-primary me-1" 
                                            data-bs-toggle="modal" data-bs-target="#editModal-${item.itemId}">
                                        <i class="bi bi-pencil-square"></i>
                                    </button>
                                    <form action="${pageContext.request.contextPath}/admin/menu" method="POST" class="d-inline"
                                          onsubmit="return confirm('Are you sure you want to delete ${item.name}?');">
                                        <input type="hidden" name="action" value="delete-menu-item">
                                        <input type="hidden" name="itemId" value="${item.itemId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                            <i class="bi bi-trash3"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>

                            <!-- Edit Modal for this item -->
                            <div class="modal fade" id="editModal-${item.itemId}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content border-0 rounded-4 shadow">
                                        <div class="modal-header bg-dark text-white">
                                            <h5 class="modal-title fw-bold">Edit Item: ${item.name}</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/admin/menu" method="POST">
                                            <input type="hidden" name="action" value="edit-menu-item">
                                            <input type="hidden" name="itemId" value="${item.itemId}">
                                            <div class="modal-body p-4">
                                                <div class="mb-3">
                                                    <label class="form-label small fw-semibold text-secondary">Food Item Name</label>
                                                    <input type="text" name="name" class="form-control" value="${item.name}" required>
                                                </div>
                                                <div class="row g-2 mb-3">
                                                    <div class="col-6">
                                                        <label class="form-label small fw-semibold text-secondary">Category</label>
                                                        <select name="categoryId" class="form-select" required>
                                                            <c:forEach var="cat" items="${categories}">
                                                                <option value="${cat.categoryId}" ${item.categoryId == cat.categoryId ? 'selected' : ''}>
                                                                    ${cat.categoryName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="col-6">
                                                        <label class="form-label small fw-semibold text-secondary">Food Type</label>
                                                        <select name="foodType" class="form-select" required>
                                                            <option value="VEG" ${item.foodType == 'VEG' ? 'selected' : ''}>VEG</option>
                                                            <option value="NON_VEG" ${item.foodType == 'NON_VEG' ? 'selected' : ''}>NON_VEG</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="row g-2 mb-3">
                                                    <div class="col-6">
                                                        <label class="form-label small fw-semibold text-secondary">Price (INR)</label>
                                                        <input type="number" step="0.50" name="price" class="form-control" value="${item.price}" required>
                                                    </div>
                                                    <div class="col-6">
                                                        <label class="form-label small fw-semibold text-secondary">Availability</label>
                                                        <select name="isAvailable" class="form-select">
                                                            <option value="true" ${item.available ? 'selected' : ''}>In Stock</option>
                                                            <option value="false" ${!item.available ? 'selected' : ''}>Out of Stock</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label small fw-semibold text-secondary">Image URL</label>
                                                    <input type="url" name="imageUrl" class="form-control" value="${item.imageUrl}">
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label small fw-semibold text-secondary">Description</label>
                                                    <textarea name="description" class="form-control" rows="2">${item.description}</textarea>
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

<!-- Modal: Add New Menu Item -->
<div class="modal fade" id="addMenuItemModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle me-2 text-warning"></i>Add New Food Item</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/menu" method="POST">
                <input type="hidden" name="action" value="add-menu-item">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Item Name <span class="text-danger">*</span></label>
                        <input type="text" name="name" class="form-control" placeholder="e.g. Special Guntur Paneer" required>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold text-secondary">Category <span class="text-danger">*</span></label>
                            <select name="categoryId" class="form-select" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}">${cat.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold text-secondary">Food Type <span class="text-danger">*</span></label>
                            <select name="foodType" class="form-select" required>
                                <option value="VEG">VEG</option>
                                <option value="NON_VEG">NON_VEG</option>
                            </select>
                        </div>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold text-secondary">Price (INR) <span class="text-danger">*</span></label>
                            <input type="number" step="0.50" name="price" class="form-control" placeholder="250.00" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold text-secondary">Initial Stock</label>
                            <select name="isAvailable" class="form-select">
                                <option value="true">In Stock</option>
                                <option value="false">Out of Stock</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Image URL</label>
                        <input type="url" name="imageUrl" class="form-control" 
                               value="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Description</label>
                        <textarea name="description" class="form-control" rows="2" placeholder="Briefly describe the ingredients and taste"></textarea>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-accent btn-sm">Add Item to Menu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

