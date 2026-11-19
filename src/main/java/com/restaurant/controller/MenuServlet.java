package com.restaurant.controller;

import com.restaurant.model.Category;
import com.restaurant.model.MenuItem;
import com.restaurant.model.Restaurant;
import com.restaurant.service.MenuService;
import com.restaurant.service.RestaurantService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MenuServlet", urlPatterns = {"/menu"})
public class MenuServlet extends HttpServlet {

    private final RestaurantService restaurantService = new RestaurantService();
    private final MenuService menuService = new MenuService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/restaurants");
            return;
        }

        int restaurantId;
        try {
            restaurantId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/restaurants");
            return;
        }

        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/restaurants");
            return;
        }

        String catParam = request.getParameter("category");
        String searchQuery = request.getParameter("q");
        String foodType = request.getParameter("type"); // 'VEG' or 'NON_VEG'

        List<MenuItem> menuItems;
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            menuItems = menuService.searchMenuItems(restaurantId, searchQuery.trim());
        } else if (catParam != null && !catParam.trim().isEmpty()) {
            try {
                int catId = Integer.parseInt(catParam);
                menuItems = menuService.getMenuByCategory(restaurantId, catId);
            } catch (NumberFormatException e) {
                menuItems = menuService.getMenuByRestaurant(restaurantId, false);
            }
        } else {
            menuItems = menuService.getMenuByRestaurant(restaurantId, false);
        }

        // Apply veg/non-veg filter if selected
        if ("VEG".equalsIgnoreCase(foodType)) {
            menuItems = menuItems.stream().filter(MenuItem::isVeg).toList();
        } else if ("NON_VEG".equalsIgnoreCase(foodType)) {
            menuItems = menuItems.stream().filter(m -> !m.isVeg()).toList();
        }

        List<Category> categories = menuService.getAllCategories();

        request.setAttribute("restaurant", restaurant);
        request.setAttribute("menuItems", menuItems);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", catParam);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("foodType", foodType);

        request.getRequestDispatcher("/WEB-INF/views/menu.jsp").forward(request, response);
    }
}

