package com.casestudy.servlet;

import com.casestudy.dao.InternshipDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/applyInternship", "/publishInternship", "/updateApplication"})
public class InternshipServlet extends HttpServlet {
    private InternshipDAO dao = new InternshipDAO();

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
                    Map<String, String> stud = dao.loginStudent(username, pass);
                    if (stud != null) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "student");
                        s.setAttribute("rollNumber", stud.get("rollNumber"));
                        s.setAttribute("studentName", stud.get("studentName"));
                        resp.sendRedirect("student_home.jsp");
                        return;
                    }
                }
                req.setAttribute("error", "Invalid Roll No / Email or Password.");
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            }
        } else if ("/register".equals(path)) {
            String roll = req.getParameter("rollNumber");
            String name = req.getParameter("studentName");
            String branch = req.getParameter("branch");
            String sem = req.getParameter("semester");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String pass = req.getParameter("password");
            try {
                if (dao.registerStudent(roll, name, branch, sem, email, phone, pass)) {
                    req.setAttribute("success", "Registration successful! Please sign in.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed.");
                    req.getRequestDispatcher("register.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Roll Number or Email already registered!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }
        } else if ("/applyInternship".equals(path)) {
            HttpSession s = req.getSession(false);
            String roll = (String) (s != null ? s.getAttribute("rollNumber") : null);
            if (roll == null) { resp.sendRedirect("index.jsp"); return; }
            int internId = Integer.parseInt(req.getParameter("internshipId"));
            try {
                if (dao.applyForInternship(internId, roll)) {
                    resp.sendRedirect("student_home.jsp?msg=applied");
                } else {
                    resp.sendRedirect("student_home.jsp?err=deadline_passed");
                }
            } catch (Exception e) {
                resp.sendRedirect("student_home.jsp?err=already_applied");
            }
        } else if ("/publishInternship".equals(path)) {
            String org = req.getParameter("organisation");
            String role = req.getParameter("role");
            String elig = req.getParameter("eligibility");
            String loc = req.getParameter("location");
            String stip = req.getParameter("stipend");
            String date = req.getParameter("lastDate");
            try {
                dao.publishInternship(org, role, elig, loc, stip, date);
                resp.sendRedirect("coordinator_dashboard.jsp?msg=published");
            } catch (Exception e) {
                resp.sendRedirect("coordinator_dashboard.jsp?err=" + e.getMessage());
            }
        } else if ("/updateApplication".equals(path)) {
            int appId = Integer.parseInt(req.getParameter("appId"));
            String status = req.getParameter("status");
            String remarks = req.getParameter("remarks");
            try {
                dao.updateStatusAndRemarks(appId, status, remarks);
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
