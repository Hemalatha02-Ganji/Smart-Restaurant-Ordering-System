package com.clinic.controller;

import com.clinic.dao.AppointmentDAO;
import com.clinic.dao.DoctorDAO;
import com.clinic.model.Appointment;
import com.clinic.model.Doctor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;

/**
 * Serves Receptionist Operational Dashboard with metrics, date/doctor/status filters, and action triggers.
 */
@WebServlet("/receptionistDashboard")
public class ReceptionistDashboardServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("receptionist") == null) {
            resp.sendRedirect(req.getContextPath() + "/receptionist_login.jsp?msg=unauthorized");
            return;
        }

        String filterDateStr = req.getParameter("filterDate");
        String filterDoctorStr = req.getParameter("filterDoctor");
        String filterStatus = req.getParameter("filterStatus");

        Date filterDate = null;
        if (filterDateStr != null && !filterDateStr.trim().isEmpty()) {
            try {
                filterDate = Date.valueOf(filterDateStr.trim());
            } catch (IllegalArgumentException ignored) {}
        }

        Integer filterDoctor = null;
        if (filterDoctorStr != null && !filterDoctorStr.trim().isEmpty()) {
            try {
                filterDoctor = Integer.parseInt(filterDoctorStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Appointment> appointments = appointmentDAO.getAppointmentsByFilter(filterDate, filterDoctor, filterStatus);
        Map<String, Integer> metrics = appointmentDAO.getDashboardMetrics();
        List<Doctor> doctors = doctorDAO.getAllDoctors();

        req.setAttribute("appointments", appointments);
        req.setAttribute("metrics", metrics);
        req.setAttribute("doctors", doctors);
        req.setAttribute("filterDate", filterDateStr);
        req.setAttribute("filterDoctor", filterDoctorStr);
        req.setAttribute("filterStatus", filterStatus);

        req.getRequestDispatcher("/receptionist_dashboard.jsp").forward(req, resp);
    }
}
