<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Administrators - Super Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<c:set var="superPage" value="admins" />
<jsp:include page="common/superadmin-nav.jsp" />

<div class="container-fluid px-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1 text-dark">Staff & Administrator Assignments</h3>
            <p class="text-secondary small mb-0">Create restaurant manager logins, manage credentials with BCrypt encryption, and assign ownership.</p>
        </div>
        <button type="button" class="btn btn-accent" data-bs-toggle="modal" data-bs-target="#addAdminModal">
            <i class="bi bi-person-plus-fill me-1"></i> Add Administrator / Manager
        </button>
    </div>

    <c:if test="${param.created == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-check-circle me-1"></i> Admin account created!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.updated == 'true'}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-check-circle me-1"></i> Admin account updated!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.deleted == 'true'}">
        <div class="alert alert-warning alert-dismissible fade show rounded-3 py-2" role="alert">
            <i class="bi bi-trash3 me-1"></i> Admin account deleted.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Admins Table Card -->
    <div class="card border-0 rounded-4 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="bg-light small text-secondary">
                        <tr>
                            <th class="ps-3">Full Name & Username</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Assigned Restaurant</th>
                            <th class="pe-3 text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="adm" items="${admins}">
                            <tr>
                                <td class="ps-3">
                                    <div class="fw-bold text-dark">${adm.fullName}</div>
                                    <div class="text-muted small"><code>${adm.username}</code></div>
                                </td>
                                <td>${adm.email}</td>
                                <td>
                                    <span class="badge ${adm.superAdmin ? 'bg-danger' : 'bg-primary-subtle text-primary'}">
                                        ${adm.role}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty adm.restaurantName}">
                                            <span class="fw-semibold text-dark"><i class="bi bi-shop me-1 text-warning"></i>${adm.restaurantName}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-light text-muted border">Platform Wide (All)</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="pe-3 text-end">
                                    <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editAdminModal-${adm.adminId}">
                                        <i class="bi bi-pencil-square"></i> Edit
                                    </button>
                                    <c:if test="${!adm.superAdmin}">
                                        <form action="${pageContext.request.contextPath}/superadmin/admins" method="POST" class="d-inline"
                                              onsubmit="return confirm('Delete admin ${adm.username}?');">
                                            <input type="hidden" name="action" value="delete-admin">
                                            <input type="hidden" name="adminId" value="${adm.adminId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>

                            <!-- Edit Modal -->
                            <div class="modal fade" id="editAdminModal-${adm.adminId}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content border-0 rounded-4 shadow">
                                        <div class="modal-header bg-dark text-white">
                                            <h5 class="modal-title fw-bold">Edit Account: ${adm.username}</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/superadmin/admins" method="POST">
                                            <input type="hidden" name="action" value="edit-admin">
                                            <input type="hidden" name="adminId" value="${adm.adminId}">
                                            <div class="modal-body p-4">
                                                <div class="mb-3">
                                                    <label class="form-label small fw-semibold text-secondary">Full Name</label>
                                                    <input type="text" name="fullName" class="form-control" value="${adm.fullName}" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label small fw-semibold text-secondary">Email</label>
                                                    <input type="email" name="email" class="form-control" value="${adm.email}" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label small fw-semibold text-secondary">Change Password (Leave blank to keep existing)</label>
                                                    <input type="password" name="password" class="form-control" placeholder="New Password">
                                                </div>
                                                <c:if test="${!adm.superAdmin}">
                                                    <div class="mb-3">
                                                        <label class="form-label small fw-semibold text-secondary">Assigned Restaurant</label>
                                                        <select name="restaurantId" class="form-select">
                                                            <option value="NONE">None</option>
                                                            <c:forEach var="rest" items="${restaurants}">
                                                                <option value="${rest.restaurantId}" ${adm.restaurantId == rest.restaurantId ? 'selected' : ''}>
                                                                    ${rest.name} (${rest.primaryArea})
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </c:if>
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

<!-- Modal: Add New Admin -->
<div class="modal fade" id="addAdminModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-person-plus-fill me-2 text-warning"></i>Create Administrator</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/superadmin/admins" method="POST">
                <input type="hidden" name="action" value="add-admin">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Username <span class="text-danger">*</span></label>
                        <input type="text" name="username" class="form-control" placeholder="e.g. admin_spice" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Password <span class="text-danger">*</span></label>
                        <input type="password" name="password" class="form-control" placeholder="Enter password (e.g. admin123)" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Full Name <span class="text-danger">*</span></label>
                        <input type="text" name="fullName" class="form-control" placeholder="e.g. Manager Name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Email <span class="text-danger">*</span></label>
                        <input type="email" name="email" class="form-control" placeholder="e.g. manager@smartrestaurant.com" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Account Role <span class="text-danger">*</span></label>
                        <select name="role" class="form-select" required>
                            <option value="RESTAURANT_ADMIN" selected>Restaurant Administrator</option>
                            <option value="SUPER_ADMIN">Platform Super Administrator</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Assign to Restaurant</label>
                        <select name="restaurantId" class="form-select">
                            <option value="NONE">None (Super Admin)</option>
                            <c:forEach var="rest" items="${restaurants}">
                                <option value="${rest.restaurantId}">${rest.name} (${rest.primaryArea})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-accent btn-sm">Create Account</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

