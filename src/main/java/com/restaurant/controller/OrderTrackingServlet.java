package com.restaurant.controller;

import com.restaurant.model.Order;
import com.restaurant.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "OrderTrackingServlet", urlPatterns = {"/track-order"})
public class OrderTrackingServlet extends HttpServlet {

    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderCode = request.getParameter("orderCode");
        String mobile = request.getParameter("mobile");

        if (orderCode != null && !orderCode.trim().isEmpty() && mobile != null && !mobile.trim().isEmpty()) {
            Order order = orderService.trackOrder(orderCode.trim(), mobile.trim());
            if (order != null) {
                request.setAttribute("order", order);
            } else {
                request.setAttribute("notFound", true);
                request.setAttribute("searchedCode", orderCode);
                request.setAttribute("searchedMobile", mobile);
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/track-order.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

