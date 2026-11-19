package com.casestudy.servlet;

import com.casestudy.dao.VehicleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/addVehicle", "/bookService", "/updateStatus"})
public class VehicleServlet extends HttpServlet {
    private VehicleDAO dao = new VehicleDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            String role = req.getParameter("role");
            String username = req.getParameter("username");
            String pass = req.getParameter("password");

            try {
                if ("advisor".equals(role)) {
                    if (dao.loginAdvisor(username, pass)) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "advisor");
                        s.setAttribute("username", username);
                        resp.sendRedirect("advisor_dashboard.jsp");
                        return;
                    }
                } else {
                    Map<String, String> cust = dao.loginCustomer(username, pass);
                    if (cust != null) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "customer");
                        s.setAttribute("customerId", cust.get("customerId"));
                        s.setAttribute("customerName", cust.get("customerName"));
                        resp.sendRedirect("customer_home.jsp");
                        return;
                    }
                }
                req.setAttribute("error", "Invalid Customer ID / Email or Password.");
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            }
        } else if ("/register".equals(path)) {
            String id = req.getParameter("customerId");
            String name = req.getParameter("customerName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String pass = req.getParameter("password");
            try {
                if (dao.registerCustomer(id, name, email, phone, pass)) {
                    req.setAttribute("success", "Registration successful! Please login.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed.");
                    req.getRequestDispatcher("register.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Customer ID or Email already exists!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }
        } else if ("/addVehicle".equals(path)) {
            HttpSession s = req.getSession(false);
            String custId = (String) (s != null ? s.getAttribute("customerId") : null);
            if (custId == null) { resp.sendRedirect("index.jsp"); return; }
            String regNo = req.getParameter("regNumber");
            String make = req.getParameter("make");
            String model = req.getParameter("model");
            int year = Integer.parseInt(req.getParameter("year"));
            try {
                dao.addVehicle(custId, regNo, make, model, year);
                resp.sendRedirect("customer_home.jsp?msg=vehicle_added");
            } catch (Exception e) {
                resp.sendRedirect("customer_home.jsp?err=duplicate_vehicle");
            }
        } else if ("/bookService".equals(path)) {
            HttpSession s = req.getSession(false);
            String custId = (String) (s != null ? s.getAttribute("customerId") : null);
            if (custId == null) { resp.sendRedirect("index.jsp"); return; }
            int vId = Integer.parseInt(req.getParameter("vehicleId"));
            String type = req.getParameter("serviceType");
            String date = req.getParameter("date");
            String slot = req.getParameter("timeSlot");
            try {
                if (dao.bookService(custId, vId, type, date, slot)) {
                    resp.sendRedirect("customer_home.jsp?msg=service_booked");
                } else {
                    resp.sendRedirect("customer_home.jsp?err=slot_conflict");
                }
            } catch (Exception e) {
                resp.sendRedirect("customer_home.jsp?err=" + e.getMessage());
            }
        } else if ("/updateStatus".equals(path)) {
            int bId = Integer.parseInt(req.getParameter("bookingId"));
            String status = req.getParameter("status");
            try {
                dao.updateStatus(bId, status);
                resp.sendRedirect("advisor_dashboard.jsp?msg=status_updated");
            } catch (Exception e) {
                resp.sendRedirect("advisor_dashboard.jsp?err=" + e.getMessage());
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
