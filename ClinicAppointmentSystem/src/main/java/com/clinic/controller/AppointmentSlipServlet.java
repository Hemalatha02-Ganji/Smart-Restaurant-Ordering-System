package com.clinic.controller;

import com.clinic.dao.AppointmentDAO;
import com.clinic.model.Appointment;
import com.clinic.model.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Renders the Official Medical Appointment Slip / Token for printing or digital download.
 */
@WebServlet("/appointmentSlip")
public class AppointmentSlipServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        boolean isPatient = (session != null && session.getAttribute("patient") != null);
        boolean isReceptionist = (session != null && session.getAttribute("receptionist") != null);

        if (!isPatient && !isReceptionist) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp?msg=unauthorized");
            return;
        }

        String idStr = req.getParameter("id");
        String token = req.getParameter("token");

        Appointment apt = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int aptId = Integer.parseInt(idStr.trim());
                apt = appointmentDAO.getAppointmentById(aptId);
            } catch (NumberFormatException ignored) {}
        } else if (token != null && !token.trim().isEmpty()) {
            apt = appointmentDAO.getAppointmentByToken(token.trim());
        }

        if (apt == null) {
            resp.sendRedirect(req.getContextPath() + "/patientHome?error=notFound");
            return;
        }

        // If patient, ensure they own this appointment
        if (isPatient) {
            Patient p = (Patient) session.getAttribute("patient");
            if (!apt.getPatientId().equals(p.getPatientId())) {
                resp.sendRedirect(req.getContextPath() + "/myAppointments?error=accessDenied");
                return;
            }
        }

        req.setAttribute("apt", apt);
        req.getRequestDispatcher("/appointment_slip.jsp").forward(req, resp);
    }
}
