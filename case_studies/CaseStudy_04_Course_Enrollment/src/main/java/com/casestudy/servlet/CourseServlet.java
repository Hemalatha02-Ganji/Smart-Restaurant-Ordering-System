package com.casestudy.servlet;

import com.casestudy.dao.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/enrollCourse", "/addCourse"})
public class CourseServlet extends HttpServlet {
    private CourseDAO dao = new CourseDAO();

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
                    Map<String, String> lrn = dao.loginLearner(username, pass);
                    if (lrn != null) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "learner");
                        s.setAttribute("learnerId", lrn.get("learnerId"));
                        s.setAttribute("learnerName", lrn.get("learnerName"));
                        resp.sendRedirect("learner_home.jsp");
                        return;
                    }
                }
                req.setAttribute("error", "Invalid Learner ID / Email or Password.");
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            }
        } else if ("/register".equals(path)) {
            String id = req.getParameter("learnerId");
            String name = req.getParameter("learnerName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String qual = req.getParameter("qualification");
            String pass = req.getParameter("password");

            try {
                if (dao.registerLearner(id, name, email, phone, qual, pass)) {
                    req.setAttribute("success", "Registration successful! Please sign in.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed. Try again.");
                    req.getRequestDispatcher("register.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Learner ID or Email already exists!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }
        } else if ("/enrollCourse".equals(path)) {
            HttpSession s = req.getSession(false);
            String lrnId = (String) (s != null ? s.getAttribute("learnerId") : null);
            if (lrnId == null) { resp.sendRedirect("index.jsp"); return; }
            int cId = Integer.parseInt(req.getParameter("courseId"));

            try {
                if (dao.enrollCourse(lrnId, cId)) {
                    resp.sendRedirect("learner_home.jsp?msg=enrolled");
                } else {
                    resp.sendRedirect("learner_home.jsp?err=no_seats");
                }
            } catch (Exception e) {
                resp.sendRedirect("learner_home.jsp?err=duplicate_or_error");
            }
        } else if ("/addCourse".equals(path)) {
            String title = req.getParameter("title");
            String duration = req.getParameter("duration");
            double fee = Double.parseDouble(req.getParameter("fee"));
            int seats = Integer.parseInt(req.getParameter("seats"));

            try {
                dao.addCourse(title, duration, fee, seats);
                resp.sendRedirect("coordinator_dashboard.jsp?msg=course_added");
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
