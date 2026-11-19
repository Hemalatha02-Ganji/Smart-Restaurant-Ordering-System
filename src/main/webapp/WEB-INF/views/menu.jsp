<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="${restaurant.name} - Menu" />
<c:set var="activePage" value="menu" />
<jsp:include page="common/header.jsp" />

<main class="py-4">
    <div class="container">
        <!-- Restaurant Header Banner Card -->
        <div class="card border-0 rounded-4 shadow-sm mb-4 overflow-hidden" style="background: linear-gradient(to right, #1b4332, #2d6a4f); color: #ffffff;">
            <div class="card-body p-4 p-md-5">
                <div class="row align-items-center g-4">
                    <div class="col-md-3 text-center">
                        <img src="${restaurant.imageUrl}" alt="${restaurant.name}" class="img-fluid rounded-4 shadow border border-3 border-white"
                             style="width: 180px; height: 180px; object-fit: cover;">
                    </div>
                    <div class="col-md-9">
                        <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
                            <h2 class="fw-bold mb-0">${restaurant.name}</h2>
                            <span class="badge bg-warning text-dark fw-bold fs-6">
                                <i class="bi bi-star-fill me-1"></i>${restaurant.rating}
                            </span>
                            <span class="badge bg-white bg-opacity-25 text-white">${restaurant.cuisine}</span>
                        </div>
                        <p class="text-white-50 mb-2 small">${restaurant.description}</p>
                        <div class="d-flex flex-wrap gap-3 text-white-50 small mt-3">
                            <div><i class="bi bi-geo-alt me-1 text-warning"></i>${restaurant.address}</div>
                            <div><i class="bi bi-clock me-1 text-warning"></i>${restaurant.openingHours}</div>
                            <div><i class="bi bi-telephone me-1 text-warning"></i>${restaurant.contactNumber}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter & Search Bar -->
        <div class="card border-0 rounded-4 shadow-sm mb-4">
            <div class="card-body p-3">
                <div class="row g-2 align-items-center">
                    <!-- Search Input -->
                    <div class="col-md-5">
                        <form action="${pageContext.request.contextPath}/menu" method="GET" class="d-flex">
                            <input type="hidden" name="id" value="${restaurant.restaurantId}">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" name="q" class="form-control border-start-0" 
                                       placeholder="Search dishes (e.g. Biryani, Paneer, Burger)..." value="${searchQuery}">
                                <button class="btn btn-primary-custom" type="submit">Search</button>
                            </div>
                        </form>
                    </div>

                    <!-- Category Pills -->
                    <div class="col-md-5">
                        <div class="d-flex flex-wrap gap-1">
                            <a href="${pageContext.request.contextPath}/menu?id=${restaurant.restaurantId}" 
                               class="btn btn-sm ${empty selectedCategory ? 'btn-accent' : 'btn-light border'}">
                                All
                            </a>
                            <c:forEach var="cat" items="${categories}">
                                <a href="${pageContext.request.contextPath}/menu?id=${restaurant.restaurantId}&category=${cat.categoryId}" 
                                   class="btn btn-sm ${selectedCategory == cat.categoryId ? 'btn-accent' : 'btn-light border'}">
                                    ${cat.categoryName}
                                </a>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Veg / Non-Veg Toggle -->
                    <div class="col-md-2 text-md-end">
                        <div class="btn-group btn-group-sm">
                            <a href="${pageContext.request.contextPath}/menu?id=${restaurant.restaurantId}&type=VEG" 
                               class="btn ${foodType == 'VEG' ? 'btn-success' : 'btn-outline-success'}">
                                <span class="type-indicator type-veg me-1" style="width:10px; height:10px;"></span> Veg
                            </a>
                            <a href="${pageContext.request.contextPath}/menu?id=${restaurant.restaurantId}&type=NON_VEG" 
                               class="btn ${foodType == 'NON_VEG' ? 'btn-danger' : 'btn-outline-danger'}">
                                <span class="type-indicator type-nonveg me-1" style="width:10px; height:10px;"></span> Non-Veg
                            </a>
                            <c:if test="${not empty foodType}">
                                <a href="${pageContext.request.contextPath}/menu?id=${restaurant.restaurantId}" class="btn btn-outline-secondary" title="Clear Filter">
                                    <i class="bi bi-x-lg"></i>
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Food Items Grid -->
        <c:choose>
            <c:when test="${not empty menuItems}">
                <div class="row g-3">
                    <c:forEach var="item" items="${menuItems}">
                        <div class="col-lg-6">
                            <div class="food-card ${!item.available ? 'opacity-75' : ''}">
                                <div class="d-flex gap-3 align-items-center">
                                    <!-- Food Image -->
                                    <div class="food-img-wrapper">
                                        <img src="${item.imageUrl}" alt="${item.name}" class="food-img" loading="lazy">
                                    </div>

                                    <!-- Food Info -->
                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <span class="type-indicator ${item.veg ? 'type-veg' : 'type-nonveg'}" 
                                                  title="${item.veg ? 'Pure Vegetarian' : 'Non-Vegetarian'}"></span>
                                            <h6 class="fw-bold mb-0 text-dark">${item.name}</h6>
                                        </div>
                                        <div class="text-muted small mb-2" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                            ${item.description}
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="fw-bold fs-5 text-dark">Rs. ${item.price}</span>
                                            
                                            <!-- Action: Add to Cart or Unavailable Badge -->
                                            <c:choose>
                                                <c:when test="${item.available}">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <div class="qty-control">
                                                            <button type="button" class="qty-btn" onclick="let q = document.getElementById('qty-${item.itemId}'); if(q.value > 1) q.value--;">-</button>
                                                            <input type="text" id="qty-${item.itemId}" class="qty-input" value="1" readonly>
                                                            <button type="button" class="qty-btn" onclick="let q = document.getElementById('qty-${item.itemId}'); q.value++;">+</button>
                                                        </div>
                                                        <button type="button" class="btn btn-accent btn-sm px-3 btn-add-cart" 
                                                                data-item-id="${item.itemId}" 
                                                                data-item-name="${item.name}">
                                                            <i class="bi bi-cart-plus me-1"></i> Add
                                                        </button>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger small py-2 px-3">
                                                        Currently Unavailable
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="p-5 text-center bg-white rounded-4 border shadow-sm my-4">
                    <i class="bi bi-egg-fried text-muted display-4 mb-3 d-block"></i>
                    <h5 class="fw-bold text-dark">No food items found</h5>
                    <p class="text-muted small">Try adjusting your search query or category filters.</p>
                    <a href="${pageContext.request.contextPath}/menu?id=${restaurant.restaurantId}" class="btn btn-outline-secondary btn-sm">
                        View Entire Menu
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="common/footer.jsp" />

