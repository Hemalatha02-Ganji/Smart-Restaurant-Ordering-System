package com.clinic.controller;

import com.clinic.dao.AppointmentDAO;
import com.clinic.model.Appointment;
import com.clinic.model.Patient;
import com.clinic.model.Receptionist;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Handles status updates (Confirm, Cancel, Complete) for both Receptionists and Patients.
 */
@WebServlet("/appointmentAction")
public class AppointmentActionServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        boolean isPatient = (session != null && session.getAttribute("patient") != null);
        boolean isReceptionist = (session != null && session.getAttribute("receptionist") != null);

        if (!isPatient && !isReceptionist) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp?msg=unauthorized");
            return;
        }

        String aptIdStr = req.getParameter("appointmentId");
        String action = req.getParameter("action");
        String remarks = req.getParameter("remarks");

        if (aptIdStr == null || action == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(aptIdStr.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        Appointment apt = appointmentDAO.getAppointmentById(appointmentId);
        if (apt == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        // Action dispatch
        if ("CONFIRM".equalsIgnoreCase(action) && isReceptionist) {
            Receptionist r = (Receptionist) session.getAttribute("receptionist");
            appointmentDAO.updateStatus(appointmentId, "Confirmed", remarks != null ? remarks : "Confirmed by receptionist", r.getUsername());
            resp.sendRedirect(req.getContextPath() + "/receptionistDashboard?msg=confirmed");
        } else if ("CANCEL".equalsIgnoreCase(action) && isReceptionist) {
            Receptionist r = (Receptionist) session.getAttribute("receptionist");
            appointmentDAO.updateStatus(appointmentId, "Cancelled", remarks != null ? remarks : "Cancelled by receptionist", r.getUsername());
            resp.sendRedirect(req.getContextPath() + "/receptionistDashboard?msg=cancelled");
        } else if ("COMPLETE".equalsIgnoreCase(action) && isReceptionist) {
            Receptionist r = (Receptionist) session.getAttribute("receptionist");
            appointmentDAO.updateStatus(appointmentId, "Completed", remarks != null ? remarks : "Consultation finished", r.getUsername());
            resp.sendRedirect(req.getContextPath() + "/receptionistDashboard?msg=completed");
        } else if ("PATIENT_CANCEL".equalsIgnoreCase(action) && isPatient) {
            Patient p = (Patient) session.getAttribute("patient");
            if (apt.getPatientId().equals(p.getPatientId())) {
                appointmentDAO.updateStatus(appointmentId, "Cancelled", "Cancelled by patient", p.getPatientId());
                resp.sendRedirect(req.getContextPath() + "/myAppointments?msg=cancelled");
            } else {
                resp.sendRedirect(req.getContextPath() + "/myAppointments?error=forbidden");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }
}
