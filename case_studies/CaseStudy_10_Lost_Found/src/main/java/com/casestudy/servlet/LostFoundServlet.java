package com.casestudy.servlet;

import com.casestudy.dao.LostFoundDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/reportItem", "/resolveReport", "/hideReport"})
public class LostFoundServlet extends HttpServlet {
    private LostFoundDAO dao = new LostFoundDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            String role = req.getParameter("role");
            String username = req.getParameter("username");
            String pass = req.getParameter("password");
            try {
                if ("moderator".equals(role)) {
                    if (dao.loginModerator(username, pass)) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "moderator");
                        s.setAttribute("username", username);
                        resp.sendRedirect("moderator_dashboard.jsp");
                        return;
                    }
                } else {
                    Map<String, String> stud = dao.loginStudent(username, pass);
                    if (stud != null) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "student");
                        s.setAttribute("studentId", stud.get("studentId"));
                        s.setAttribute("studentName", stud.get("studentName"));
                        resp.sendRedirect("student_home.jsp");
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
            String id = req.getParameter("studentId");
            String name = req.getParameter("studentName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String pass = req.getParameter("password");
            try {
                if (dao.registerStudent(id, name, email, phone, pass)) {
                    req.setAttribute("success", "Registration successful! Please login.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed.");
                    req.getRequestDispatcher("register.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Student ID or Email already exists!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }
        } else if ("/reportItem".equals(path)) {
            HttpSession s = req.getSession(false);
            String studId = (String) (s != null ? s.getAttribute("studentId") : null);
            if (studId == null) { resp.sendRedirect("index.jsp"); return; }
            String name = req.getParameter("itemName");
            String desc = req.getParameter("description");
            String cat = req.getParameter("category");
            String loc = req.getParameter("location");
            String date = req.getParameter("itemDate");
            String type = req.getParameter("reportType");
            try {
                dao.reportItem(studId, name, desc, cat, loc, date, type);
                resp.sendRedirect("student_home.jsp?msg=reported");
            } catch (Exception e) {
                resp.sendRedirect("student_home.jsp?err=" + e.getMessage());
            }
        } else if ("/resolveReport".equals(path)) {
            HttpSession s = req.getSession(false);
            String studId = (String) (s != null ? s.getAttribute("studentId") : null);
            if (studId == null) { resp.sendRedirect("index.jsp"); return; }
            int id = Integer.parseInt(req.getParameter("reportId"));
            try {
                dao.markResolved(id, studId);
                resp.sendRedirect("student_home.jsp?msg=resolved");
            } catch (Exception e) {
                resp.sendRedirect("student_home.jsp?err=" + e.getMessage());
            }
        } else if ("/hideReport".equals(path)) {
            int id = Integer.parseInt(req.getParameter("reportId"));
            try {
                dao.hideReport(id);
                resp.sendRedirect("moderator_dashboard.jsp?msg=hidden");
            } catch (Exception e) {
                resp.sendRedirect("moderator_dashboard.jsp?err=" + e.getMessage());
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
