package com.casestudy.servlet;

import com.casestudy.dao.DonationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/recordDonation", "/updateDonation"})
public class DonationServlet extends HttpServlet {
    private DonationDAO dao = new DonationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            String role = req.getParameter("role");
            String username = req.getParameter("username");
            String pass = req.getParameter("password");
            try {
                if ("coordinator".equals(role)) {
                    if (dao.loginCoordinator(username, pass)) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "coordinator");
                        s.setAttribute("username", username);
                        resp.sendRedirect("coordinator_dashboard.jsp");
                        return;
                    }
                } else {
                    Map<String, String> d = dao.loginDonor(username, pass);
                    if (d != null) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "donor");
                        s.setAttribute("donorId", d.get("donorId"));
                        s.setAttribute("donorName", d.get("donorName"));
                        resp.sendRedirect("donor_home.jsp");
                        return;
                    }
                }
                req.setAttribute("error", "Invalid ID or Password.");
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            }
        } else if ("/register".equals(path)) {
            String id = req.getParameter("donorId");
            String name = req.getParameter("donorName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String pass = req.getParameter("password");
            try {
                if (dao.registerDonor(id, name, email, phone, pass)) {
                    req.setAttribute("success", "Registration successful! Please login.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed.");
                    req.getRequestDispatcher("register.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Donor ID or Email already exists!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }
        } else if ("/recordDonation".equals(path)) {
            HttpSession s = req.getSession(false);
            String dId = (String) (s != null ? s.getAttribute("donorId") : null);
            if (dId == null) { resp.sendRedirect("index.jsp"); return; }
            int cId = Integer.parseInt(req.getParameter("campaignId"));
            double amt = Double.parseDouble(req.getParameter("amount"));
            String refNo = req.getParameter("referenceNumber");
            try {
                dao.recordDonation(dId, cId, amt, refNo);
                resp.sendRedirect("donor_home.jsp?msg=recorded");
            } catch (Exception e) {
                resp.sendRedirect("donor_home.jsp?err=duplicate_ref");
            }
        } else if ("/updateDonation".equals(path)) {
            int dId = Integer.parseInt(req.getParameter("donationId"));
            String status = req.getParameter("status");
            try {
                dao.updateDonationStatus(dId, status);
                resp.sendRedirect("coordinator_dashboard.jsp?msg=status_updated");
            } catch (Exception e) {
                resp.sendRedirect("coordinator_dashboard.jsp?err=" + e.getMessage());
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
