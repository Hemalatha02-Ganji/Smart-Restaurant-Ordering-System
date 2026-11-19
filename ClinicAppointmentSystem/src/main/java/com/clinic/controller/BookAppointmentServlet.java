package com.clinic.controller;

import com.clinic.dao.AppointmentDAO;
import com.clinic.dao.DoctorDAO;
import com.clinic.model.Appointment;
import com.clinic.model.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;

/**
 * Handles Patient Appointment Booking with concurrency and duplicate slot prevention.
 */
@WebServlet("/bookAppointment")
public class BookAppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("patient") == null) {
            resp.sendRedirect(req.getContextPath() + "/patient_login.jsp?msg=unauthorized");
            return;
        }

        Patient patient = (Patient) session.getAttribute("patient");

        String doctorIdStr = req.getParameter("doctorId");
        String appointmentDateStr = req.getParameter("appointmentDate");
        String timeSlot = req.getParameter("timeSlot");
        String reason = req.getParameter("reason");
        String notes = req.getParameter("notes");

        if (doctorIdStr == null || doctorIdStr.trim().isEmpty() ||
            appointmentDateStr == null || appointmentDateStr.trim().isEmpty() ||
            timeSlot == null || timeSlot.trim().isEmpty() ||
            reason == null || reason.trim().isEmpty()) {

            req.setAttribute("errorMessage", "All booking fields are required. Please fill the complete form.");
            req.setAttribute("doctors", doctorDAO.getAllDoctors());
            req.setAttribute("specializations", doctorDAO.getAllSpecializations());
            req.getRequestDispatcher("/patient_home.jsp").forward(req, resp);
            return;
        }

        int doctorId;
        Date appointmentDate;
        try {
            doctorId = Integer.parseInt(doctorIdStr.trim());
            LocalDate localDate = LocalDate.parse(appointmentDateStr.trim());

            if (localDate.isBefore(LocalDate.now())) {
                req.setAttribute("errorMessage", "Appointment date cannot be in the past. Please select today or a future date.");
                req.setAttribute("doctors", doctorDAO.getAllDoctors());
                req.setAttribute("specializations", doctorDAO.getAllSpecializations());
                req.getRequestDispatcher("/patient_home.jsp").forward(req, resp);
                return;
            }

            appointmentDate = Date.valueOf(localDate);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Invalid date or doctor selection.");
            req.setAttribute("doctors", doctorDAO.getAllDoctors());
            req.setAttribute("specializations", doctorDAO.getAllSpecializations());
            req.getRequestDispatcher("/patient_home.jsp").forward(req, resp);
            return;
        }

        Appointment apt = new Appointment();
        apt.setPatientId(patient.getPatientId());
        apt.setDoctorId(doctorId);
        apt.setAppointmentDate(appointmentDate);
        apt.setTimeSlot(timeSlot.trim());
        apt.setReason(reason.trim());
        apt.setNotes(notes != null ? notes.trim() : "");

        try {
            boolean success = appointmentDAO.bookAppointment(apt);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/myAppointments?msg=booked&token=" + apt.getAppointmentToken());
            } else {
                req.setAttribute("errorMessage", "Conflict Detected: The selected Doctor is already booked for this Date and Time Slot. Please select another slot or doctor.");
                req.setAttribute("doctors", doctorDAO.getAllDoctors());
                req.setAttribute("specializations", doctorDAO.getAllSpecializations());
                req.getRequestDispatcher("/patient_home.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Database transaction failed. Slot conflict detected or server busy.");
            req.setAttribute("doctors", doctorDAO.getAllDoctors());
            req.setAttribute("specializations", doctorDAO.getAllSpecializations());
            req.getRequestDispatcher("/patient_home.jsp").forward(req, resp);
        }
    }
}
