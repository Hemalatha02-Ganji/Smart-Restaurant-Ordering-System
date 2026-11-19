<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Track Order - Smart Restaurant" />
<c:set var="activePage" value="tracking" />
<jsp:include page="common/header.jsp" />

<main class="py-5">
    <div class="container">
        <!-- Search Card -->
        <div class="card border-0 rounded-4 shadow-sm mb-4">
            <div class="card-body p-4">
                <div class="row align-items-center g-3">
                    <div class="col-lg-5">
                        <h4 class="fw-bold mb-1" style="color: var(--primary-dark);">Live Order Tracking</h4>
                        <p class="text-muted small mb-0">Enter your unique Order ID and registered Mobile Number to track status.</p>
                    </div>
                    <div class="col-lg-7">
                        <form action="${pageContext.request.contextPath}/track-order" method="GET" class="row g-2">
                            <div class="col-sm-5">
                                <input type="text" name="orderCode" class="form-control" 
                                       placeholder="Order ID (e.g. ORD-20261028-1001)" value="${order != null ? order.orderCode : searchedCode}" required>
                            </div>
                            <div class="col-sm-4">
                                <input type="tel" name="mobile" class="form-control" 
                                       placeholder="10-digit Mobile No." pattern="[0-9]{10}" maxlength="10" 
                                       value="${order != null ? order.customerMobile : searchedMobile}" required>
                            </div>
                            <div class="col-sm-3 d-grid">
                                <button type="submit" class="btn btn-primary-custom">
                                    <i class="bi bi-search me-1"></i> Track
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tracking Results -->
        <c:choose>
            <c:when test="${not empty order}">
                <div class="card border-0 rounded-4 shadow-sm mb-4">
                    <div class="card-header bg-white border-bottom py-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
                        <div>
                            <span class="text-muted small">Tracking Order:</span>
                            <h5 class="fw-bold mb-0 text-dark">${order.orderCode}</h5>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge bg-light text-dark border"><i class="bi bi-shop me-1"></i>${order.restaurantName}</span>
                            <span class="badge bg-primary-subtle text-primary">${order.orderType}</span>
                            <span class="badge ${order.orderStatus == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark'} fw-bold px-3 py-2">
                                Status: ${order.orderStatus}
                            </span>
                        </div>
                    </div>

                    <div class="card-body p-4">
                        <!-- Graphical Stepper -->
                        <c:choose>
                            <c:when test="${order.orderStatus == 'CANCELLED'}">
                                <div class="alert alert-danger text-center p-4 rounded-3 my-3">
                                    <i class="bi bi-x-octagon-fill display-4 d-block mb-2 text-danger"></i>
                                    <h4 class="fw-bold">This Order Has Been Cancelled</h4>
                                    <p class="mb-0 small text-muted">Please contact the restaurant if you have any questions regarding cancellation.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Stepper for Delivery and Dine-In -->
                                <div class="tracking-stepper">
                                    <!-- Step 1: PLACED -->
                                    <div class="step-item ${order.orderStatus == 'PLACED' ? 'active' : 'completed'}">
                                        <div class="step-icon"><i class="bi bi-clipboard-check"></i></div>
                                        <div class="step-label">Order Placed</div>
                                    </div>

                                    <!-- Step 2: ACCEPTED -->
                                    <div class="step-item ${order.orderStatus == 'ACCEPTED' ? 'active' : (order.orderStatus == 'PREPARING' || order.orderStatus == 'READY' || order.orderStatus == 'OUT_FOR_DELIVERY' || order.orderStatus == 'DELIVERED' || order.orderStatus == 'COMPLETED' ? 'completed' : '')}">
                                        <div class="step-icon"><i class="bi bi-check-circle"></i></div>
                                        <div class="step-label">Accepted</div>
                                    </div>

                                    <!-- Step 3: PREPARING -->
                                    <div class="step-item ${order.orderStatus == 'PREPARING' ? 'active' : (order.orderStatus == 'READY' || order.orderStatus == 'OUT_FOR_DELIVERY' || order.orderStatus == 'DELIVERED' || order.orderStatus == 'COMPLETED' ? 'completed' : '')}">
                                        <div class="step-icon"><i class="bi bi-fire"></i></div>
                                        <div class="step-label">Kitchen Preparing</div>
                                    </div>

                                    <!-- Step 4: READY -->
                                    <div class="step-item ${order.orderStatus == 'READY' ? 'active' : (order.orderStatus == 'OUT_FOR_DELIVERY' || order.orderStatus == 'DELIVERED' || order.orderStatus == 'COMPLETED' ? 'completed' : '')}">
                                        <div class="step-icon"><i class="bi bi-box-seam"></i></div>
                                        <div class="step-label">Food Ready</div>
                                    </div>

                                    <!-- Step 5: OUT_FOR_DELIVERY or SERVED -->
                                    <c:choose>
                                        <c:when test="${order.orderType == 'HOME_DELIVERY'}">
                                            <div class="step-item ${order.orderStatus == 'OUT_FOR_DELIVERY' ? 'active' : (order.orderStatus == 'DELIVERED' ? 'completed' : '')}">
                                                <div class="step-icon"><i class="bi bi-bicycle"></i></div>
                                                <div class="step-label">Out for Delivery</div>
                                            </div>
                                            <div class="step-item ${order.orderStatus == 'DELIVERED' ? 'completed active' : ''}">
                                                <div class="step-icon"><i class="bi bi-house-door-fill"></i></div>
                                                <div class="step-label">Delivered</div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="step-item ${order.orderStatus == 'COMPLETED' ? 'completed active' : ''}">
                                                <div class="step-icon"><i class="bi bi-cup-hot-fill"></i></div>
                                                <div class="step-label">Completed / Served</div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <hr class="my-4">

                        <!-- Order Item Details -->
                        <div class="row g-4">
                            <div class="col-md-7">
                                <h6 class="fw-bold text-dark mb-3">Items in this Order</h6>
                                <div class="table-responsive">
                                    <table class="table table-sm align-middle">
                                        <thead class="bg-light small">
                                            <tr>
                                                <th>Item Name</th>
                                                <th>Unit Price</th>
                                                <th>Qty</th>
                                                <th class="text-end">Subtotal</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="it" items="${order.items}">
                                                <tr>
                                                    <td class="fw-semibold text-dark">${it.itemName}</td>
                                                    <td>Rs. ${it.unitPrice}</td>
                                                    <td>${it.quantity}</td>
                                                    <td class="text-end fw-bold">Rs. ${it.subtotal}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="col-md-5">
                                <div class="p-3 bg-light rounded-3 border">
                                    <h6 class="fw-bold text-dark mb-3">Order & Payment Info</h6>
                                    <div class="d-flex justify-content-between small text-secondary mb-1">
                                        <span>Customer Name:</span>
                                        <span class="fw-semibold text-dark">${order.customerName}</span>
                                    </div>
                                    <div class="d-flex justify-content-between small text-secondary mb-1">
                                        <span>Phone Number:</span>
                                        <span class="fw-semibold text-dark">${order.customerMobile}</span>
                                    </div>
                                    <div class="d-flex justify-content-between small text-secondary mb-1">
                                        <span>Payment Mode:</span>
                                        <span class="badge bg-dark">CASH ON DELIVERY</span>
                                    </div>
                                    <div class="d-flex justify-content-between small text-secondary mb-2">
                                        <span>Payment Status:</span>
                                        <span class="badge ${order.payment.paid ? 'bg-success' : 'bg-warning text-dark'}">
                                            ${order.payment.paymentStatus}
                                        </span>
                                    </div>

                                    <hr class="my-2">
                                    <div class="d-flex justify-content-between small text-secondary mb-1">
                                        <span>Subtotal:</span>
                                        <span>Rs. ${order.subtotal}</span>
                                    </div>
                                    <div class="d-flex justify-content-between small text-secondary mb-1">
                                        <span>GST (5%):</span>
                                        <span>Rs. ${order.gstAmount}</span>
                                    </div>
                                    <div class="d-flex justify-content-between small text-secondary mb-2">
                                        <span>Delivery Fee:</span>
                                        <span>Rs. ${order.deliveryCharge}</span>
                                    </div>
                                    <div class="d-flex justify-content-between fw-bold text-dark fs-6 pt-2 border-top">
                                        <span>Grand Total (COD):</span>
                                        <span class="text-danger">Rs. ${order.grandTotal}</span>
                                    </div>
                                </div>

                                <div class="d-flex gap-2 mt-3">
                                    <a href="${pageContext.request.contextPath}/invoice?code=${order.orderCode}" class="btn btn-outline-dark btn-sm flex-grow-1">
                                        <i class="bi bi-receipt me-1"></i> View Invoice
                                    </a>
                                    <a href="${pageContext.request.contextPath}/invoice/pdf?code=${order.orderCode}" class="btn btn-outline-danger btn-sm">
                                        <i class="bi bi-file-pdf"></i> PDF
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:when test="${notFound}">
                <div class="p-5 text-center bg-white rounded-4 border shadow-sm my-4">
                    <i class="bi bi-search text-danger display-4 mb-3 d-block"></i>
                    <h5 class="fw-bold text-dark">Order Not Found</h5>
                    <p class="text-muted col-md-6 mx-auto mb-3">
                        We could not find an order matching Order ID <strong>${searchedCode}</strong> and Mobile Number <strong>${searchedMobile}</strong>.
                        Please verify the tracking credentials and try again.
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Initial Helper State -->
                <div class="p-5 text-center bg-white rounded-4 border shadow-sm my-4">
                    <i class="bi bi-radar text-warning display-3 mb-3 d-block"></i>
                    <h5 class="fw-bold text-dark">Ready to Track Your Meal</h5>
                    <p class="text-muted col-md-6 mx-auto">
                        Enter your Order ID (provided on your invoice) and the 10-digit mobile number used during order placement to view real-time status updates from the kitchen.
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="common/footer.jsp" />
