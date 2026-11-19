<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Tables - ${restaurant.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<c:set var="adminPage" value="tables" />
<jsp:include page="common/admin-nav.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1 text-dark">Dining Table Seating Plan</h3>
            <p class="text-secondary small mb-0">Manage floor seating capacities, activate or deactivate dining tables.</p>
        </div>
        <button type="button" class="btn btn-accent" data-bs-toggle="modal" data-bs-target="#addTableModal">
            <i class="bi bi-plus-circle me-1"></i> Add New Table
        </button>
    </div>

    <c:if test="${param.created == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-check-circle me-1"></i> New dining table configured!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.updated == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-check-circle me-1"></i> Table details updated!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.deleted == 'true'}">
        <div class="alert alert-warning alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-trash3 me-1"></i> Table removed.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Table Grid -->
    <div class="row g-3">
        <c:forEach var="tbl" items="${tables}">
            <div class="col-sm-6 col-md-4 col-lg-3">
                <div class="card border-0 rounded-4 shadow-sm h-100 p-3 bg-white">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <div class="d-flex align-items-center gap-2">
                            <div class="rounded-circle p-2 bg-primary-subtle text-primary fs-5">
                                <i class="bi bi-grid-3x3"></i>
                            </div>
                            <div>
                                <h5 class="fw-bold mb-0 text-dark">${tbl.tableNumber}</h5>
                                <span class="badge ${tbl.active ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} small">
                                    ${tbl.active ? 'Active' : 'Inactive'}
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="my-3 py-2 bg-light rounded-3 text-center">
                        <div class="text-muted small">Seating Capacity</div>
                        <div class="fs-4 fw-bold text-dark"><i class="bi bi-people-fill text-warning me-1"></i>${tbl.capacity} Guests</div>
                    </div>

                    <div class="d-flex justify-content-end gap-1 mt-auto">
                        <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editTableModal-${tbl.tableId}">
                            <i class="bi bi-pencil-square"></i> Edit
                        </button>
                        <form action="${pageContext.request.contextPath}/admin/tables" method="POST" class="d-inline"
                              onsubmit="return confirm('Delete ${tbl.tableNumber}?');">
                            <input type="hidden" name="action" value="delete-table">
                            <input type="hidden" name="tableId" value="${tbl.tableId}">
                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                <i class="bi bi-trash3"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Edit Modal -->
            <div class="modal fade" id="editTableModal-${tbl.tableId}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content border-0 rounded-4 shadow">
                        <div class="modal-header bg-dark text-white">
                            <h5 class="modal-title fw-bold">Edit Table: ${tbl.tableNumber}</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin/tables" method="POST">
                            <input type="hidden" name="action" value="edit-table">
                            <input type="hidden" name="tableId" value="${tbl.tableId}">
                            <div class="modal-body p-4">
                                <div class="mb-3">
                                    <label class="form-label small fw-semibold text-secondary">Table Label</label>
                                    <input type="text" name="tableNumber" class="form-control" value="${tbl.tableNumber}" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small fw-semibold text-secondary">Seating Capacity (Guests)</label>
                                    <input type="number" name="capacity" class="form-control" value="${tbl.capacity}" min="1" max="30" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small fw-semibold text-secondary">Operational Status</label>
                                    <select name="isActive" class="form-select">
                                        <option value="true" ${tbl.active ? 'selected' : ''}>Active</option>
                                        <option value="false" ${!tbl.active ? 'selected' : ''}>Inactive</option>
                                    </select>
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
    </div>
</div>

<!-- Modal: Add New Table -->
<div class="modal fade" id="addTableModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle me-2 text-warning"></i>Add Table</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/tables" method="POST">
                <input type="hidden" name="action" value="add-table">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Table Name / Number <span class="text-danger">*</span></label>
                        <input type="text" name="tableNumber" class="form-control" placeholder="e.g. Table 6" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Guest Capacity <span class="text-danger">*</span></label>
                        <input type="number" name="capacity" class="form-control" placeholder="4" min="1" max="30" required>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-accent btn-sm">Create Table</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

