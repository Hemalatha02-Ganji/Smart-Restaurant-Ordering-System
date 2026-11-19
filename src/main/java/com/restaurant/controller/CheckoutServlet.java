package com.restaurant.controller;

import com.restaurant.model.Cart;
import com.restaurant.model.Restaurant;
import com.restaurant.model.RestaurantTable;
import com.restaurant.service.CartService;
import com.restaurant.service.ReservationService;
import com.restaurant.service.RestaurantService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private final CartService cartService = new CartService();
    private final RestaurantService restaurantService = new RestaurantService();
    private final ReservationService reservationService = new ReservationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Cart cart = cartService.getCart(session);

        if (cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=empty");
            return;
        }

        String typeParam = request.getParameter("type");
        if (typeParam != null) {
            cart.setOrderType(typeParam);
        }

        Restaurant restaurant = restaurantService.getRestaurantById(cart.getRestaurantId());
        List<RestaurantTable> tables = reservationService.getTablesByRestaurant(cart.getRestaurantId());

        String customerName = (String) session.getAttribute("customerName");
        String customerArea = (String) session.getAttribute("customerArea");

        request.setAttribute("cart", cart);
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("tables", tables);
        request.setAttribute("customerName", customerName != null ? customerName : "");
        request.setAttribute("customerArea", customerArea != null ? customerArea : "Mylavaram");

        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }
}

