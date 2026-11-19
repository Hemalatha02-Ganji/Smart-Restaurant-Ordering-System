package com.casestudy.servlet;

import com.casestudy.dao.ClinicDAO;
import com.casestudy.model.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/bookAppointment", "/updateAppointment"})
public class ClinicServlet extends HttpServlet {
    private ClinicDAO dao = new ClinicDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            String role = req.getParameter("role");
            String username = req.getParameter("username");
            String pass = req.getParameter("password");

            try {
                if ("receptionist".equals(role)) {
                    if (dao.loginReceptionist(username, pass)) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "receptionist");
                        s.setAttribute("username", username);
                        resp.sendRedirect("receptionist_dashboard.jsp");
                        return;
                    }
                } else {
                    Patient p = dao.loginPatient(username, pass);
                    if (p != null) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "patient");
                        s.setAttribute("patient", p);
                        resp.sendRedirect("patient_home.jsp");
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
            Patient p = new Patient(
                req.getParameter("patientId"),
                req.getParameter("patientName"),
                req.getParameter("dob"),
                req.getParameter("gender"),
                req.getParameter("phone"),
                req.getParameter("email"),
                req.getParameter("password")
            );
            try {
                if (dao.registerPatient(p)) {
                    req.setAttribute("success", "Registration successful! Please login.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed. Try again.");
                    req.getRequestDispatcher("register.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Patient ID or Email already exists!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }
        } else if ("/bookAppointment".equals(path)) {
            HttpSession s = req.getSession(false);
            Patient p = (Patient) (s != null ? s.getAttribute("patient") : null);
            if (p == null) { resp.sendRedirect("index.jsp"); return; }

            int docId = Integer.parseInt(req.getParameter("doctorId"));
            String date = req.getParameter("date");
            String slot = req.getParameter("timeSlot");
            String reason = req.getParameter("reason");

            try {
                if (dao.bookAppointment(p.getPatientId(), docId, date, slot, reason)) {
                    resp.sendRedirect("patient_home.jsp?msg=booked");
                } else {
                    resp.sendRedirect("patient_home.jsp?err=slot_taken");
                }
            } catch (Exception e) {
                resp.sendRedirect("patient_home.jsp?err=" + e.getMessage());
            }
        } else if ("/updateAppointment".equals(path)) {
            int id = Integer.parseInt(req.getParameter("appointmentId"));
            String status = req.getParameter("status");
            try {
                dao.updateAppointmentStatus(id, status);
                resp.sendRedirect("receptionist_dashboard.jsp?msg=status_updated");
            } catch (Exception e) {
                resp.sendRedirect("receptionist_dashboard.jsp?err=" + e.getMessage());
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
