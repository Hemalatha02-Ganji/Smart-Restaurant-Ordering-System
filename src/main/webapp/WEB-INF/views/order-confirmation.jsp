<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Order Confirmed - Smart Restaurant" />
<jsp:include page="common/header.jsp" />

<main class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-7">
                <div class="card border-0 rounded-4 shadow-sm text-center p-4 p-md-5">
                    <!-- Success Icon -->
                    <div class="rounded-circle mx-auto mb-3 d-flex align-items-center justify-content-center" 
                         style="width: 80px; height: 80px; background-color: var(--primary-subtle); color: var(--primary-dark);">
                        <i class="bi bi-check-lg display-4"></i>
                    </div>

                    <h2 class="fw-bold mb-2" style="color: var(--primary-dark);">Order Placed Successfully!</h2>
                    
                    <!-- Strict COD Message -->
                    <div class="alert alert-warning border-0 rounded-3 my-3 py-3">
                        <i class="bi bi-cash-stack fs-4 me-2"></i>
                        <span class="fw-bold fs-6">
                            <c:choose>
                                <c:when test="${order.orderType == 'DINE_IN'}">
                                    Your dine-in order has been placed. Please pay in cash at the restaurant counter.
                                </c:when>
                                <c:otherwise>
                                    Your order has been placed successfully. Please pay in cash upon delivery.
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <!-- Order Details Summary Box -->
                    <div class="bg-light rounded-3 p-4 text-start mb-4 border">
                        <div class="row g-3">
                            <div class="col-6">
                                <div class="text-muted small">Order ID / Tracking ID:</div>
                                <div class="fw-bold text-dark fs-5">${order.orderCode}</div>
                            </div>
                            <div class="col-6 text-end">
                                <div class="text-muted small">Total Payable (COD):</div>
                                <div class="fw-bold text-success fs-5">Rs. ${order.grandTotal}</div>
                            </div>
                            <div class="col-6">
                                <div class="text-muted small">Restaurant:</div>
                                <div class="fw-semibold text-dark">${order.restaurantName}</div>
                            </div>
                            <div class="col-6 text-end">
                                <div class="text-muted small">Order Type:</div>
                                <span class="badge bg-primary-subtle text-primary">${order.orderType}</span>
                            </div>
                            <div class="col-6">
                                <div class="text-muted small">Customer Name:</div>
                                <div class="fw-semibold text-dark">${order.customerName}</div>
                            </div>
                            <div class="col-6 text-end">
                                <div class="text-muted small">Payment Status:</div>
                                <span class="badge bg-warning text-dark">PENDING (COD)</span>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex flex-column flex-sm-row justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/invoice?code=${order.orderCode}" class="btn btn-primary-custom px-4 py-2">
                            <i class="bi bi-receipt me-1"></i> View & Print Invoice
                        </a>
                        <a href="${pageContext.request.contextPath}/invoice/pdf?code=${order.orderCode}" class="btn btn-outline-dark px-4 py-2">
                            <i class="bi bi-file-earmark-pdf me-1"></i> Download PDF
                        </a>
                        <a href="${pageContext.request.contextPath}/track-order?orderCode=${order.orderCode}&mobile=${order.customerMobile}" class="btn btn-accent px-4 py-2">
                            <i class="bi bi-radar me-1"></i> Track Order Status
                        </a>
                    </div>

                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/home" class="text-muted small text-decoration-none">
                            <i class="bi bi-arrow-left me-1"></i> Return to Homepage
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp" />

