<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Checkout - Smart Restaurant" />
<c:set var="activePage" value="checkout" />
<jsp:include page="common/header.jsp" />

<main class="py-5">
    <div class="container">
        <h2 class="fw-bold mb-4" style="color: var(--primary-dark);">
            <i class="bi bi-shield-check me-2 text-success"></i>Complete Your Order
        </h2>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3" role="alert">
                <i class="bi bi-exclamation-octagon-fill me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/place-order" method="POST">
            <div class="row g-4">
                <!-- Left: Customer Details & Order Type Form -->
                <div class="col-lg-8">
                    <!-- 1. Order Type Selection -->
                    <div class="card border-0 rounded-4 shadow-sm mb-4">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="fw-bold mb-0 text-dark">
                                <span class="badge bg-dark rounded-circle me-2">1</span>Select Order Type
                            </h5>
                        </div>
                        <div class="card-body p-4">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="form-check p-3 border rounded-3 h-100 ${cart.orderType != 'DINE_IN' ? 'border-success bg-success-subtle bg-opacity-25' : ''}">
                                        <input class="form-check-input" type="radio" name="orderType" id="typeDelivery" 
                                               value="HOME_DELIVERY" ${cart.orderType != 'DINE_IN' ? 'checked' : ''}
                                               onchange="window.location.href='${pageContext.request.contextPath}/checkout?type=HOME_DELIVERY';">
                                        <label class="form-check-label w-100 cursor-pointer" for="typeDelivery">
                                            <div class="fw-bold text-dark"><i class="bi bi-bicycle me-1 text-success"></i> Home Delivery</div>
                                            <div class="small text-muted">Delivered to your doorstep in ${selectedArea} (Delivery Fee: Rs. ${cart.deliveryCharge})</div>
                                        </label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-check p-3 border rounded-3 h-100 ${cart.orderType == 'DINE_IN' ? 'border-success bg-success-subtle bg-opacity-25' : ''}">
                                        <input class="form-check-input" type="radio" name="orderType" id="typeDineIn" 
                                               value="DINE_IN" ${cart.orderType == 'DINE_IN' ? 'checked' : ''}
                                               onchange="window.location.href='${pageContext.request.contextPath}/checkout?type=DINE_IN';">
                                        <label class="form-check-label w-100 cursor-pointer" for="typeDineIn">
                                            <div class="fw-bold text-dark"><i class="bi bi-door-open me-1 text-primary"></i> Dine-In Order</div>
                                            <div class="small text-muted">Enjoy your meal at ${cart.restaurantName} (No delivery charges)</div>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 2. Customer & Address Information -->
                    <div class="card border-0 rounded-4 shadow-sm mb-4">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="fw-bold mb-0 text-dark">
                                <span class="badge bg-dark rounded-circle me-2">2</span>Customer Information
                            </h5>
                        </div>
                        <div class="card-body p-4">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold text-secondary">Customer Full Name <span class="text-danger">*</span></label>
                                    <input type="text" name="customerName" class="form-control" 
                                           placeholder="e.g. Bhavani" value="${customerName}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold text-secondary">Mobile Number (For Order Tracking) <span class="text-danger">*</span></label>
                                    <input type="tel" name="customerMobile" class="form-control" 
                                           placeholder="e.g. 9876543210" pattern="[0-9]{10}" maxlength="10" required>
                                    <div class="form-text small">Your mobile number is needed to track your live order status.</div>
                                </div>
                            </div>

                            <!-- Home Delivery Address Fields (Shown only when HOME_DELIVERY is chosen) -->
                            <c:if test="${cart.orderType != 'DINE_IN'}">
                                <hr class="my-4">
                                <h6 class="fw-bold text-dark mb-3"><i class="bi bi-geo-alt me-1 text-danger"></i> Delivery Address</h6>
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold text-secondary">House / Flat No. <span class="text-danger">*</span></label>
                                        <input type="text" name="houseNo" class="form-control" placeholder="e.g. Plot 42, Apt 3B" required>
                                    </div>
                                    <div class="col-md-8">
                                        <label class="form-label small fw-semibold text-secondary">Street / Colony Name <span class="text-danger">*</span></label>
                                        <input type="text" name="street" class="form-control" placeholder="e.g. Temple Road, Gandhinagar" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-secondary">Landmark (Optional)</label>
                                        <input type="text" name="landmark" class="form-control" placeholder="e.g. Opposite Post Office">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-secondary">Area / City</label>
                                        <input type="text" name="customerArea" class="form-control bg-light" value="${customerArea}" readonly>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label small fw-semibold text-secondary">Delivery Instructions (Optional)</label>
                                        <input type="text" name="instructions" class="form-control" placeholder="e.g. Ring the bell, leave at security">
                                    </div>
                                </div>
                            </c:if>

                            <!-- Dine-In Table Selection (Shown only when DINE_IN is chosen) -->
                            <c:if test="${cart.orderType == 'DINE_IN'}">
                                <hr class="my-4">
                                <h6 class="fw-bold text-dark mb-3"><i class="bi bi-door-open me-1 text-primary"></i> Dine-In Seating Details</h6>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-secondary">Select Table</label>
                                        <select name="tableNumber" class="form-select">
                                            <c:forEach var="tbl" items="${tables}">
                                                <option value="${tbl.tableNumber}">${tbl.tableNumber} (Capacity: ${tbl.capacity} guests)</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-secondary">Chef & Seating Instructions</label>
                                        <input type="text" name="specialNotes" class="form-control" placeholder="e.g. Arriving at 8:00 PM, extra spicy">
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- 3. Strict Payment Method: CASH ON DELIVERY ONLY -->
                    <div class="card border-0 rounded-4 shadow-sm mb-4">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="fw-bold mb-0 text-dark">
                                <span class="badge bg-dark rounded-circle me-2">3</span>Payment Method
                            </h5>
                        </div>
                        <div class="card-body p-4">
                            <div class="p-3 border rounded-3 border-success bg-success-subtle bg-opacity-25 d-flex align-items-center gap-3">
                                <div class="rounded-circle p-3 bg-success text-white fs-4">
                                    <i class="bi bi-cash-stack"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="fw-bold fs-6 text-dark">CASH ON DELIVERY (COD)</div>
                                    <div class="small text-secondary">
                                        <c:choose>
                                            <c:when test="${cart.orderType == 'DINE_IN'}">
                                                Please pay in cash to the restaurant counter/waiter after dining.
                                            </c:when>
                                            <c:otherwise>
                                                Please pay in cash directly to our delivery personnel upon arrival.
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <span class="badge bg-success px-3 py-2">Selected</span>
                            </div>

                            <div class="mt-3 text-muted small">
                                <i class="bi bi-info-circle me-1 text-secondary"></i>
                                Online payment gateways, cards, and UPI integrations are intentionally omitted per platform policy. Strictly Cash on Delivery.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Summary & Confirmation -->
                <div class="col-lg-4">
                    <div class="card border-0 rounded-4 shadow-sm p-4 sticky-top" style="top: 100px;">
                        <h5 class="fw-bold mb-3 text-dark">Final Bill Breakdown</h5>

                        <div class="mb-3">
                            <div class="small text-muted">Restaurant:</div>
                            <div class="fw-bold text-dark">${cart.restaurantName}</div>
                        </div>

                        <!-- Item list preview -->
                        <div class="list-group list-group-flush mb-3 small">
                            <c:forEach var="it" items="${cart.items}">
                                <div class="list-group-item px-0 d-flex justify-content-between align-items-center bg-transparent">
                                    <div>
                                        <span class="fw-semibold">${it.menuItem.name}</span>
                                        <span class="text-muted">x ${it.quantity}</span>
                                    </div>
                                    <span class="fw-semibold">Rs. ${it.subtotal}</span>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="d-flex justify-content-between py-2 border-top small text-secondary">
                            <span>Item Subtotal:</span>
                            <span class="fw-bold text-dark">Rs. ${cart.subtotal}</span>
                        </div>
                        <div class="d-flex justify-content-between py-2 border-top small text-secondary">
                            <span>GST (5%):</span>
                            <span class="fw-bold text-dark">Rs. ${cart.gstAmount}</span>
                        </div>
                        <div class="d-flex justify-content-between py-2 border-top small text-secondary">
                            <span>Delivery Fee:</span>
                            <span class="fw-bold text-dark">Rs. ${cart.deliveryCharge}</span>
                        </div>
                        <div class="d-flex justify-content-between py-3 my-2 border-top border-bottom fs-5 fw-bold" style="color: var(--primary-dark);">
                            <span>Total Payable (COD):</span>
                            <span style="color: var(--accent-orange);">Rs. ${cart.grandTotal}</span>
                        </div>

                        <button type="submit" class="btn btn-accent w-100 py-3 fw-bold fs-6">
                            <i class="bi bi-check2-circle me-1"></i> Place COD Order
                        </button>

                        <div class="text-center mt-3 text-muted small">
                            A digital invoice will be generated immediately after your order is confirmed.
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</main>

<jsp:include page="common/footer.jsp" />

