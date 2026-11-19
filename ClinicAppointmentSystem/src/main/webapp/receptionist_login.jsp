<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Receptionist Portal - CityCare Clinic" />
<%@ include file="common/header.jsp" %>
<%@ include file="common/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <div class="auth-container">
            <div class="card clinic-card shadow border-0 overflow-hidden">
                <div class="auth-header bg-dark text-white text-center py-4" 
                     style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);">
                    <i class="bi bi-shield-lock-fill fs-1 text-warning mb-2 d-inline-block"></i>
                    <h3 class="fw-bold mb-1">Receptionist Desk</h3>
                    <p class="small text-white-50 mb-0">Authorized Clinic Staff Administration Portal</p>
                </div>

                <div class="card-body p-4">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty param.msg and param.msg eq 'unauthorized'}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            <i class="bi bi-shield-exclamation me-2"></i> Access restricted. Receptionist authorization required.
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/receptionistLogin" method="post">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Staff Username <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-person-badge text-primary"></i></span>
                                <input type="text" name="username" class="form-control form-control-lg" 
                                       value="${prevUser != null ? prevUser : 'receptionist'}" placeholder="e.g. receptionist" required autofocus>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Staff Password <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-key text-primary"></i></span>
                                <input type="password" name="password" class="form-control form-control-lg" placeholder="Enter password" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-warning text-dark btn-lg w-100 fw-bold mt-2">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Access Front Desk Console
                        </button>
                    </form>

                    <div class="bg-light p-3 rounded mt-4 small border">
                        <strong class="text-dark"><i class="bi bi-key-fill text-warning me-1"></i>Default Staff Credentials:</strong>
                        <ul class="mb-0 mt-1 ps-3 text-muted">
                            <li>Username: <code>receptionist</code> | Password: <code>admin123</code></li>
                            <li>Username: <code>hema_reception</code> | Password: <code>admin123</code></li>
                        </ul>
                    </div>

                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/index.jsp" class="text-muted small text-decoration-none">
                            &larr; Return to Patient Portal
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="common/footer.jsp" %>
