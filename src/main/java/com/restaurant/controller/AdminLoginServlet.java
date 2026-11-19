package com.restaurant.controller;

import com.restaurant.model.Admin;
import com.restaurant.service.AdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/admin/login", "/admin/logout"})
public class AdminLoginServlet extends HttpServlet {

    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        if ("/admin/logout".equalsIgnoreCase(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("loggedAdmin");
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/admin/login?logged_out=true");
            return;
        }

        // Check if already logged in
        HttpSession session = request.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("loggedAdmin") : null;
        if (admin != null) {
            if (admin.isSuperAdmin()) {
                response.sendRedirect(request.getContextPath() + "/superadmin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
            return;
        }

        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        Admin admin = adminService.authenticate(username.trim(), password.trim());
        if (admin != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loggedAdmin", admin);

            if (admin.isSuperAdmin()) {
                response.sendRedirect(request.getContextPath() + "/superadmin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
        } else {
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }
}

