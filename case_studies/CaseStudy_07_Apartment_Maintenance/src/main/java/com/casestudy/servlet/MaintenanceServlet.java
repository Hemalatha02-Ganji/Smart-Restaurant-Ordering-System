package com.casestudy.servlet;

import com.casestudy.dao.MaintenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/submitRequest", "/updateRequest"})
public class MaintenanceServlet extends HttpServlet {
    private MaintenanceDAO dao = new MaintenanceDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            String role = req.getParameter("role");
            String username = req.getParameter("username");
            String pass = req.getParameter("password");

            try {
                if ("manager".equals(role)) {
                    if (dao.loginManager(username, pass)) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "manager");
                        s.setAttribute("username", username);
                        resp.sendRedirect("manager_dashboard.jsp");
                        return;
                    }
                } else {
                    Map<String, String> res = dao.loginResident(username, pass);
                    if (res != null) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "resident");
                        s.setAttribute("residentId", res.get("residentId"));
                        s.setAttribute("residentName", res.get("residentName"));
                        s.setAttribute("apartmentNumber", res.get("apartmentNumber"));
                        resp.sendRedirect("resident_home.jsp");
                        return;
                    }
                }
                req.setAttribute("error", "Invalid ID or password.");
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            }
        } else if ("/register".equals(path)) {
            String id = req.getParameter("residentId");
            String name = req.getParameter("residentName");
            String flat = req.getParameter("apartmentNumber");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            String pass = req.getParameter("password");
            try {
                if (dao.registerResident(id, name, flat, phone, email, pass)) {
                    req.setAttribute("success", "Registration successful! Please login.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed.");
                    req.getRequestDispatcher("register.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Resident ID or Email already exists!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }
        } else if ("/submitRequest".equals(path)) {
            HttpSession s = req.getSession(false);
            String rId = (String) (s != null ? s.getAttribute("residentId") : null);
            if (rId == null) { resp.sendRedirect("index.jsp"); return; }
            String cat = req.getParameter("category");
            String desc = req.getParameter("description");
            String pri = req.getParameter("priority");
            try {
                dao.submitRequest(rId, cat, desc, pri);
                resp.sendRedirect("resident_home.jsp?msg=submitted");
            } catch (Exception e) {
                resp.sendRedirect("resident_home.jsp?err=" + e.getMessage());
            }
        } else if ("/updateRequest".equals(path)) {
            int reqId = Integer.parseInt(req.getParameter("requestId"));
            String status = req.getParameter("status");
            String remarks = req.getParameter("remarks");
            try {
                dao.updateStatusAndRemarks(reqId, status, remarks);
                resp.sendRedirect("manager_dashboard.jsp?msg=updated");
            } catch (Exception e) {
                resp.sendRedirect("manager_dashboard.jsp?err=" + e.getMessage());
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("/logout".equals(req.getServletPath())) {
            HttpSession s = req.getSession(false);
            if (s != null) s.invalidate();
            resp.sendRedirect("index.jsp?msg=logged_out");
        }
    }
}
