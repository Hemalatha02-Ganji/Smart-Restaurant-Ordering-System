<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.ClinicDAO, com.casestudy.model.Appointment, java.util.List" %>
<%
    if (session.getAttribute("role") == null || !"receptionist".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp?err=access_denied"); return;
    }
    ClinicDAO dao = new ClinicDAO();
    String filterDate = request.getParameter("filterDate");
    List<Appointment> list = dao.getAppointmentsByDate(filterDate);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Receptionist Dashboard | Clinic Appointments</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ¥ Receptionist Control Panel</h2>
        <a href="logout" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="container">
        <div class="card">
            <h3>Filter Appointments by Date</h3>
            <form method="get" style="display: flex; gap: 10px; align-items: flex-end;">
                <div class="form-group" style="margin: 0; flex: 1;">
                    <label>Select Date:</label>
                    <input type="date" name="filterDate" value="<%= filterDate != null ? filterDate : "" %>">
                </div>
                <button type="submit" class="btn">Filter</button>
                <a href="receptionist_dashboard.jsp" class="btn" style="background: #6c757d;">Show All</a>
            </form>
        </div>

        <div class="card">
            <h3>Scheduled Appointments Roster</h3>
            <table>
                <thead>
                    <tr><th>App ID</th><th>Patient Name</th><th>Doctor</th><th>Date</th><th>Slot</th><th>Reason</th><th>Status</th><th>Action</th></tr>
                </thead>
                <tbody>
                <% for (Appointment a : list) { %>
                    <tr>
                        <td>#<%= a.getAppointmentId() %></td>
                        <td><strong><%= a.getPatientName() %></strong> (<%= a.getPatientId() %>)</td>
                        <td><%= a.getDoctorName() %></td>
                        <td><%= a.getAppointmentDate() %></td>
                        <td><%= a.getTimeSlot() %></td>
                        <td><%= a.getReason() %></td>
                        <td>
                            <span class="badge <%= "CONFIRMED".equals(a.getStatus()) ? "badge-confirmed" : ("CANCELLED".equals(a.getStatus()) ? "badge-cancelled" : "badge-pending") %>">
                                <%= a.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <% if ("PENDING".equals(a.getStatus())) { %>
                                <form action="updateAppointment" method="post" style="display: inline;">
                                    <input type="hidden" name="appointmentId" value="<%= a.getAppointmentId() %>">
                                    <input type="hidden" name="status" value="CONFIRMED">
                                    <button type="submit" class="btn btn-success btn-sm">Confirm</button>
                                </form>
                                <form action="updateAppointment" method="post" style="display: inline;">
                                    <input type="hidden" name="appointmentId" value="<%= a.getAppointmentId() %>">
                                    <input type="hidden" name="status" value="CANCELLED">
                                    <button type="submit" class="btn btn-danger btn-sm">Cancel</button>
                                </form>
                            <% } else { %>
                                <em>Handled</em>
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
