package com.casestudy.servlet;

import com.casestudy.dao.ExamDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/registerExam", "/addExam", "/closeRegistration"})
public class ExamServlet extends HttpServlet {
    private ExamDAO dao = new ExamDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            String role = req.getParameter("role");
            String username = req.getParameter("username");
            String pass = req.getParameter("password");
            try {
                if ("officer".equals(role)) {
                    if (dao.loginOfficer(username, pass)) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "officer");
                        s.setAttribute("username", username);
                        resp.sendRedirect("officer_dashboard.jsp");
                        return;
                    }
                } else {
                    Map<String, String> cand = dao.loginCandidate(username, pass);
                    if (cand != null) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "candidate");
                        s.setAttribute("candidateId", cand.get("candidateId"));
                        s.setAttribute("candidateName", cand.get("candidateName"));
                        s.setAttribute("rollNumber", cand.get("rollNumber"));
                        resp.sendRedirect("candidate_home.jsp");
                        return;
                    }
                }
                req.setAttribute("error", "Invalid Roll No / Candidate ID or Password.");
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            }
        } else if ("/register".equals(path)) {
            String id = req.getParameter("candidateId");
            String name = req.getParameter("candidateName");
            String roll = req.getParameter("rollNumber");
            String prog = req.getParameter("programme");
            String sem = req.getParameter("semester");
            String email = req.getParameter("email");
            String pass = req.getParameter("password");
            try {
                if (dao.registerCandidate(id, name, roll, prog, sem, email, pass)) {
                    req.setAttribute("success", "Registration successful! Please login.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed.");
                    req.getRequestDispatcher("register.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Candidate ID, Roll No, or Email already registered!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }
        } else if ("/registerExam".equals(path)) {
            HttpSession s = req.getSession(false);
            String cId = (String) (s != null ? s.getAttribute("candidateId") : null);
            if (cId == null) { resp.sendRedirect("index.jsp"); return; }
            int eId = Integer.parseInt(req.getParameter("examId"));
            try {
                if (dao.registerForExam(cId, eId)) {
                    resp.sendRedirect("candidate_home.jsp?msg=registered");
                } else {
                    resp.sendRedirect("candidate_home.jsp?err=closed_or_expired");
                }
            } catch (Exception e) {
                resp.sendRedirect("candidate_home.jsp?err=already_registered");
            }
        } else if ("/addExam".equals(path)) {
            String code = req.getParameter("subjectCode");
            String name = req.getParameter("subjectName");
            String date = req.getParameter("examDate");
            String session = req.getParameter("session");
            String deadline = req.getParameter("deadline");
            try {
                dao.addExam(code, name, date, session, deadline);
                resp.sendRedirect("officer_dashboard.jsp?msg=exam_added");
            } catch (Exception e) {
                resp.sendRedirect("officer_dashboard.jsp?err=" + e.getMessage());
            }
        } else if ("/closeRegistration".equals(path)) {
            int examId = Integer.parseInt(req.getParameter("examId"));
            try {
                dao.closeRegistration(examId);
                resp.sendRedirect("officer_dashboard.jsp?msg=registration_closed");
            } catch (Exception e) {
                resp.sendRedirect("officer_dashboard.jsp?err=" + e.getMessage());
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
