package com.casestudy.servlet;

import com.casestudy.dao.EventDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/registerEvent", "/addEvent", "/markAttendance"})
public class EventServlet extends HttpServlet {
    private EventDAO dao = new EventDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            String role = req.getParameter("role");
            String username = req.getParameter("username");
            String pass = req.getParameter("password");
            try {
                if ("organizer".equals(role)) {
                    if (dao.loginOrganizer(username, pass)) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "organizer");
                        s.setAttribute("username", username);
                        resp.sendRedirect("organizer_dashboard.jsp");
                        return;
                    }
                } else {
                    Map<String, String> part = dao.loginParticipant(username, pass);
                    if (part != null) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "participant");
                        s.setAttribute("participantId", part.get("participantId"));
                        s.setAttribute("participantName", part.get("participantName"));
                        resp.sendRedirect("participant_home.jsp");
                        return;
                    }
                }
                req.setAttribute("error", "Invalid Credentials. Try again.");
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            }
        } else if ("/register".equals(path)) {
            String id = req.getParameter("participantId");
            String name = req.getParameter("participantName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String inst = req.getParameter("institution");
            String pass = req.getParameter("password");
            try {
                if (dao.registerParticipant(id, name, email, phone, inst, pass)) {
                    req.setAttribute("success", "Registration successful! Please login.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed.");
                    req.getRequestDispatcher("register.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Participant ID or Email already exists!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }
        } else if ("/registerEvent".equals(path)) {
            HttpSession s = req.getSession(false);
            String pId = (String) (s != null ? s.getAttribute("participantId") : null);
            if (pId == null) { resp.sendRedirect("index.jsp"); return; }
            int eId = Integer.parseInt(req.getParameter("eventId"));
            try {
                if (dao.registerForEvent(pId, eId)) {
                    resp.sendRedirect("participant_home.jsp?msg=registered");
                } else {
                    resp.sendRedirect("participant_home.jsp?err=closed_or_full");
                }
            } catch (Exception e) {
                resp.sendRedirect("participant_home.jsp?err=already_registered");
            }
        } else if ("/addEvent".equals(path)) {
            String title = req.getParameter("title");
            String cat = req.getParameter("category");
            String venue = req.getParameter("venue");
            String date = req.getParameter("eventDate");
            String deadline = req.getParameter("deadline");
            int cap = Integer.parseInt(req.getParameter("capacity"));
            try {
                dao.addEvent(title, cat, venue, date, deadline, cap);
                resp.sendRedirect("organizer_dashboard.jsp?msg=event_created");
            } catch (Exception e) {
                resp.sendRedirect("organizer_dashboard.jsp?err=" + e.getMessage());
            }
        } else if ("/markAttendance".equals(path)) {
            int regId = Integer.parseInt(req.getParameter("regId"));
            int eventId = Integer.parseInt(req.getParameter("eventId"));
            String status = req.getParameter("status");
            try {
                dao.updateAttendance(regId, status);
                resp.sendRedirect("organizer_dashboard.jsp?eventId=" + eventId + "&msg=attendance_saved");
            } catch (Exception e) {
                resp.sendRedirect("organizer_dashboard.jsp?err=" + e.getMessage());
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
