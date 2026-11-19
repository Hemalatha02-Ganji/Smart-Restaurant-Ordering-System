package com.clinic.controller;

import com.clinic.dao.PatientDAO;
import com.clinic.model.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Handles Patient Authentication via Patient ID or Email + Password.
 */
@WebServlet("/patientLogin")
public class PatientLoginServlet extends HttpServlet {
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/patient_login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idOrEmail = req.getParameter("idOrEmail");
        String password = req.getParameter("password");

        if (idOrEmail == null || idOrEmail.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Please enter both Patient ID / Email and Password.");
            req.getRequestDispatcher("/patient_login.jsp").forward(req, resp);
            return;
        }

        Patient patient = patientDAO.authenticate(idOrEmail.trim(), password.trim());

        if (patient != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("patient", patient);
            session.setAttribute("userRole", "PATIENT");
            session.setAttribute("userName", patient.getPatientName());
            resp.sendRedirect(req.getContextPath() + "/patientHome");
        } else {
            req.setAttribute("errorMessage", "Invalid Patient ID / Email or Password. Please check credentials.");
            req.setAttribute("prevUser", idOrEmail);
            req.getRequestDispatcher("/patient_login.jsp").forward(req, resp);
        }
    }
}
