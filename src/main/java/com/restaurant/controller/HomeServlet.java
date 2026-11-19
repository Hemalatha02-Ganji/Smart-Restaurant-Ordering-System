package com.restaurant.controller;

import com.restaurant.model.Category;
import com.restaurant.model.Restaurant;
import com.restaurant.model.ServiceArea;
import com.restaurant.service.MenuService;
import com.restaurant.service.RestaurantService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    private final RestaurantService restaurantService = new RestaurantService();
    private final MenuService menuService = new MenuService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Customer Access: No login or registration required
        String customerName = (String) session.getAttribute("customerName");
        String customerArea = (String) session.getAttribute("customerArea");

        // If area not set, show the welcome modal on homepage
        boolean promptArea = (customerArea == null || customerArea.trim().isEmpty());
        if (promptArea) {
            customerArea = "Mylavaram"; // Default area until selected
        }

        // Retrieve active restaurants serving the selected area (case-insensitive)
        List<Restaurant> restaurants = restaurantService.getRestaurantsByArea(customerArea);
        List<ServiceArea> allAreas = restaurantService.getAllAreas(true);
        List<Category> categories = menuService.getAllCategories();

        request.setAttribute("restaurants", restaurants);
        request.setAttribute("allAreas", allAreas);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedArea", customerArea);
        request.setAttribute("customerName", customerName != null ? customerName : "");
        request.setAttribute("promptArea", promptArea);

        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }
}

