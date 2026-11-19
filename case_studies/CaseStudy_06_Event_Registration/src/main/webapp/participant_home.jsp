<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.EventDAO, java.util.List, java.util.Map" %>
<%
    String partId = (String) session.getAttribute("participantId");
    String partName = (String) session.getAttribute("participantName");
    if (partId == null) { response.sendRedirect("index.jsp"); return; }
    EventDAO dao = new EventDAO();
    String cat = request.getParameter("category");
    String date = request.getParameter("date");
    List<Map<String, Object>> events = dao.getUpcomingEvents(cat, date);
    List<Map<String, Object>> myRegs = dao.getParticipantRegistrations(partId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Participant Portal | Campus Events</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸŽª Welcome, <%= partName %> (<%= partId %>)</h2>
        <a href="logout" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="container">
        <% if ("registered".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Successfully registered for the event! Confirmation saved.</div>
        <% } %>
        <% if ("closed_or_full".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Registration Failed: The deadline has passed or all seats are fully booked!</div>
        <% } %>
        <% if ("already_registered".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: You have already registered for this event! Duplicate registrations are prohibited.</div>
        <% } %>

        <div class="card">
            <h3>ðŸ” Explore Upcoming Campus Events</h3>
            <form method="get" style="display: flex; gap: 10px; align-items: flex-end;">
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Filter by Category:</label>
                    <select name="category">
                        <option value="">-- All Categories --</option>
                        <option value="Technical" <%= "Technical".equals(cat) ? "selected" : "" %>>Technical</option>
                        <option value="Workshop" <%= "Workshop".equals(cat) ? "selected" : "" %>>Workshop</option>
                        <option value="Cultural" <%= "Cultural".equals(cat) ? "selected" : "" %>>Cultural</option>
                    </select>
                </div>
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Filter by Date:</label>
                    <input type="date" name="date" value="<%= date != null ? date : "" %>">
                </div>
                <button type="submit" class="btn">Filter</button>
                <a href="participant_home.jsp" class="btn" style="background: #6c757d;">Reset</a>
            </form>
            <table>
                <thead>
                    <tr><th>Title</th><th>Category</th><th>Venue</th><th>Date</th><th>Deadline</th><th>Seats Left</th><th>Action</th></tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> ev : events) { 
                    int avail = (Integer) ev.get("availableSeats");
                %>
                    <tr>
                        <td><strong><%= ev.get("title") %></strong></td>
                        <td><%= ev.get("category") %></td>
                        <td><%= ev.get("venue") %></td>
                        <td><%= ev.get("eventDate") %></td>
                        <td><%= ev.get("deadline") %></td>
                        <td>
                            <span class="badge" style="background: #d8f3dc; color: #2d6a4f;">
                                <%= avail %> / <%= ev.get("capacity") %>
                            </span>
                        </td>
                        <td>
                            <% if (avail > 0) { %>
                                <form action="registerEvent" method="post" style="margin: 0;">
                                    <input type="hidden" name="eventId" value="<%= ev.get("eventId") %>">
                                    <button type="submit" class="btn btn-success btn-sm">Register</button>
                                </form>
                            <% } else { %>
                                <span style="color: #999;">Sold Out</span>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h3>ðŸŽ« My Event Registrations</h3>
            <table>
                <thead>
                    <tr><th>Reg ID</th><th>Event Title</th><th>Category</th><th>Venue</th><th>Event Date</th><th>Attendance Status</th></tr>
                </thead>
                <tbody>
                <% if (myRegs.isEmpty()) { %>
                    <tr><td colspan="6" style="text-align: center;">You have not registered for any events yet.</td></tr>
                <% } else { for (Map<String, Object> r : myRegs) { %>
                    <tr>
                        <td>#<%= r.get("regId") %></td>
                        <td><strong><%= r.get("title") %></strong></td>
                        <td><%= r.get("category") %></td>
                        <td><%= r.get("venue") %></td>
                        <td><%= r.get("eventDate") %></td>
                        <td>
                            <span class="badge badge-<%= r.get("attendance") %>">
                                <%= r.get("attendance") %>
                            </span>
                        </td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
