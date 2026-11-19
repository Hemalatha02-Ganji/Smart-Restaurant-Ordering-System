<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.EventDAO, java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("role") == null || !"organizer".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp?err=access_denied"); return;
    }
    EventDAO dao = new EventDAO();
    List<Map<String, Object>> events = dao.getUpcomingEvents(null, null);
    String selEventStr = request.getParameter("eventId");
    int selEventId = (selEventStr != null && !selEventStr.isEmpty()) ? Integer.parseInt(selEventStr) : (events.isEmpty() ? 0 : (Integer)events.get(0).get("eventId"));
    List<Map<String, Object>> attendees = (selEventId > 0) ? dao.getEventAttendees(selEventId) : java.util.Collections.emptyList();
    Map<String, Integer> stats = (selEventId > 0) ? dao.getAttendanceStats(selEventId) : java.util.Collections.emptyMap();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Organizer Dashboard | Event & Attendance</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸŽª Event Organizer Control Center</h2>
        <a href="logout" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="container">
        <% if ("event_created".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">New campus event successfully published!</div>
        <% } %>
        <% if ("attendance_saved".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Attendance status successfully updated!</div>
        <% } %>

        <div class="card">
            <h3>âž• Add New Campus Event</h3>
            <form action="addEvent" method="post">
                <div style="display: grid; grid-template-columns: 2fr 1fr 1fr; gap: 10px;">
                    <div class="form-group" style="margin: 0;">
                        <label>Event Title:</label>
                        <input type="text" name="title" placeholder="e.g. Web Development Workshop" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Category:</label>
                        <select name="category" required>
                            <option value="Technical">Technical</option>
                            <option value="Workshop">Workshop</option>
                            <option value="Cultural">Cultural</option>
                            <option value="Seminar">Seminar</option>
                        </select>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Venue:</label>
                        <input type="text" name="venue" placeholder="e.g. Auditorium Hall A" required>
                    </div>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; margin-top: 10px;">
                    <div class="form-group" style="margin: 0;">
                        <label>Event Date:</label>
                        <input type="date" name="eventDate" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Registration Deadline:</label>
                        <input type="date" name="deadline" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Seating Capacity:</label>
                        <input type="number" name="capacity" placeholder="60" required>
                    </div>
                </div>
                <button type="submit" class="btn" style="margin-top: 15px;">Publish Event</button>
            </form>
        </div>

        <div class="card">
            <h3>ðŸ“‹ Record Attendance &amp; Participant Roster</h3>
            <form method="get" style="display: flex; gap: 10px; align-items: flex-end; margin-bottom: 20px;">
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Select Event to Manage:</label>
                    <select name="eventId" onchange="this.form.submit()">
                        <% for (Map<String, Object> ev : events) { %>
                            <option value="<%= ev.get("eventId") %>" <%= ((Integer)ev.get("eventId") == selEventId) ? "selected" : "" %>>
                                <%= ev.get("title") %> (<%= ev.get("eventDate") %>)
                            </option>
                        <% } %>
                    </select>
                </div>
            </form>

            <div style="display: flex; gap: 20px; margin-bottom: 15px;">
                <div style="background: #e9ecef; padding: 10px 15px; border-radius: 5px;">
                    <strong>Total Registered:</strong> <%= stats.getOrDefault("registered", 0) %>
                </div>
                <div style="background: #d8f3dc; padding: 10px 15px; border-radius: 5px; color: #2d6a4f;">
                    <strong>Attended (Present):</strong> <%= stats.getOrDefault("present", 0) %>
                </div>
                <div style="background: #ffccd5; padding: 10px 15px; border-radius: 5px; color: #c9184a;">
                    <strong>Absent:</strong> <%= stats.getOrDefault("absent", 0) %>
                </div>
            </div>

            <table>
                <thead>
                    <tr><th>Participant Name</th><th>Email</th><th>Phone</th><th>Institution</th><th>Status</th><th>Mark Attendance</th></tr>
                </thead>
                <tbody>
                <% if (attendees.isEmpty()) { %>
                    <tr><td colspan="6" style="text-align: center;">No participants registered for this event yet.</td></tr>
                <% } else { for (Map<String, Object> a : attendees) { %>
                    <tr>
                        <td><strong><%= a.get("name") %></strong></td>
                        <td><%= a.get("email") %></td>
                        <td><%= a.get("phone") %></td>
                        <td><%= a.get("institution") %></td>
                        <td>
                            <span class="badge badge-<%= a.get("attendance") %>">
                                <%= a.get("attendance") %>
                            </span>
                        </td>
                        <td>
                            <form action="markAttendance" method="post" style="display: inline;">
                                <input type="hidden" name="regId" value="<%= a.get("regId") %>">
                                <input type="hidden" name="eventId" value="<%= selEventId %>">
                                <input type="hidden" name="status" value="Present">
                                <button type="submit" class="btn btn-success btn-sm">Present</button>
                            </form>
                            <form action="markAttendance" method="post" style="display: inline;">
                                <input type="hidden" name="regId" value="<%= a.get("regId") %>">
                                <input type="hidden" name="eventId" value="<%= selEventId %>">
                                <input type="hidden" name="status" value="Absent">
                                <button type="submit" class="btn btn-danger btn-sm">Absent</button>
                            </form>
                        </td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
