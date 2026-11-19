<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Footer -->
<footer class="footer-custom">
    <div class="container">
        <div class="row g-4">
            <!-- Brand Column -->
            <div class="col-lg-4 col-md-6">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <i class="bi bi-fire text-warning fs-3"></i>
                    <span class="fs-4 fw-bold text-white">Smart<span style="color: var(--accent-orange);">Restaurant</span></span>
                </div>
                <p class="text-white-50 small mb-3">
                    Premium enterprise multi-restaurant dining and delivery platform. Explore authentic local cuisines, reserve dining tables, and enjoy hassle-free Cash on Delivery checkout with instant digital invoices.
                </p>
                <div class="d-flex gap-2">
                    <span class="badge bg-dark border border-secondary text-light px-3 py-2"><i class="bi bi-cash-stack text-warning me-1"></i> Cash on Delivery Only</span>
                    <span class="badge bg-dark border border-secondary text-light px-3 py-2"><i class="bi bi-shield-check text-success me-1"></i> No Login Needed</span>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="col-lg-2 col-md-6 col-6">
                <h5>Navigation</h5>
                <ul class="list-unstyled small d-flex flex-column gap-2">
                    <li><a href="${pageContext.request.contextPath}/home"><i class="bi bi-chevron-right me-1"></i> Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/restaurants"><i class="bi bi-chevron-right me-1"></i> Restaurants</a></li>
                    <li><a href="${pageContext.request.contextPath}/reserve-table"><i class="bi bi-chevron-right me-1"></i> Book a Table</a></li>
                    <li><a href="${pageContext.request.contextPath}/track-order"><i class="bi bi-chevron-right me-1"></i> Track Order</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart"><i class="bi bi-chevron-right me-1"></i> View Cart</a></li>
                </ul>
            </div>

            <!-- Service Areas -->
            <div class="col-lg-3 col-md-6 col-6">
                <h5>Service Areas</h5>
                <ul class="list-unstyled small d-flex flex-column gap-2">
                    <li><a href="${pageContext.request.contextPath}/restaurants?area=Mylavaram"><i class="bi bi-geo-alt me-1 text-warning"></i> Mylavaram (Spice Garden, Green Leaf)</a></li>
                    <li><a href="${pageContext.request.contextPath}/restaurants?area=Vijayawada"><i class="bi bi-geo-alt me-1 text-warning"></i> Vijayawada (Royal Biryani House)</a></li>
                    <li><a href="${pageContext.request.contextPath}/restaurants?area=Gannavaram"><i class="bi bi-geo-alt me-1 text-warning"></i> Gannavaram (Food Junction)</a></li>
                    <li><a href="${pageContext.request.contextPath}/restaurants?area=Ibrahimpatnam"><i class="bi bi-geo-alt me-1 text-warning"></i> Ibrahimpatnam (Express Delivery)</a></li>
                </ul>
            </div>

            <!-- Administration & Support -->
            <div class="col-lg-3 col-md-6">
                <h5>Staff & Portals</h5>
                <p class="text-white-50 small mb-2">
                    Restaurant managers and platform administrators can sign in here to manage menus, orders, tables, and invoices.
                </p>
                <a href="${pageContext.request.contextPath}/admin/login" class="btn btn-outline-light btn-sm mb-3">
                    <i class="bi bi-lock me-1"></i> Staff / Admin Login
                </a>
                <div class="text-white-50 small">
                    <div><i class="bi bi-headset me-2 text-warning"></i> +91 98765 43210</div>
                    <div><i class="bi bi-envelope me-2 text-warning"></i> support@smartrestaurant.com</div>
                </div>
            </div>
        </div>

        <hr class="border-secondary my-4 opacity-50">

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center small text-white-50">
            <div>&copy; 2026 Smart Restaurant Ordering & Billing System. Full Stack Development 2 Project.</div>
            <div class="mt-2 mt-md-0">
                <span class="badge bg-success-subtle text-success me-2">Tomcat 10.1</span>
                <span class="badge bg-primary-subtle text-primary me-2">Java 21</span>
                <span class="badge bg-warning-subtle text-warning">MySQL 8.0</span>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 Bundle JS with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Project Main Script -->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>
</html>

