<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Smart Restaurant - Authentic Dining & Fast Delivery" />
<c:set var="activePage" value="home" />
<jsp:include page="common/header.jsp" />

<main>
    <!-- HERO SECTION -->
    <section class="hero-section">
        <div class="container position-relative" style="z-index: 2;">
            <div class="row align-items-center g-4">
                <div class="col-lg-7">
                    <span class="badge bg-warning text-dark fw-bold px-3 py-2 mb-3 rounded-pill">
                        <i class="bi bi-geo-alt-fill me-1"></i> Serving ${selectedArea}
                    </span>
                    <h1 class="hero-title">
                        Craving Good Food?<br>
                        Discover Top Restaurants in <span style="color: var(--accent-orange);">${selectedArea}</span>.
                    </h1>
                    <p class="hero-subtitle">
                        Order your favorite gourmet delicacies for doorstep delivery or reserve your table in advance. Pay securely with Cash on Delivery (COD) upon receiving your order!
                    </p>

                    <!-- Search and Action Buttons -->
                    <div class="d-flex flex-wrap gap-3">
                        <a href="#restaurantSection" class="btn btn-accent px-4 py-3 fw-bold">
                            <i class="bi bi-shop me-2"></i> Browse Restaurants
                        </a>
                        <a href="${pageContext.request.contextPath}/reserve-table" class="btn btn-outline-light px-4 py-3 fw-semibold">
                            <i class="bi bi-calendar-event me-2"></i> Book Dine-In Table
                        </a>
                        <button type="button" class="btn btn-dark bg-opacity-50 px-4 py-3 fw-semibold border border-light border-opacity-25" data-bs-toggle="modal" data-bs-target="#areaSelectionModal">
                            <i class="bi bi-arrow-repeat me-2"></i> Change Area
                        </button>
                    </div>

                    <!-- Trust Highlights -->
                    <div class="d-flex flex-wrap gap-4 mt-4 pt-2 text-white-50 small">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-lightning-charge-fill text-warning fs-5"></i>
                            <span>Express Delivery</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-wallet2 text-success fs-5"></i>
                            <span>Strictly Cash on Delivery</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-receipt text-info fs-5"></i>
                            <span>Instant Digital Invoices</span>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5 d-none d-lg-block text-center">
                    <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=700&q=80" 
                         alt="Delicious Food" class="img-fluid rounded-4 shadow-lg border border-4 border-white"
                         style="max-height: 420px; width: 100%; object-fit: cover;">
                </div>
            </div>
        </div>
    </section>

    <!-- PROMOTIONS & OFFERS BANNER -->
    <section class="py-4 bg-light border-bottom">
        <div class="container">
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="p-3 bg-white rounded-3 shadow-sm border d-flex align-items-center gap-3">
                        <div class="rounded-circle p-3 bg-warning-subtle text-warning fs-4"><i class="bi bi-tag-fill"></i></div>
                        <div>
                            <div class="fw-bold text-dark">Fresh Authentic Taste</div>
                            <div class="small text-muted">Direct from certified kitchens</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 bg-white rounded-3 shadow-sm border d-flex align-items-center gap-3">
                        <div class="rounded-circle p-3 bg-success-subtle text-success fs-4"><i class="bi bi-cash-coin"></i></div>
                        <div>
                            <div class="fw-bold text-dark">Cash on Delivery Only</div>
                            <div class="small text-muted">Pay comfortably with cash on receipt</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 bg-white rounded-3 shadow-sm border d-flex align-items-center gap-3">
                        <div class="rounded-circle p-3 bg-primary-subtle text-primary fs-4"><i class="bi bi-door-open-fill"></i></div>
                        <div>
                            <div class="fw-bold text-dark">Guaranteed Table Seating</div>
                            <div class="small text-muted">Real-time database table reservations</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FOOD CATEGORIES SECTION -->
    <section class="py-5">
        <div class="container">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <span class="text-uppercase fw-bold text-success small tracking-wide">Culinary Assortment</span>
                    <h2 class="fw-bold mt-1 mb-0" style="color: var(--primary-dark);">Explore Categories</h2>
                </div>
            </div>

            <div class="row g-3 text-center">
                <c:forEach var="cat" items="${categories}">
                    <div class="col-6 col-md-4 col-lg-2">
                        <div class="p-3 bg-white rounded-4 border shadow-sm h-100 transition-hover">
                            <div class="rounded-circle mx-auto mb-2 d-flex align-items-center justify-content-center" 
                                 style="width: 58px; height: 58px; background-color: var(--primary-subtle); color: var(--primary-dark);">
                                <i class="bi ${cat.iconClass} fs-3"></i>
                            </div>
                            <h6 class="fw-bold mb-0 text-dark">${cat.categoryName}</h6>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- AREA-BASED RESTAURANTS SECTION -->
    <section class="py-5 bg-white border-top border-bottom" id="restaurantSection">
        <div class="container">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end mb-4 gap-2">
                <div>
                    <span class="text-uppercase fw-bold text-warning small tracking-wide">Area-Based Discovery</span>
                    <h2 class="fw-bold mt-1 mb-1" style="color: var(--primary-dark);">
                        Restaurants Serving <span style="color: var(--accent-orange);">${selectedArea}</span>
                    </h2>
                    <p class="text-muted small mb-0">
                        Based on your selected delivery location, here are the available partner dining kitchens.
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#areaSelectionModal">
                        <i class="bi bi-geo-alt me-1"></i> Change Area (${selectedArea})
                    </button>
                    <a href="${pageContext.request.contextPath}/restaurants?all=true" class="btn btn-outline-dark btn-sm">
                        View All
                    </a>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty restaurants}">
                    <div class="row g-4">
                        <c:forEach var="rest" items="${restaurants}">
                            <div class="col-lg-6 col-xl-3 col-md-6">
                                <div class="custom-card restaurant-card h-100 d-flex flex-column">
                                    <div class="rest-img-wrapper">
                                        <img src="${rest.imageUrl}" alt="${rest.name}" class="rest-img" loading="lazy">
                                        <div class="rest-badge-rating">
                                            <i class="bi bi-star-fill"></i>
                                            <span>${rest.rating}</span>
                                        </div>
                                    </div>
                                    <div class="p-3 d-flex flex-column flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-start mb-1">
                                            <h5 class="fw-bold mb-0 text-dark">${rest.name}</h5>
                                            <span class="badge bg-light text-secondary border small">${rest.cuisine}</span>
                                        </div>
                                        <div class="text-muted small mb-2">
                                            <i class="bi bi-geo-alt me-1 text-danger"></i>${rest.address}
                                        </div>
                                        <p class="small text-secondary flex-grow-1 mb-3" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                            ${rest.description}
                                        </p>
                                        
                                        <div class="d-flex align-items-center justify-content-between pt-2 border-top small text-muted mb-3">
                                            <span><i class="bi bi-clock me-1"></i>${rest.openingHours}</span>
                                            <span class="fw-semibold text-success"><i class="bi bi-bicycle me-1"></i>Rs. ${rest.deliveryCharge}</span>
                                        </div>

                                        <div class="d-grid gap-2">
                                            <a href="${pageContext.request.contextPath}/menu?id=${rest.restaurantId}" class="btn btn-accent btn-sm py-2">
                                                <i class="bi bi-book-half me-1"></i> View Menu
                                            </a>
                                            <a href="${pageContext.request.contextPath}/reserve-table?restaurantId=${rest.restaurantId}" class="btn btn-outline-dark btn-sm">
                                                <i class="bi bi-calendar-plus me-1"></i> Book Table
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Attractive Empty State -->
                    <div class="p-5 text-center bg-light rounded-4 border my-4">
                        <i class="bi bi-shop-window text-muted display-3 mb-3 d-block"></i>
                        <h4 class="fw-bold text-dark">No Restaurants Currently Serving "${selectedArea}"</h4>
                        <p class="text-muted col-md-6 mx-auto mb-4">
                            We haven't expanded to this specific neighborhood yet, or active restaurants are currently offline. Try switching your area to explore our partner kitchens in nearby Mylavaram or Vijayawada!
                        </p>
                        <button type="button" class="btn btn-accent px-4 py-2" data-bs-toggle="modal" data-bs-target="#areaSelectionModal">
                            <i class="bi bi-geo-alt me-2"></i> Select Another Area
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- ABOUT SECTION -->
    <section class="py-5">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6">
                    <span class="badge bg-success-subtle text-success fw-bold px-3 py-2 rounded-pill mb-2">College FSD-2 Project</span>
                    <h2 class="fw-bold mb-3" style="color: var(--primary-dark);">About the Smart Restaurant Platform</h2>
                    <p class="text-secondary">
                        The Smart Restaurant Ordering & Billing System is an enterprise-grade food commerce application engineered with Java 21, Jakarta Servlets, JDBC, and Apache Tomcat 10.1.
                    </p>
                    <p class="text-secondary small">
                        Unlike conventional web stores, customers enjoy instant guest access with zero login requirements. Select your area, order delicious delicacies across independent restaurant menus, reserve live tables with concurrency protection, and settle bills via Cash on Delivery with auto-generated tax invoices.
                    </p>
                    <div class="row g-3 mt-2">
                        <div class="col-6">
                            <div class="border-start border-4 border-success ps-3">
                                <h4 class="fw-bold mb-0 text-dark">4</h4>
                                <div class="text-muted small">Partner Restaurants</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="border-start border-4 border-warning ps-3">
                                <h4 class="fw-bold mb-0 text-dark">100%</h4>
                                <div class="text-muted small">Cash on Delivery</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 text-center">
                    <img src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=700&q=80" 
                         alt="Dining experience" class="img-fluid rounded-4 shadow border">
                </div>
            </div>
        </div>
    </section>

    <!-- CUSTOMER REVIEWS SECTION -->
    <section class="py-5 bg-light border-top">
        <div class="container">
            <div class="text-center mb-5">
                <span class="text-uppercase fw-bold text-success small">Customer Testimonials</span>
                <h2 class="fw-bold mt-1" style="color: var(--primary-dark);">Loved by Local Foodies</h2>
            </div>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="p-4 bg-white rounded-4 border shadow-sm h-100">
                        <div class="text-warning mb-2">
                            <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                        </div>
                        <p class="text-secondary small italic mb-3">
                            "The Rayalaseema Chicken Biryani from Spice Garden in Mylavaram is authentic and fiery! Best part is no password or login hassle."
                        </p>
                        <div class="fw-bold text-dark">Bhavani K.</div>
                        <div class="text-muted small">Mylavaram Resident</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4 bg-white rounded-4 border shadow-sm h-100">
                        <div class="text-warning mb-2">
                            <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                        </div>
                        <p class="text-secondary small italic mb-3">
                            "Royal Biryani House Vijayawada has royal flavors. The table reservation feature helped us skip the weekend queue with our family."
                        </p>
                        <div class="fw-bold text-dark">Karthik Rao</div>
                        <div class="text-muted small">Vijayawada Foodie</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4 bg-white rounded-4 border shadow-sm h-100">
                        <div class="text-warning mb-2">
                            <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                        </div>
                        <p class="text-secondary small italic mb-3">
                            "Pure veg heaven at Green Leaf near LBRCE campus. Clean digital invoice with instant PDF download makes expense tracking very simple."
                        </p>
                        <div class="fw-bold text-dark">Anusha M.</div>
                        <div class="text-muted small">Student, LBRCE</div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp" />

