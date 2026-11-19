package com.restaurant.controller;

import com.restaurant.model.*;
import com.restaurant.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@WebServlet(name = "SuperAdminDashboardServlet", urlPatterns = {
        "/superadmin/dashboard",
        "/superadmin/restaurants",
        "/superadmin/areas",
        "/superadmin/orders",
        "/superadmin/admins",
        "/superadmin/reservations"
})
public class SuperAdminDashboardServlet extends HttpServlet {

    private final RestaurantService restaurantService = new RestaurantService();
    private final OrderService orderService = new OrderService();
    private final ReservationService reservationService = new ReservationService();
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/superadmin/dashboard".equals(path)) {
            Map<String, Object> platformStats = orderService.getPlatformStatistics();
            List<Restaurant> restaurants = restaurantService.getAllRestaurants(false);
            List<Order> recentOrders = orderService.getAllOrders();
            List<Reservation> recentReservations = reservationService.getAllReservations();

            request.setAttribute("stats", platformStats);
            request.setAttribute("restaurants", restaurants);
            request.setAttribute("recentOrders", recentOrders != null && recentOrders.size() > 5 ? recentOrders.subList(0, 5) : recentOrders);
            request.setAttribute("recentReservations", recentReservations != null && recentReservations.size() > 5 ? recentReservations.subList(0, 5) : recentReservations);
            request.getRequestDispatcher("/superadmin/dashboard.jsp").forward(request, response);

        } else if ("/superadmin/restaurants".equals(path)) {
            List<Restaurant> restaurants = restaurantService.getAllRestaurants(false);
            List<ServiceArea> areas = restaurantService.getAllAreas(false);
            request.setAttribute("restaurants", restaurants);
            request.setAttribute("areas", areas);
            request.getRequestDispatcher("/superadmin/restaurants.jsp").forward(request, response);

        } else if ("/superadmin/areas".equals(path)) {
            List<ServiceArea> areas = restaurantService.getAllAreas(false);
            List<Restaurant> restaurants = restaurantService.getAllRestaurants(true);
            request.setAttribute("areas", areas);
            request.setAttribute("restaurants", restaurants);
            request.getRequestDispatcher("/superadmin/areas.jsp").forward(request, response);

        } else if ("/superadmin/orders".equals(path)) {
            List<Order> allOrders = orderService.getAllOrders();
            request.setAttribute("orders", allOrders);
            request.getRequestDispatcher("/superadmin/orders.jsp").forward(request, response);

        } else if ("/superadmin/admins".equals(path)) {
            List<Admin> admins = adminService.getAllAdmins();
            List<Restaurant> restaurants = restaurantService.getAllRestaurants(true);
            request.setAttribute("admins", admins);
            request.setAttribute("restaurants", restaurants);
            request.getRequestDispatcher("/superadmin/admins.jsp").forward(request, response);

        } else if ("/superadmin/reservations".equals(path)) {
            List<Reservation> reservations = reservationService.getAllReservations();
            request.setAttribute("reservations", reservations);
            request.getRequestDispatcher("/superadmin/reservations.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // 1. RESTAURANT ACTIONS
        if ("add-restaurant".equalsIgnoreCase(action)) {
            Restaurant r = new Restaurant();
            r.setName(request.getParameter("name"));
            r.setCuisine(request.getParameter("cuisine"));
            r.setDescription(request.getParameter("description"));
            r.setRating(new BigDecimal(request.getParameter("rating")));
            r.setAddress(request.getParameter("address"));
            r.setPrimaryArea(request.getParameter("primaryArea"));
            r.setOpeningHours(request.getParameter("openingHours"));
            r.setActive(true);
            r.setImageUrl(request.getParameter("imageUrl"));
            r.setContactNumber(request.getParameter("contactNumber"));
            restaurantService.createRestaurant(r);
            response.sendRedirect(request.getContextPath() + "/superadmin/restaurants?created=true");

        } else if ("edit-restaurant".equalsIgnoreCase(action)) {
            Restaurant r = new Restaurant();
            r.setRestaurantId(Integer.parseInt(request.getParameter("restaurantId")));
            r.setName(request.getParameter("name"));
            r.setCuisine(request.getParameter("cuisine"));
            r.setDescription(request.getParameter("description"));
            r.setRating(new BigDecimal(request.getParameter("rating")));
            r.setAddress(request.getParameter("address"));
            r.setPrimaryArea(request.getParameter("primaryArea"));
            r.setOpeningHours(request.getParameter("openingHours"));
            r.setActive("true".equalsIgnoreCase(request.getParameter("isActive")));
            r.setImageUrl(request.getParameter("imageUrl"));
            r.setContactNumber(request.getParameter("contactNumber"));
            restaurantService.updateRestaurant(r);
            response.sendRedirect(request.getContextPath() + "/superadmin/restaurants?updated=true");

        } else if ("toggle-restaurant".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("restaurantId"));
            boolean active = "true".equalsIgnoreCase(request.getParameter("isActive"));
            restaurantService.toggleRestaurantStatus(id, active);
            response.sendRedirect(request.getContextPath() + "/superadmin/restaurants?toggled=true");

        // 2. SERVICE AREA ACTIONS
        } else if ("add-area".equalsIgnoreCase(action)) {
            ServiceArea sa = new ServiceArea();
            sa.setAreaName(request.getParameter("areaName"));
            sa.setPincode(request.getParameter("pincode"));
            sa.setActive(true);
            restaurantService.createArea(sa);
            response.sendRedirect(request.getContextPath() + "/superadmin/areas?created=true");

        } else if ("assign-area".equalsIgnoreCase(action)) {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            int areaId = Integer.parseInt(request.getParameter("areaId"));
            BigDecimal fee = new BigDecimal(request.getParameter("deliveryCharge"));
            String time = request.getParameter("estimatedTime");
            restaurantService.assignAreaToRestaurant(restaurantId, areaId, fee, time);
            response.sendRedirect(request.getContextPath() + "/superadmin/areas?assigned=true");

        } else if ("remove-area".equalsIgnoreCase(action)) {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            int areaId = Integer.parseInt(request.getParameter("areaId"));
            restaurantService.removeAreaFromRestaurant(restaurantId, areaId);
            response.sendRedirect(request.getContextPath() + "/superadmin/areas?removed=true");

        // 3. ADMIN ASSIGNMENT ACTIONS
        } else if ("add-admin".equalsIgnoreCase(action)) {
            Admin admin = new Admin();
            admin.setUsername(request.getParameter("username"));
            admin.setPassword(request.getParameter("password"));
            admin.setFullName(request.getParameter("fullName"));
            admin.setEmail(request.getParameter("email"));
            admin.setRole(request.getParameter("role"));
            String rId = request.getParameter("restaurantId");
            if (rId != null && !rId.isEmpty() && !"NONE".equalsIgnoreCase(rId)) {
                admin.setRestaurantId(Integer.parseInt(rId));
            }
            adminService.createAdmin(admin);
            response.sendRedirect(request.getContextPath() + "/superadmin/admins?created=true");

        } else if ("edit-admin".equalsIgnoreCase(action)) {
            Admin admin = new Admin();
            admin.setAdminId(Integer.parseInt(request.getParameter("adminId")));
            admin.setFullName(request.getParameter("fullName"));
            admin.setEmail(request.getParameter("email"));
            String pw = request.getParameter("password");
            if (pw != null && !pw.trim().isEmpty()) {
                admin.setPassword(pw.trim());
            }
            String rId = request.getParameter("restaurantId");
            if (rId != null && !rId.isEmpty() && !"NONE".equalsIgnoreCase(rId)) {
                admin.setRestaurantId(Integer.parseInt(rId));
            } else {
                admin.setRestaurantId(null);
            }
            adminService.updateAdmin(admin);
            response.sendRedirect(request.getContextPath() + "/superadmin/admins?updated=true");

        } else if ("delete-admin".equalsIgnoreCase(action)) {
            int adminId = Integer.parseInt(request.getParameter("adminId"));
            adminService.deleteAdmin(adminId);
            response.sendRedirect(request.getContextPath() + "/superadmin/admins?deleted=true");
        }
    }
}

