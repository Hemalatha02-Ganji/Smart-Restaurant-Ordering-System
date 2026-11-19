package com.restaurant.controller;

import com.restaurant.model.*;
import com.restaurant.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {
        "/admin/dashboard",
        "/admin/orders",
        "/admin/menu",
        "/admin/tables",
        "/admin/reservations",
        "/admin/invoices"
})
public class AdminDashboardServlet extends HttpServlet {

    private final OrderService orderService = new OrderService();
    private final MenuService menuService = new MenuService();
    private final ReservationService reservationService = new ReservationService();
    private final BillingService billingService = new BillingService();
    private final RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("loggedAdmin");

        // Role check
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // If Super Admin, default restaurantId can be first restaurant or allow managing all
        int restaurantId = (admin.getRestaurantId() != null) ? admin.getRestaurantId() : 1;
        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);

        String path = request.getServletPath();

        if ("/admin/dashboard".equals(path)) {
            Map<String, Object> stats = orderService.getRestaurantStatistics(restaurantId);
            List<Order> recentOrders = orderService.getOrdersByRestaurant(restaurantId);
            List<Reservation> recentReservations = reservationService.getReservationsByRestaurant(restaurantId);

            request.setAttribute("stats", stats);
            request.setAttribute("recentOrders", recentOrders != null && recentOrders.size() > 5 ? recentOrders.subList(0, 5) : recentOrders);
            request.setAttribute("recentReservations", recentReservations != null && recentReservations.size() > 5 ? recentReservations.subList(0, 5) : recentReservations);
            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

        } else if ("/admin/orders".equals(path)) {
            List<Order> orders = orderService.getOrdersByRestaurant(restaurantId);
            request.setAttribute("orders", orders);
            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);

        } else if ("/admin/menu".equals(path)) {
            List<MenuItem> menuItems = menuService.getMenuByRestaurant(restaurantId, false);
            List<Category> categories = menuService.getAllCategories();
            request.setAttribute("menuItems", menuItems);
            request.setAttribute("categories", categories);
            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/admin/menu.jsp").forward(request, response);

        } else if ("/admin/tables".equals(path)) {
            List<RestaurantTable> tables = reservationService.getTablesByRestaurant(restaurantId);
            request.setAttribute("tables", tables);
            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/admin/tables.jsp").forward(request, response);

        } else if ("/admin/reservations".equals(path)) {
            List<Reservation> reservations = reservationService.getReservationsByRestaurant(restaurantId);
            request.setAttribute("reservations", reservations);
            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/admin/reservations.jsp").forward(request, response);

        } else if ("/admin/invoices".equals(path)) {
            List<Invoice> invoices = billingService.getInvoicesByRestaurant(restaurantId);
            request.setAttribute("invoices", invoices);
            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/admin/invoices.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("loggedAdmin");
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        int restaurantId = (admin.getRestaurantId() != null) ? admin.getRestaurantId() : 1;
        String action = request.getParameter("action");

        // 1. ORDER STATUS & PAYMENT ACTIONS
        if ("update-order-status".equalsIgnoreCase(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status");
            orderService.updateOrderStatus(orderId, newStatus);
            response.sendRedirect(request.getContextPath() + "/admin/orders?updated=true");

        } else if ("collect-cod".equalsIgnoreCase(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            orderService.markCodPaymentPaid(orderId);
            response.sendRedirect(request.getContextPath() + "/admin/orders?paid=true");

        // 2. MENU ACTIONS
        } else if ("add-menu-item".equalsIgnoreCase(action)) {
            MenuItem item = new MenuItem();
            item.setRestaurantId(restaurantId);
            item.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            item.setName(request.getParameter("name"));
            item.setDescription(request.getParameter("description"));
            item.setPrice(new BigDecimal(request.getParameter("price")));
            item.setFoodType(request.getParameter("foodType"));
            item.setAvailable("true".equalsIgnoreCase(request.getParameter("isAvailable")));
            item.setImageUrl(request.getParameter("imageUrl"));
            menuService.createMenuItem(item);
            response.sendRedirect(request.getContextPath() + "/admin/menu?created=true");

        } else if ("edit-menu-item".equalsIgnoreCase(action)) {
            MenuItem item = new MenuItem();
            item.setItemId(Integer.parseInt(request.getParameter("itemId")));
            item.setRestaurantId(restaurantId);
            item.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            item.setName(request.getParameter("name"));
            item.setDescription(request.getParameter("description"));
            item.setPrice(new BigDecimal(request.getParameter("price")));
            item.setFoodType(request.getParameter("foodType"));
            item.setAvailable("true".equalsIgnoreCase(request.getParameter("isAvailable")));
            item.setImageUrl(request.getParameter("imageUrl"));
            menuService.updateMenuItem(item);
            response.sendRedirect(request.getContextPath() + "/admin/menu?updated=true");

        } else if ("toggle-availability".equalsIgnoreCase(action)) {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            boolean isAvailable = "true".equalsIgnoreCase(request.getParameter("isAvailable"));
            menuService.toggleAvailability(itemId, restaurantId, isAvailable);
            response.sendRedirect(request.getContextPath() + "/admin/menu?toggled=true");

        } else if ("delete-menu-item".equalsIgnoreCase(action)) {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            menuService.deleteMenuItem(itemId, restaurantId);
            response.sendRedirect(request.getContextPath() + "/admin/menu?deleted=true");

        // 3. TABLE ACTIONS
        } else if ("add-table".equalsIgnoreCase(action)) {
            RestaurantTable t = new RestaurantTable();
            t.setRestaurantId(restaurantId);
            t.setTableNumber(request.getParameter("tableNumber"));
            t.setCapacity(Integer.parseInt(request.getParameter("capacity")));
            t.setActive(true);
            reservationService.createTable(t);
            response.sendRedirect(request.getContextPath() + "/admin/tables?created=true");

        } else if ("edit-table".equalsIgnoreCase(action)) {
            RestaurantTable t = new RestaurantTable();
            t.setTableId(Integer.parseInt(request.getParameter("tableId")));
            t.setRestaurantId(restaurantId);
            t.setTableNumber(request.getParameter("tableNumber"));
            t.setCapacity(Integer.parseInt(request.getParameter("capacity")));
            t.setActive("true".equalsIgnoreCase(request.getParameter("isActive")));
            reservationService.updateTable(t);
            response.sendRedirect(request.getContextPath() + "/admin/tables?updated=true");

        } else if ("delete-table".equalsIgnoreCase(action)) {
            int tableId = Integer.parseInt(request.getParameter("tableId"));
            reservationService.deleteTable(tableId, restaurantId);
            response.sendRedirect(request.getContextPath() + "/admin/tables?deleted=true");

        // 4. RESERVATION ACTIONS
        } else if ("update-reservation-status".equalsIgnoreCase(action)) {
            int resId = Integer.parseInt(request.getParameter("reservationId"));
            String status = request.getParameter("status"); // APPROVED, REJECTED, CANCELLED, COMPLETED
            reservationService.updateReservationStatus(resId, status);
            response.sendRedirect(request.getContextPath() + "/admin/reservations?updated=true");
        }
    }
}

