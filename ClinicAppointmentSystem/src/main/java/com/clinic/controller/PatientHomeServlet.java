package com.clinic.controller;

import com.clinic.dao.DoctorDAO;
import com.clinic.model.Doctor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Loads Patient Portal Home view with available doctors and booking options.
 */
@WebServlet("/patientHome")
public class PatientHomeServlet extends HttpServlet {
    private DoctorDAO doctorDAO;

    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        List<String> specializations = doctorDAO.getAllSpecializations();

        req.setAttribute("doctors", doctors);
        req.setAttribute("specializations", specializations);

        req.getRequestDispatcher("/patient_home.jsp").forward(req, resp);
    }
}
