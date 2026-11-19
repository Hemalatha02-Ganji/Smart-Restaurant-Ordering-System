package com.casestudy.servlet;

import com.casestudy.dao.LibraryDAO;
import com.casestudy.model.Member;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/resourceAction")
public class ResourceServlet extends HttpServlet {
    private LibraryDAO dao = new LibraryDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        String action = req.getParameter("action");

        try {
            if ("reserve".equals(action)) {
                Member m = (Member) s.getAttribute("member");
                if (m == null) { resp.sendRedirect("index.jsp"); return; }
                int resId = Integer.parseInt(req.getParameter("resourceId"));
                if (dao.requestReservation(m.getMemberId(), resId)) {
                    resp.sendRedirect("member_home.jsp?msg=reserved");
                } else {
                    resp.sendRedirect("member_home.jsp?err=unavailable");
                }
            } else if ("updateStatus".equals(action)) {
                if (s == null || !"librarian".equals(s.getAttribute("role"))) {
                    resp.sendRedirect("index.jsp"); return;
                }
                int reservationId = Integer.parseInt(req.getParameter("reservationId"));
                String status = req.getParameter("status");
                dao.updateReservationStatus(reservationId, status);
                resp.sendRedirect("librarian_dashboard.jsp?msg=updated");
            }
        } catch (Exception e) {
            resp.sendRedirect("index.jsp?err=" + e.getMessage());
        }
    }
}
