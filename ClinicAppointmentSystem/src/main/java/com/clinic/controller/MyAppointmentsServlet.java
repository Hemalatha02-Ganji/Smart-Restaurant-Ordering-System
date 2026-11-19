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
import java.util.List;

/**
 * Renders the logged-in patient's appointments list.
 */
@WebServlet("/myAppointments")
public class MyAppointmentsServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("patient") == null) {
            resp.sendRedirect(req.getContextPath() + "/patient_login.jsp?msg=unauthorized");
            return;
        }

        Patient patient = (Patient) session.getAttribute("patient");
        List<Appointment> appointments = appointmentDAO.getAppointmentsByPatient(patient.getPatientId());

        req.setAttribute("appointments", appointments);
        req.getRequestDispatcher("/my_appointments.jsp").forward(req, resp);
    }
}
