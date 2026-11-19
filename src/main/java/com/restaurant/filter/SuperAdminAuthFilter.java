package com.restaurant.filter;

import com.restaurant.model.Admin;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "SuperAdminAuthFilter", urlPatterns = {"/superadmin/*"})
public class SuperAdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("loggedAdmin") : null;

        if (admin == null || !admin.isSuperAdmin()) {
            res.sendRedirect(req.getContextPath() + "/admin/login?error=superadmin_required");
            return;
        }

        chain.doFilter(request, response);
    }
}

