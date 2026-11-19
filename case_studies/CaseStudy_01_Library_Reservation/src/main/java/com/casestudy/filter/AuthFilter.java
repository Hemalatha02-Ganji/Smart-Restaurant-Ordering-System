package com.casestudy.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/member_home.jsp", "/librarian_dashboard.jsp"})
public class AuthFilter implements Filter {
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getServletPath();
        if (session == null || session.getAttribute("role") == null) {
            res.sendRedirect("index.jsp?err=auth_required");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (path.contains("librarian") && !"librarian".equals(role)) {
            res.sendRedirect("index.jsp?err=access_denied");
            return;
        }
        if (path.contains("member") && !"member".equals(role)) {
            res.sendRedirect("index.jsp?err=access_denied");
            return;
        }
        chain.doFilter(request, response);
    }
}
