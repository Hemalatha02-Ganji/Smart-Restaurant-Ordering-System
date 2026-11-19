<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.LibraryDAO, com.casestudy.model.Reservation, java.util.List" %>
<%
    if (session.getAttribute("role") == null || !"librarian".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp?err=access_denied"); return;
    }
    LibraryDAO dao = new LibraryDAO();
    List<Reservation> list = dao.getAllReservations();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Librarian Dashboard | Manage Reservations</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ“š Librarian Control Dashboard</h2>
        <a href="logout" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="container">
        <% if ("updated".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Reservation status updated successfully!</div>
        <% } %>
        <div class="card">
            <h3>All Member Reservation Requests</h3>
            <table>
                <thead>
                    <tr>
                        <th>Req ID</th><th>Member Name</th><th>Member ID</th><th>Book Title</th><th>Date</th><th>Status</th><th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Reservation r : list) { %>
                    <tr>
                        <td>#<%= r.getReservationId() %></td>
                        <td><strong><%= r.getMemberName() %></strong></td>
                        <td><%= r.getMemberId() %></td>
                        <td><%= r.getResourceTitle() %></td>
                        <td><%= r.getRequestDate() %></td>
                        <td>
                            <span class="badge <%= "APPROVED".equals(r.getStatus()) ? "badge-available" : ("REJECTED".equals(r.getStatus()) ? "badge-reserved" : "badge-pending") %>">
                                <%= r.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <% if ("PENDING".equals(r.getStatus())) { %>
                                <form action="resourceAction" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="reservationId" value="<%= r.getReservationId() %>">
                                    <input type="hidden" name="status" value="APPROVED">
                                    <button type="submit" class="btn btn-success btn-sm">Approve</button>
                                </form>
                                <form action="resourceAction" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="reservationId" value="<%= r.getReservationId() %>">
                                    <input type="hidden" name="status" value="REJECTED">
                                    <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                                </form>
                            <% } else { %>
                                <em>Completed</em>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
