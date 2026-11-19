<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Notice - Smart Restaurant" />
<jsp:include page="common/header.jsp" />

<main class="py-5">
    <div class="container text-center">
        <div class="p-5 bg-white rounded-4 border shadow-sm my-4 col-lg-6 mx-auto">
            <div class="rounded-circle mx-auto mb-3 d-flex align-items-center justify-content-center" 
                 style="width: 70px; height: 70px; background-color: #fee2e2; color: #dc2626;">
                <i class="bi bi-exclamation-triangle fs-2"></i>
            </div>
            <h4 class="fw-bold text-dark">Oops! Something went wrong</h4>
            <p class="text-secondary small mb-4">
                We encountered an issue processing your request. Please check your input or return to the homepage to continue exploring delicious menus.
            </p>
            <div class="d-flex justify-content-center gap-2">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-accent px-4 py-2">
                    <i class="bi bi-house me-1"></i> Return Home
                </a>
                <a href="${pageContext.request.contextPath}/restaurants" class="btn btn-outline-secondary px-4 py-2">
                    View Restaurants
                </a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp" />

