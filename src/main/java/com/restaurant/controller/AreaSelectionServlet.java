package com.restaurant.controller;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AreaSelectionServlet", urlPatterns = {"/select-area"})
public class AreaSelectionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String customerName = request.getParameter("customerName");
        String customerArea = request.getParameter("customerArea");
        String redirectUrl = request.getParameter("redirectUrl");

        HttpSession session = request.getSession();

        if (customerName != null && !customerName.trim().isEmpty()) {
            session.setAttribute("customerName", customerName.trim());
        } else if (session.getAttribute("customerName") == null) {
            session.setAttribute("customerName", "Guest Foodie");
        }

        if (customerArea != null && !customerArea.trim().isEmpty()) {
            session.setAttribute("customerArea", customerArea.trim());
        }

        // Support AJAX requests
        String isAjax = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(isAjax) || "true".equalsIgnoreCase(request.getParameter("ajax"))) {
            response.setContentType("application/json");
            JsonObject json = new JsonObject();
            json.addProperty("success", true);
            json.addProperty("customerName", (String) session.getAttribute("customerName"));
            json.addProperty("customerArea", (String) session.getAttribute("customerArea"));
            response.getWriter().write(json.toString());
            return;
        }

        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}

