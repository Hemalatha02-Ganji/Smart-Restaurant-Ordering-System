package com.restaurant.controller;

import com.restaurant.model.Invoice;
import com.restaurant.model.Order;
import com.restaurant.service.BillingService;
import com.restaurant.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "InvoiceServlet", urlPatterns = {"/invoice"})
public class InvoiceServlet extends HttpServlet {

    private final BillingService billingService = new BillingService();
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdParam = request.getParameter("orderId");
        String codeParam = request.getParameter("code");
        String numParam = request.getParameter("num");

        Invoice invoice = null;

        if (numParam != null && !numParam.trim().isEmpty()) {
            invoice = billingService.getInvoiceByNumber(numParam.trim());
        } else if (orderIdParam != null && !orderIdParam.trim().isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdParam);
                invoice = billingService.getInvoiceByOrderId(orderId);
            } catch (NumberFormatException ignored) {}
        } else if (codeParam != null && !codeParam.trim().isEmpty()) {
            Order order = orderService.getOrderByCode(codeParam.trim());
            if (order != null) {
                invoice = billingService.getInvoiceByOrderId(order.getOrderId());
            }
        }

        if (invoice == null) {
            response.sendRedirect(request.getContextPath() + "/home?error=invoice_not_found");
            return;
        }

        request.setAttribute("invoice", invoice);
        request.getRequestDispatcher("/WEB-INF/views/invoice.jsp").forward(request, response);
    }
}

