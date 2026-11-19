package com.casestudy.servlet;

import com.casestudy.dao.HostelDAO;
import com.casestudy.model.Applicant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/submitApplication", "/allocateRoom", "/rejectApplication"})
public class HostelServlet extends HttpServlet {
    private HostelDAO dao = new HostelDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            String role = req.getParameter("role");
            String username = req.getParameter("username");
            String pass = req.getParameter("password");

            try {
                if ("warden".equals(role)) {
                    if (dao.loginWarden(username, pass)) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "warden");
                        s.setAttribute("username", username);
                        resp.sendRedirect("warden_dashboard.jsp");
                        return;
                    }
                } else {
                    Applicant a = dao.loginApplicant(username, pass);
                    if (a != null) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "applicant");
                        s.setAttribute("applicant", a);
                        resp.sendRedirect("applicant_home.jsp");
                        return;
                    }
                }
                req.setAttribute("error", "Invalid Roll Number or Password.");
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            }
        } else if ("/register".equals(path)) {
            Applicant a = new Applicant(
                req.getParameter("rollNumber"),
                req.getParameter("applicationNumber"),
                req.getParameter("studentName"),
                req.getParameter("year"),
                req.getParameter("branch"),
                req.getParameter("phone"),
                req.getParameter("preferredHostel"),
                req.getParameter("password")
            );
            try {
                if (dao.registerApplicant(a)) {
                    req.setAttribute("success", "Registration successful! Please login.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed. Try again.");
                    req.getRequestDispatcher("register.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Roll Number or Application Number already exists!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }
        } else if ("/submitApplication".equals(path)) {
            HttpSession s = req.getSession(false);
            Applicant a = (Applicant) (s != null ? s.getAttribute("applicant") : null);
            if (a == null) { resp.sendRedirect("index.jsp"); return; }
            String year = req.getParameter("academicYear");
            try {
                if (dao.submitApplication(a.getRollNumber(), year)) {
                    resp.sendRedirect("applicant_home.jsp?msg=applied");
                } else {
                    resp.sendRedirect("applicant_home.jsp?err=duplicate");
                }
            } catch (Exception e) {
                resp.sendRedirect("applicant_home.jsp?err=" + e.getMessage());
            }
        } else if ("/allocateRoom".equals(path)) {
            int appId = Integer.parseInt(req.getParameter("applicationId"));
            int roomId = Integer.parseInt(req.getParameter("roomId"));
            try {
                if (dao.allocateRoom(appId, roomId)) {
                    resp.sendRedirect("warden_dashboard.jsp?msg=allocated");
                } else {
                    resp.sendRedirect("warden_dashboard.jsp?err=room_full");
                }
            } catch (Exception e) {
                resp.sendRedirect("warden_dashboard.jsp?err=" + e.getMessage());
            }
        } else if ("/rejectApplication".equals(path)) {
            int appId = Integer.parseInt(req.getParameter("applicationId"));
            try {
                dao.rejectApplication(appId);
                resp.sendRedirect("warden_dashboard.jsp?msg=rejected");
            } catch (Exception e) {
                resp.sendRedirect("warden_dashboard.jsp?err=" + e.getMessage());
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
