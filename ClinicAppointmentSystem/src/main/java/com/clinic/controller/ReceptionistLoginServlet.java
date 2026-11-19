package com.clinic.controller;

import com.clinic.dao.ReceptionistDAO;
import com.clinic.model.Receptionist;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Handles Receptionist Staff Authentication.
 */
@WebServlet("/receptionistLogin")
public class ReceptionistLoginServlet extends HttpServlet {
    private ReceptionistDAO receptionistDAO;

    @Override
    public void init() throws ServletException {
        receptionistDAO = new ReceptionistDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/receptionist_login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Username and Password are required.");
            req.getRequestDispatcher("/receptionist_login.jsp").forward(req, resp);
            return;
        }

        Receptionist receptionist = receptionistDAO.authenticate(username.trim(), password.trim());

        if (receptionist != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("receptionist", receptionist);
            session.setAttribute("userRole", "RECEPTIONIST");
            session.setAttribute("userName", receptionist.getFullName());
            resp.sendRedirect(req.getContextPath() + "/receptionistDashboard");
        } else {
            req.setAttribute("errorMessage", "Invalid Receptionist credentials. Try: receptionist / admin123");
            req.setAttribute("prevUser", username);
            req.getRequestDispatcher("/receptionist_login.jsp").forward(req, resp);
        }
    }
}
