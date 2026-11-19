<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Your Cart - Smart Restaurant" />
<c:set var="activePage" value="cart" />
<jsp:include page="common/header.jsp" />

<main class="py-5">
    <div class="container">
        <h2 class="fw-bold mb-4" style="color: var(--primary-dark);">
            <i class="bi bi-cart3 me-2 text-warning"></i>Your Shopping Cart
        </h2>

        <c:choose>
            <c:when test="${not empty cart and not empty cart.items}">
                <div class="row g-4">
                    <!-- Left: Cart Items List -->
                    <div class="col-lg-8">
                        <div class="card border-0 rounded-4 shadow-sm mb-3">
                            <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="text-muted small">Ordering from:</span>
                                    <h5 class="fw-bold mb-0 text-dark">${cart.restaurantName}</h5>
                                </div>
                                <a href="${pageContext.request.contextPath}/cart?action=clear" class="btn btn-outline-danger btn-sm" onclick="return confirm('Are you sure you want to clear your cart?');">
                                    <i class="bi bi-trash3 me-1"></i> Clear Cart
                                </a>
                            </div>

                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table align-middle mb-0">
                                        <thead class="bg-light text-secondary small text-uppercase">
                                            <tr>
                                                <th class="ps-4">Item</th>
                                                <th>Price</th>
                                                <th>Quantity</th>
                                                <th>Subtotal</th>
                                                <th class="pe-4 text-end">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${cart.items}">
                                                <tr>
                                                    <td class="ps-4">
                                                        <div class="d-flex align-items-center gap-3">
                                                            <img src="${item.menuItem.imageUrl}" alt="${item.menuItem.name}" 
                                                                 class="rounded-3 shadow-sm" style="width: 50px; height: 50px; object-fit: cover;">
                                                            <div>
                                                                <div class="d-flex align-items-center gap-2">
                                                                    <span class="type-indicator ${item.menuItem.veg ? 'type-veg' : 'type-nonveg'}" style="width:12px; height:12px;"></span>
                                                                    <span class="fw-bold text-dark">${item.menuItem.name}</span>
                                                                </div>
                                                                <span class="text-muted small">${item.menuItem.categoryName}</span>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>Rs. ${item.menuItem.price}</td>
                                                    <td>
                                                        <form action="${pageContext.request.contextPath}/cart" method="POST" class="d-flex align-items-center gap-1">
                                                            <input type="hidden" name="action" value="update">
                                                            <input type="hidden" name="itemId" value="${item.menuItem.itemId}">
                                                            <div class="qty-control">
                                                                <button type="submit" name="quantity" value="${item.quantity - 1}" class="qty-btn">-</button>
                                                                <input type="text" class="qty-input" value="${item.quantity}" readonly>
                                                                <button type="submit" name="quantity" value="${item.quantity + 1}" class="qty-btn">+</button>
                                                            </div>
                                                        </form>
                                                    </td>
                                                    <td class="fw-bold text-dark">Rs. ${item.subtotal}</td>
                                                    <td class="pe-4 text-end">
                                                        <a href="${pageContext.request.contextPath}/cart?action=remove&itemId=${item.menuItem.itemId}" 
                                                           class="text-danger p-2" title="Remove item">
                                                            <i class="bi bi-x-circle fs-5"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Back to Menu button -->
                        <div class="d-flex justify-content-between align-items-center">
                            <a href="${pageContext.request.contextPath}/menu?id=${cart.restaurantId}" class="btn btn-outline-dark">
                                <i class="bi bi-arrow-left me-1"></i> Add More Items
                            </a>
                        </div>
                    </div>

                    <!-- Right: Order Summary & Bill Details -->
                    <div class="col-lg-4">
                        <div class="card border-0 rounded-4 shadow-sm p-4">
                            <h5 class="fw-bold mb-3 text-dark">Order Summary</h5>

                            <!-- Order Type Selector (Delivery vs Dine-In) -->
                            <form action="${pageContext.request.contextPath}/cart" method="POST" class="mb-3">
                                <input type="hidden" name="action" value="set-type">
                                <label class="form-label small fw-semibold text-secondary">Dining Preference</label>
                                <div class="btn-group w-100" role="group">
                                    <button type="submit" name="orderType" value="HOME_DELIVERY" 
                                            class="btn btn-sm ${cart.orderType != 'DINE_IN' ? 'btn-primary-custom' : 'btn-outline-secondary'}">
                                        <i class="bi bi-bicycle me-1"></i> Home Delivery
                                    </button>
                                    <button type="submit" name="orderType" value="DINE_IN" 
                                            class="btn btn-sm ${cart.orderType == 'DINE_IN' ? 'btn-primary-custom' : 'btn-outline-secondary'}">
                                        <i class="bi bi-door-open me-1"></i> Dine-In
                                    </button>
                                </div>
                            </form>

                            <!-- Cost Breakdown -->
                            <div class="d-flex justify-content-between py-2 border-bottom small text-secondary">
                                <span>Item Subtotal:</span>
                                <span class="fw-bold text-dark">Rs. ${cart.subtotal}</span>
                            </div>
                            <div class="d-flex justify-content-between py-2 border-bottom small text-secondary">
                                <span>Applicable GST (5%):</span>
                                <span class="fw-bold text-dark">Rs. ${cart.gstAmount}</span>
                            </div>
                            <div class="d-flex justify-content-between py-2 border-bottom small text-secondary">
                                <span>
                                    Delivery Charges:
                                    <c:if test="${cart.orderType == 'DINE_IN'}">
                                        <span class="badge bg-success-subtle text-success ms-1">Dine-In Free</span>
                                    </c:if>
                                </span>
                                <span class="fw-bold text-dark">Rs. ${cart.deliveryCharge}</span>
                            </div>
                            <div class="d-flex justify-content-between py-3 mb-3 border-bottom fs-5 fw-bold" style="color: var(--primary-dark);">
                                <span>Total Payable:</span>
                                <span style="color: var(--accent-orange);">Rs. ${cart.grandTotal}</span>
                            </div>

                            <!-- COD Notification Banner -->
                            <div class="p-3 bg-light rounded-3 border mb-3 small d-flex gap-2">
                                <i class="bi bi-cash-stack fs-5 text-warning"></i>
                                <div>
                                    <div class="fw-bold text-dark">Cash on Delivery (COD)</div>
                                    <div class="text-muted">Pay in cash directly upon delivery or at the restaurant desk.</div>
                                </div>
                            </div>

                            <!-- Proceed to Checkout Button -->
                            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-accent w-100 py-3 fw-bold">
                                Proceed to Checkout <i class="bi bi-arrow-right ms-1"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Empty Cart State -->
                <div class="p-5 text-center bg-white rounded-4 border shadow-sm my-4">
                    <i class="bi bi-cart-x text-muted display-3 mb-3 d-block"></i>
                    <h4 class="fw-bold text-dark">Your cart is currently empty</h4>
                    <p class="text-muted col-md-6 mx-auto mb-4">
                        Good food is always just a few clicks away! Browse the top restaurants in your area and fill your cart with delicacies.
                    </p>
                    <a href="${pageContext.request.contextPath}/restaurants" class="btn btn-accent px-4 py-2">
                        <i class="bi bi-shop me-2"></i> Browse Restaurants
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="common/footer.jsp" />
