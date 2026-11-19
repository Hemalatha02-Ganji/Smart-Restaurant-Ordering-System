<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.VehicleDAO, java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("role") == null || !"advisor".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp?err=access_denied"); return;
    }
    VehicleDAO dao = new VehicleDAO();
    String filterDate = request.getParameter("filterDate");
    String filterStatus = request.getParameter("filterStatus");
    List<Map<String, Object>> bookings = dao.getAllBookings(filterDate, filterStatus);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Advisor Dashboard | Vehicle Service</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸš— Service Advisor Operations Dashboard</h2>
        <a href="logout" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="container">
        <% if ("status_updated".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Booking status updated successfully!</div>
        <% } %>

        <div class="card">
            <h3>Filter Service Bookings</h3>
            <form method="get" style="display: flex; gap: 15px; align-items: flex-end;">
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Filter Date:</label>
                    <input type="date" name="filterDate" value="<%= filterDate != null ? filterDate : "" %>">
                </div>
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Filter Status:</label>
                    <select name="filterStatus">
                        <option value="">-- All Statuses --</option>
                        <option value="Pending" <%= "Pending".equals(filterStatus) ? "selected" : "" %>>Pending</option>
                        <option value="Accepted" <%= "Accepted".equals(filterStatus) ? "selected" : "" %>>Accepted</option>
                        <option value="In Service" <%= "In Service".equals(filterStatus) ? "selected" : "" %>>In Service</option>
                        <option value="Completed" <%= "Completed".equals(filterStatus) ? "selected" : "" %>>Completed</option>
                        <option value="Cancelled" <%= "Cancelled".equals(filterStatus) ? "selected" : "" %>>Cancelled</option>
                    </select>
                </div>
                <button type="submit" class="btn">Filter</button>
                <a href="advisor_dashboard.jsp" class="btn" style="background: #6c757d;">Reset</a>
            </form>
        </div>

        <div class="card">
            <h3>Vehicle Service Queue</h3>
            <table>
                <thead>
                    <tr><th>ID</th><th>Customer</th><th>Vehicle</th><th>Service</th><th>Date</th><th>Slot</th><th>Status</th><th>Update Status</th></tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> b : bookings) { %>
                    <tr>
                        <td>#<%= b.get("bookingId") %></td>
                        <td><%= b.get("customer") %></td>
                        <td><strong><%= b.get("vehicle") %></strong></td>
                        <td><%= b.get("serviceType") %></td>
                        <td><%= b.get("date") %></td>
                        <td><%= b.get("timeSlot") %></td>
                        <td>
                            <span class="badge badge-<%= ((String)b.get("status")).replace(" ", "-") %>">
                                <%= b.get("status") %>
                            </span>
                        </td>
                        <td>
                            <form action="updateStatus" method="post" style="display: flex; gap: 5px;">
                                <input type="hidden" name="bookingId" value="<%= b.get("bookingId") %>">
                                <select name="status" style="padding: 3px; font-size: 12px; width: 120px;">
                                    <option value="Accepted">Accepted</option>
                                    <option value="In Service">In Service</option>
                                    <option value="Completed">Completed</option>
                                    <option value="Cancelled">Cancelled</option>
                                </select>
                                <button type="submit" class="btn btn-sm">Update</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
