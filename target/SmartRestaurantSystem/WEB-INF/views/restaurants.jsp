<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Discover Restaurants - Smart Restaurant" />
<c:set var="activePage" value="restaurants" />
<jsp:include page="common/header.jsp" />

<main class="py-5">
    <div class="container">
        <!-- Area Filter & Page Header -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4 pb-3 border-bottom">
            <div>
                <h2 class="fw-bold mb-1" style="color: var(--primary-dark);">Explore Dining & Kitchens</h2>
                <p class="text-muted small mb-0">
                    <c:choose>
                        <c:when test="${showAll}">
                            Showing all restaurants across all areas.
                        </c:when>
                        <c:otherwise>
                            Showing partner restaurants serving <strong>${activeArea}</strong>.
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>

            <!-- Area Quick Filter Buttons -->
            <div class="d-flex flex-wrap align-items-center gap-2">
                <span class="small fw-semibold text-secondary me-1">Filter by Area:</span>
                <a href="${pageContext.request.contextPath}/restaurants?all=true" 
                   class="btn btn-sm ${showAll ? 'btn-dark' : 'btn-outline-secondary'}">
                    All Areas
                </a>
                <c:forEach var="area" items="${allAreas}">
                    <a href="${pageContext.request.contextPath}/restaurants?area=${area.areaName}" 
                       class="btn btn-sm ${(!showAll && activeArea == area.areaName) ? 'btn-accent' : 'btn-outline-secondary'}">
                        ${area.areaName}
                    </a>
                </c:forEach>
            </div>
        </div>

        <!-- Restaurants Grid -->
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
                <!-- Empty State -->
                <div class="p-5 text-center bg-white rounded-4 border my-4 shadow-sm">
                    <i class="bi bi-shop-window text-muted display-3 mb-3 d-block"></i>
                    <h4 class="fw-bold text-dark">No Restaurants Found for "${activeArea}"</h4>
                    <p class="text-muted col-md-6 mx-auto mb-4">
                        There are currently no active restaurants operating in this area. You can switch to another area or view all partner kitchens.
                    </p>
                    <div class="d-flex justify-content-center gap-2">
                        <a href="${pageContext.request.contextPath}/restaurants?all=true" class="btn btn-primary-custom px-4 py-2">
                            View All Restaurants
                        </a>
                        <button type="button" class="btn btn-outline-secondary px-4 py-2" data-bs-toggle="modal" data-bs-target="#areaSelectionModal">
                            Change Area
                        </button>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="common/footer.jsp" />

