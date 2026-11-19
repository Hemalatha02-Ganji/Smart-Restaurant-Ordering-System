package com.casestudy.servlet;

import com.casestudy.dao.LabDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"/login", "/logout", "/issueEquipment", "/returnEquipment"})
public class LabServlet extends HttpServlet {
    private LabDAO dao = new LabDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            String id = req.getParameter("staffId");
            String pass = req.getParameter("password");
            try {
                Map<String, String> staff = dao.loginStaff(id, pass);
                if (staff != null) {
                    HttpSession s = req.getSession();
                    s.setAttribute("staffId", staff.get("staffId"));
                    s.setAttribute("fullName", staff.get("fullName"));
                    s.setAttribute("role", staff.get("role"));
                    resp.sendRedirect("dashboard.jsp");
                } else {
                    req.setAttribute("error", "Invalid Staff ID or Password.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            }
        } else if ("/issueEquipment".equals(path)) {
            String roll = req.getParameter("studentRoll");
            String name = req.getParameter("studentName");
            int eqId = Integer.parseInt(req.getParameter("equipmentId"));
            String issueDate = req.getParameter("issueDate");
            String dueDate = req.getParameter("dueDate");
            try {
                if (dao.issueEquipment(roll, name, eqId, issueDate, dueDate)) {
                    resp.sendRedirect("dashboard.jsp?msg=issued");
                } else {
                    resp.sendRedirect("dashboard.jsp?err=out_of_stock");
                }
            } catch (Exception e) {
                resp.sendRedirect("dashboard.jsp?err=" + e.getMessage());
            }
        } else if ("/returnEquipment".equals(path)) {
            int issueId = Integer.parseInt(req.getParameter("issueId"));
            String retDate = req.getParameter("returnDate");
            String cond = req.getParameter("condition");
            try {
                dao.recordReturn(issueId, retDate, cond);
                resp.sendRedirect("dashboard.jsp?msg=returned");
            } catch (Exception e) {
                resp.sendRedirect("dashboard.jsp?err=" + e.getMessage());
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
