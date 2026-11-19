<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.HostelDAO, java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("role") == null || !"warden".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp?err=access_denied"); return;
    }
    HostelDAO dao = new HostelDAO();
    List<Map<String, Object>> apps = dao.getAllApplications();
    List<Map<String, Object>> rooms = dao.getAvailableRooms();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Warden Dashboard | Hostel Management</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ  Warden Control Dashboard</h2>
        <a href="logout" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="container">
        <% if ("allocated".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Room successfully allocated! Occupancy updated.</div>
        <% } %>
        <% if ("room_full".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: The selected room is already at full capacity!</div>
        <% } %>

        <div class="card">
            <h3>Student Hostel Applications</h3>
            <table>
                <thead>
                    <tr><th>App ID</th><th>Roll No</th><th>Name</th><th>Branch</th><th>Preference</th><th>Status</th><th>Allocated Room</th><th>Actions</th></tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> ap : apps) { %>
                    <tr>
                        <td>#<%= ap.get("applicationId") %></td>
                        <td><strong><%= ap.get("rollNumber") %></strong></td>
                        <td><%= ap.get("studentName") %></td>
                        <td><%= ap.get("branch") %></td>
                        <td><%= ap.get("preferredHostel") %></td>
                        <td>
                            <span class="badge <%= "APPROVED".equals(ap.get("status")) ? "badge-approved" : ("REJECTED".equals(ap.get("status")) ? "badge-rejected" : "badge-pending") %>">
                                <%= ap.get("status") %>
                            </span>
                        </td>
                        <td>
                            <%= ap.get("roomNumber") != null ? (ap.get("hostelBlock") + " - " + ap.get("roomNumber")) : "None" %>
                        </td>
                        <td>
                            <% if ("PENDING".equals(ap.get("status"))) { %>
                                <form action="allocateRoom" method="post" style="display: flex; gap: 5px; align-items: center;">
                                    <input type="hidden" name="applicationId" value="<%= ap.get("applicationId") %>">
                                    <select name="roomId" required style="width: 150px; padding: 4px; font-size: 12px;">
                                        <% for (Map<String, Object> rm : rooms) { %>
                                            <option value="<%= rm.get("roomId") %>">
                                                <%= rm.get("roomNumber") %> (<%= rm.get("currentOccupancy") %>/<%= rm.get("capacity") %>)
                                            </option>
                                        <% } %>
                                    </select>
                                    <button type="submit" class="btn btn-success btn-sm">Allocate</button>
                                </form>
                                <form action="rejectApplication" method="post" style="display: inline; margin-top: 5px;">
                                    <input type="hidden" name="applicationId" value="<%= ap.get("applicationId") %>">
                                    <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                                </form>
                            <% } else { %>
                                <em>Processed</em>
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
