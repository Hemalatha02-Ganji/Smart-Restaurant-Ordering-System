package com.restaurant.service;

import com.restaurant.dao.CategoryDAO;
import com.restaurant.dao.MenuItemDAO;
import com.restaurant.model.Category;
import com.restaurant.model.MenuItem;

import java.util.List;

public class MenuService {

    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    public List<MenuItem> getMenuByRestaurant(int restaurantId, boolean onlyAvailable) {
        return menuItemDAO.getByRestaurant(restaurantId, onlyAvailable);
    }

    public List<MenuItem> getMenuByCategory(int restaurantId, int categoryId) {
        return menuItemDAO.getByRestaurantAndCategory(restaurantId, categoryId);
    }

    public List<MenuItem> searchMenuItems(int restaurantId, String query) {
        return menuItemDAO.searchItems(restaurantId, query);
    }

    public MenuItem getItemById(int itemId) {
        return menuItemDAO.getById(itemId);
    }

    public boolean createMenuItem(MenuItem item) {
        return menuItemDAO.create(item);
    }

    public boolean updateMenuItem(MenuItem item) {
        return menuItemDAO.update(item);
    }

    public boolean toggleAvailability(int itemId, int restaurantId, boolean isAvailable) {
        return menuItemDAO.toggleAvailability(itemId, restaurantId, isAvailable);
    }

    public boolean deleteMenuItem(int itemId, int restaurantId) {
        return menuItemDAO.delete(itemId, restaurantId);
    }

    public List<Category> getAllCategories() {
        return categoryDAO.getAll();
    }
}

