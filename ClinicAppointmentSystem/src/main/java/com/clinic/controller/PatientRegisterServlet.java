package com.clinic.controller;

import com.clinic.dao.PatientDAO;
import com.clinic.model.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;

/**
 * Handles New Patient Registration with validation.
 */
@WebServlet("/patientRegister")
public class PatientRegisterServlet extends HttpServlet {
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/patient_register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String patientId = req.getParameter("patientId");
        String patientName = req.getParameter("patientName");
        String dobStr = req.getParameter("dob");
        String gender = req.getParameter("gender");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String bloodGroup = req.getParameter("bloodGroup");
        String address = req.getParameter("address");

        // Validate required fields
        if (patientId == null || patientId.trim().isEmpty() ||
            patientName == null || patientName.trim().isEmpty() ||
            dobStr == null || dobStr.trim().isEmpty() ||
            gender == null || gender.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            req.setAttribute("errorMessage", "All marked fields (*) are mandatory.");
            req.getRequestDispatcher("/patient_register.jsp").forward(req, resp);
            return;
        }

        patientId = patientId.trim().toUpperCase();
        email = email.trim().toLowerCase();

        // Check duplicates
        if (patientDAO.isPatientIdExists(patientId)) {
            req.setAttribute("errorMessage", "Patient ID '" + patientId + "' is already registered. Please choose another or Login.");
            req.getRequestDispatcher("/patient_register.jsp").forward(req, resp);
            return;
        }

        if (patientDAO.isEmailExists(email)) {
            req.setAttribute("errorMessage", "Email ID '" + email + "' is already associated with an account. Please Login.");
            req.getRequestDispatcher("/patient_register.jsp").forward(req, resp);
            return;
        }

        Date dob;
        try {
            dob = Date.valueOf(dobStr.trim());
        } catch (IllegalArgumentException e) {
            req.setAttribute("errorMessage", "Invalid Date of Birth format. Please select a valid date.");
            req.getRequestDispatcher("/patient_register.jsp").forward(req, resp);
            return;
        }

        Patient patient = new Patient(patientId, patientName.trim(), dob, gender.trim(),
                phone.trim(), email, password.trim(), bloodGroup, address != null ? address.trim() : "");

        boolean success = patientDAO.registerPatient(patient);

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/patient_login.jsp?msg=registered&newId=" + patientId);
        } else {
            req.setAttribute("errorMessage", "Registration failed due to a database error. Please try again.");
            req.getRequestDispatcher("/patient_register.jsp").forward(req, resp);
        }
    }
}
