package com.clinic.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Access Control Filter for Patient Portal.
 * Intercepts protected patient resources and blocks unauthenticated requests.
 */
@WebFilter(filterName = "PatientAuthFilter", urlPatterns = {
    "/patient_home.jsp",
    "/my_appointments.jsp",
    "/appointment_slip.jsp",
    "/bookAppointment",
    "/myAppointments",
    "/appointmentSlip",
    "/patient/*"
})
public class PatientAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("patient") != null);

        if (isLoggedIn) {
            // Prevent caching of sensitive patient health views
            resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            resp.setHeader("Pragma", "no-cache");
            resp.setDateHeader("Expires", 0);
            chain.doFilter(request, response);
        } else {
            req.setAttribute("errorMessage", "Session expired or unauthorized. Please log in.");
            resp.sendRedirect(req.getContextPath() + "/patient_login.jsp?msg=unauthorized");
        }
    }

    @Override
    public void destroy() {}
}
