package com.restaurant.service;

import com.restaurant.dao.MenuItemDAO;
import com.restaurant.dao.RestaurantDAO;
import com.restaurant.model.Cart;
import com.restaurant.model.MenuItem;
import com.restaurant.model.Restaurant;
import jakarta.servlet.http.HttpSession;

public class CartService {

    private static final String CART_SESSION_KEY = "cart";
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final RestaurantDAO restaurantDAO = new RestaurantDAO();

    public Cart getCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute(CART_SESSION_KEY);
        if (cart == null) {
            cart = new Cart();
            session.setAttribute(CART_SESSION_KEY, cart);
        }
        return cart;
    }

    public enum AddResult {
        SUCCESS,
        ITEM_NOT_FOUND,
        ITEM_UNAVAILABLE,
        DIFFERENT_RESTAURANT
    }

    public AddResult addToCart(HttpSession session, int itemId, int quantity) {
        MenuItem dbItem = menuItemDAO.getById(itemId);
        if (dbItem == null) {
            return AddResult.ITEM_NOT_FOUND;
        }
        if (!dbItem.isAvailable()) {
            return AddResult.ITEM_UNAVAILABLE;
        }

        Cart cart = getCart(session);
        if (!cart.isEmpty() && cart.getRestaurantId() != null && cart.getRestaurantId() != dbItem.getRestaurantId()) {
            return AddResult.DIFFERENT_RESTAURANT;
        }

        String restName = dbItem.getRestaurantName();
        if (restName == null || restName.isEmpty()) {
            Restaurant r = restaurantDAO.getById(dbItem.getRestaurantId());
            if (r != null) {
                restName = r.getName();
            }
        }

        cart.addItem(dbItem, quantity, restName);
        session.setAttribute(CART_SESSION_KEY, cart);
        return AddResult.SUCCESS;
    }

    public void updateQuantity(HttpSession session, int itemId, int quantity) {
        Cart cart = getCart(session);
        cart.updateQuantity(itemId, quantity);
        session.setAttribute(CART_SESSION_KEY, cart);
    }

    public void removeItem(HttpSession session, int itemId) {
        Cart cart = getCart(session);
        cart.removeItem(itemId);
        session.setAttribute(CART_SESSION_KEY, cart);
    }

    public void clearCart(HttpSession session) {
        Cart cart = getCart(session);
        cart.clear();
        session.setAttribute(CART_SESSION_KEY, cart);
    }

    public void setOrderType(HttpSession session, String orderType) {
        Cart cart = getCart(session);
        cart.setOrderType(orderType);
        session.setAttribute(CART_SESSION_KEY, cart);
    }
}

