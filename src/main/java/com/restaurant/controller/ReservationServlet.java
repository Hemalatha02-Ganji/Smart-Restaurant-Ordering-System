package com.restaurant.controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.restaurant.model.Reservation;
import com.restaurant.model.Restaurant;
import com.restaurant.model.RestaurantTable;
import com.restaurant.service.ReservationService;
import com.restaurant.service.RestaurantService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "ReservationServlet", urlPatterns = {"/reserve-table"})
public class ReservationServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();
    private final RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // AJAX table availability lookup
        if ("check-availability".equalsIgnoreCase(action)) {
            handleAvailabilityCheck(request, response);
            return;
        }

        String restIdParam = request.getParameter("restaurantId");
        int restaurantId = 1; // default to first restaurant
        if (restIdParam != null && !restIdParam.isEmpty()) {
            try {
                restaurantId = Integer.parseInt(restIdParam);
            } catch (NumberFormatException ignored) {}
        }

        List<Restaurant> allRestaurants = restaurantService.getAllRestaurants(true);
        Restaurant selectedRestaurant = restaurantService.getRestaurantById(restaurantId);

        // Preload available tables for today & default slot
        Date today = Date.valueOf(LocalDate.now());
        String defaultSlot = "07:30 PM - 09:00 PM";
        List<RestaurantTable> availableTables = reservationService.getAvailableTables(restaurantId, today, defaultSlot, 2);

        HttpSession session = request.getSession();
        String customerName = (String) session.getAttribute("customerName");

        request.setAttribute("restaurants", allRestaurants);
        request.setAttribute("selectedRestaurant", selectedRestaurant);
        request.setAttribute("availableTables", availableTables);
        request.setAttribute("customerName", customerName != null ? customerName : "");
        request.setAttribute("todayDate", today.toString());

        request.getRequestDispatcher("/WEB-INF/views/reservation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            int tableId = Integer.parseInt(request.getParameter("tableId"));
            String customerName = request.getParameter("customerName");
            String customerMobile = request.getParameter("customerMobile");
            Date date = Date.valueOf(request.getParameter("reservationDate"));
            String timeSlot = request.getParameter("timeSlot");
            int guests = Integer.parseInt(request.getParameter("guestCount"));
            String specialRequests = request.getParameter("specialRequests");

            Reservation res = new Reservation();
            res.setRestaurantId(restaurantId);
            res.setTableId(tableId);
            res.setCustomerName(customerName);
            res.setCustomerMobile(customerMobile);
            res.setReservationDate(date);
            res.setTimeSlot(timeSlot);
            res.setGuestCount(guests);
            res.setSpecialRequests(specialRequests);
            res.setStatus("PENDING");

            boolean booked = reservationService.bookTable(res);
            if (booked) {
                // Save customer name in session
                request.getSession().setAttribute("customerName", customerName);
                response.sendRedirect(request.getContextPath() + "/reserve-table?bookingSuccess=true&resId=" + res.getReservationId());
            } else {
                response.sendRedirect(request.getContextPath() + "/reserve-table?restaurantId=" + restaurantId + "&error=slot_unavailable");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reserve-table?error=invalid_data");
        }
    }

    private void handleAvailabilityCheck(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json");
        try {
            int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));
            Date date = Date.valueOf(req.getParameter("date"));
            String timeSlot = req.getParameter("timeSlot");
            int guestCount = Integer.parseInt(req.getParameter("guests"));

            List<RestaurantTable> tables = reservationService.getAvailableTables(restaurantId, date, timeSlot, guestCount);

            JsonArray arr = new JsonArray();
            for (RestaurantTable t : tables) {
                JsonObject o = new JsonObject();
                o.addProperty("tableId", t.getTableId());
                o.addProperty("tableNumber", t.getTableNumber());
                o.addProperty("capacity", t.getCapacity());
                arr.add(o);
            }
            res.getWriter().write(arr.toString());
        } catch (Exception e) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject err = new JsonObject();
            err.addProperty("error", e.getMessage());
            res.getWriter().write(err.toString());
        }
    }
}

