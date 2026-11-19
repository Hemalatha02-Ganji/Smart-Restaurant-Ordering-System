package com.casestudy.servlet;

import com.casestudy.dao.LibraryDAO;
import com.casestudy.model.Member;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {
    private LibraryDAO dao = new LibraryDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            String role = req.getParameter("role");
            String username = req.getParameter("username");
            String pass = req.getParameter("password");

            try {
                if ("librarian".equals(role)) {
                    if (dao.loginLibrarian(username, pass)) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "librarian");
                        s.setAttribute("username", username);
                        resp.sendRedirect("librarian_dashboard.jsp");
                        return;
                    }
                } else {
                    Member m = dao.loginMember(username, pass);
                    if (m != null) {
                        HttpSession s = req.getSession();
                        s.setAttribute("role", "member");
                        s.setAttribute("member", m);
                        resp.sendRedirect("member_home.jsp");
                        return;
                    }
                }
                req.setAttribute("error", "Invalid credentials. Please try again.");
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            } catch (Exception e) {
                req.setAttribute("error", "Database error: " + e.getMessage());
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            }
        } else if ("/register".equals(path)) {
            String id = req.getParameter("memberId");
            String name = req.getParameter("fullName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String dept = req.getParameter("department");
            String pass = req.getParameter("password");

            Member m = new Member(id, name, email, phone, dept, pass);
            try {
                if (dao.registerMember(m)) {
                    req.setAttribute("success", "Registration successful! Please login.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed. Try again.");
                    req.getRequestDispatcher("register.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Member ID or Email already exists!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
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
