<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.MaintenanceDAO, java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("role") == null || !"manager".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp?err=access_denied"); return;
    }
    MaintenanceDAO dao = new MaintenanceDAO();
    String cat = request.getParameter("category");
    String pri = request.getParameter("priority");
    String st = request.getParameter("status");
    List<Map<String, Object>> requests = dao.getAllRequests(cat, pri, st);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manager Dashboard | Maintenance System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ¢ Maintenance Manager Operations Console</h2>
        <a href="logout" class="btn btn-sm" style="background: #e63946;">Logout</a>
    </div>
    <div class="container">
        <% if ("updated".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Request status and manager remarks updated successfully!</div>
        <% } %>

        <div class="card">
            <h3>Filter Maintenance Requests</h3>
            <form method="get" style="display: flex; gap: 15px; align-items: flex-end;">
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Category:</label>
                    <select name="category">
                        <option value="">-- All --</option>
                        <option value="Plumbing" <%= "Plumbing".equals(cat) ? "selected" : "" %>>Plumbing</option>
                        <option value="Electrical" <%= "Electrical".equals(cat) ? "selected" : "" %>>Electrical</option>
                        <option value="Carpentry" <%= "Carpentry".equals(cat) ? "selected" : "" %>>Carpentry</option>
                        <option value="HVAC" <%= "HVAC".equals(cat) ? "selected" : "" %>>HVAC</option>
                        <option value="General" <%= "General".equals(cat) ? "selected" : "" %>>General</option>
                    </select>
                </div>
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Priority:</label>
                    <select name="priority">
                        <option value="">-- All --</option>
                        <option value="High" <%= "High".equals(pri) ? "selected" : "" %>>High</option>
                        <option value="Medium" <%= "Medium".equals(pri) ? "selected" : "" %>>Medium</option>
                        <option value="Low" <%= "Low".equals(pri) ? "selected" : "" %>>Low</option>
                    </select>
                </div>
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Status:</label>
                    <select name="status">
                        <option value="">-- All --</option>
                        <option value="Pending" <%= "Pending".equals(st) ? "selected" : "" %>>Pending</option>
                        <option value="In Progress" <%= "In Progress".equals(st) ? "selected" : "" %>>In Progress</option>
                        <option value="Resolved" <%= "Resolved".equals(st) ? "selected" : "" %>>Resolved</option>
                        <option value="Rejected" <%= "Rejected".equals(st) ? "selected" : "" %>>Rejected</option>
                    </select>
                </div>
                <button type="submit" class="btn">Filter</button>
                <a href="manager_dashboard.jsp" class="btn" style="background: #6c757d;">Reset</a>
            </form>
        </div>

        <div class="card">
            <h3>All Tenant Requests</h3>
            <table>
                <thead>
                    <tr><th>ID</th><th>Resident / Flat</th><th>Category</th><th>Description</th><th>Priority</th><th>Status</th><th>Update Status & Remarks</th></tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> r : requests) { %>
                    <tr>
                        <td>#<%= r.get("requestId") %></td>
                        <td><strong><%= r.get("resident") %></strong><br><small><%= r.get("phone") %></small></td>
                        <td><%= r.get("category") %></td>
                        <td><%= r.get("description") %></td>
                        <td><span class="badge badge-<%= r.get("priority") %>"><%= r.get("priority") %></span></td>
                        <td><span class="badge badge-<%= r.get("status") %>"><%= r.get("status") %></span></td>
                        <td>
                            <form action="updateRequest" method="post" style="display: flex; flex-direction: column; gap: 5px;">
                                <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                                <select name="status" style="padding: 3px; font-size: 12px;">
                                    <option value="In Progress">In Progress</option>
                                    <option value="Resolved">Resolved</option>
                                    <option value="Rejected">Rejected</option>
                                </select>
                                <input type="text" name="remarks" placeholder="Add remarks..." value="<%= r.get("remarks") != null ? r.get("remarks") : "" %>" style="padding: 3px; font-size: 12px;">
                                <button type="submit" class="btn btn-sm">Save</button>
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
