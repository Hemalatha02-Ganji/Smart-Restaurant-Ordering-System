package com.restaurant.controller;

import com.google.gson.JsonObject;
import com.restaurant.model.Cart;
import com.restaurant.service.CartService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("clear".equalsIgnoreCase(action)) {
            cartService.clearCart(session);
            sendCartResponse(request, response, true, "Cart cleared successfully");
            return;
        } else if ("remove".equalsIgnoreCase(action)) {
            try {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                cartService.removeItem(session, itemId);
                sendCartResponse(request, response, true, "Item removed from cart");
                return;
            } catch (Exception e) {
                sendCartResponse(request, response, false, "Invalid item ID");
                return;
            }
        }

        // View Cart
        Cart cart = cartService.getCart(session);
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("add".equalsIgnoreCase(action)) {
            try {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                int qty = 1;
                if (request.getParameter("quantity") != null) {
                    qty = Math.max(1, Integer.parseInt(request.getParameter("quantity")));
                }

                boolean forceClear = "true".equalsIgnoreCase(request.getParameter("forceClear"));
                if (forceClear) {
                    cartService.clearCart(session);
                }

                CartService.AddResult result = cartService.addToCart(session, itemId, qty);

                if (result == CartService.AddResult.SUCCESS) {
                    sendCartResponse(request, response, true, "Item added to cart");
                } else if (result == CartService.AddResult.DIFFERENT_RESTAURANT) {
                    Cart cart = cartService.getCart(session);
                    if (isAjax(request)) {
                        response.setContentType("application/json");
                        JsonObject json = new JsonObject();
                        json.addProperty("success", false);
                        json.addProperty("conflict", true);
                        json.addProperty("currentRestaurant", cart.getRestaurantName());
                        json.addProperty("message", "Your cart already contains items from " + cart.getRestaurantName() +
                                ". Would you like to discard the previous items and start a new order?");
                        response.getWriter().write(json.toString());
                    } else {
                        response.sendRedirect(request.getContextPath() + "/cart?error=conflict");
                    }
                } else if (result == CartService.AddResult.ITEM_UNAVAILABLE) {
                    sendCartResponse(request, response, false, "This food item is currently out of stock.");
                } else {
                    sendCartResponse(request, response, false, "Food item not found.");
                }
            } catch (Exception e) {
                sendCartResponse(request, response, false, "Failed to add item: " + e.getMessage());
            }
        } else if ("update".equalsIgnoreCase(action)) {
            try {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                int qty = Integer.parseInt(request.getParameter("quantity"));
                cartService.updateQuantity(session, itemId, qty);
                sendCartResponse(request, response, true, "Cart updated");
            } catch (Exception e) {
                sendCartResponse(request, response, false, "Failed to update quantity");
            }
        } else if ("set-type".equalsIgnoreCase(action)) {
            String orderType = request.getParameter("orderType");
            cartService.setOrderType(session, orderType);
            sendCartResponse(request, response, true, "Order type updated");
        } else {
            doGet(request, response);
        }
    }

    private void sendCartResponse(HttpServletRequest req, HttpServletResponse res, boolean success, String msg) throws IOException {
        Cart cart = cartService.getCart(req.getSession());
        if (isAjax(req)) {
            res.setContentType("application/json");
            JsonObject json = new JsonObject();
            json.addProperty("success", success);
            json.addProperty("message", msg);
            json.addProperty("totalCount", cart.getTotalCount());
            json.addProperty("subtotal", cart.getSubtotal().toString());
            json.addProperty("gstAmount", cart.getGstAmount().toString());
            json.addProperty("deliveryCharge", cart.getDeliveryCharge().toString());
            json.addProperty("grandTotal", cart.getGrandTotal().toString());
            json.addProperty("restaurantName", cart.getRestaurantName());
            res.getWriter().write(json.toString());
        } else {
            res.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    private boolean isAjax(HttpServletRequest request) {
        String header = request.getHeader("X-Requested-With");
        return "XMLHttpRequest".equalsIgnoreCase(header) || "true".equalsIgnoreCase(request.getParameter("ajax"));
    }
}

