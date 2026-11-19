package com.restaurant.controller;

import com.restaurant.model.Address;
import com.restaurant.model.Cart;
import com.restaurant.model.Order;
import com.restaurant.service.CartService;
import com.restaurant.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "OrderServlet", urlPatterns = {"/place-order"})
public class OrderServlet extends HttpServlet {

    private final CartService cartService = new CartService();
    private final OrderService orderService = new OrderService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Cart cart = cartService.getCart(session);

        if (cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=empty");
            return;
        }

        String customerName = request.getParameter("customerName");
        String customerMobile = request.getParameter("customerMobile");
        String customerArea = request.getParameter("customerArea");
        String orderType = request.getParameter("orderType");
        String specialNotes = request.getParameter("specialNotes");

        // Validate customer data
        if (customerName == null || customerName.trim().isEmpty() ||
            customerMobile == null || customerMobile.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Customer name and mobile number are mandatory.");
            request.getRequestDispatcher("/checkout").forward(request, response);
            return;
        }

        // Save customer details in session for repeat visits
        session.setAttribute("customerName", customerName.trim());
        if (customerArea != null && !customerArea.trim().isEmpty()) {
            session.setAttribute("customerArea", customerArea.trim());
        }

        Address address = null;
        if ("HOME_DELIVERY".equalsIgnoreCase(orderType)) {
            String houseNo = request.getParameter("houseNo");
            String street = request.getParameter("street");
            String landmark = request.getParameter("landmark");
            String instructions = request.getParameter("instructions");

            if (houseNo == null || houseNo.trim().isEmpty() || street == null || street.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Delivery house number and street are required for Home Delivery.");
                request.getRequestDispatcher("/checkout").forward(request, response);
                return;
            }

            address = new Address(houseNo.trim(), street.trim(), landmark, customerArea, customerMobile.trim(), instructions);
        } else {
            // Dine-In order
            String tableSelection = request.getParameter("tableNumber");
            if (tableSelection != null && !tableSelection.isEmpty()) {
                specialNotes = (specialNotes != null && !specialNotes.isEmpty())
                        ? specialNotes + " [Dine-In " + tableSelection + "]"
                        : "[Dine-In " + tableSelection + "]";
            }
        }

        try {
            Order placedOrder = orderService.placeOrder(
                    cart, customerName, customerMobile, customerArea,
                    orderType, address, specialNotes
            );

            // Clear cart upon successful order creation
            cartService.clearCart(session);

            // Redirect to Order Confirmation page with unique order code
            response.sendRedirect(request.getContextPath() + "/order-confirmation?code=" + placedOrder.getOrderCode());

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Could not complete order: " + e.getMessage());
            request.getRequestDispatcher("/checkout").forward(request, response);
        }
    }
}

