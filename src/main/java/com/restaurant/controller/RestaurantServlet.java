package com.restaurant.controller;

import com.restaurant.model.Restaurant;
import com.restaurant.model.ServiceArea;
import com.restaurant.service.RestaurantService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "RestaurantServlet", urlPatterns = {"/restaurants"})
public class RestaurantServlet extends HttpServlet {

    private final RestaurantService restaurantService = new RestaurantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String sessionArea = (String) session.getAttribute("customerArea");
        String paramArea = request.getParameter("area");

        String activeArea = (paramArea != null && !paramArea.trim().isEmpty()) ? paramArea.trim() : sessionArea;
        if (activeArea == null || activeArea.trim().isEmpty()) {
            activeArea = "Mylavaram";
        }

        // Option to view all restaurants if requested
        String showAll = request.getParameter("all");
        List<Restaurant> restaurants;
        if ("true".equalsIgnoreCase(showAll)) {
            restaurants = restaurantService.getAllRestaurants(true);
        } else {
            restaurants = restaurantService.getRestaurantsByArea(activeArea);
        }

        List<ServiceArea> allAreas = restaurantService.getAllAreas(true);

        request.setAttribute("restaurants", restaurants);
        request.setAttribute("allAreas", allAreas);
        request.setAttribute("activeArea", activeArea);
        request.setAttribute("showAll", "true".equalsIgnoreCase(showAll));

        request.getRequestDispatcher("/WEB-INF/views/restaurants.jsp").forward(request, response);
    }
}

