<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.MaintenanceDAO, java.util.List, java.util.Map" %>
<%
    String resId = (String) session.getAttribute("residentId");
    String resName = (String) session.getAttribute("residentName");
    String flat = (String) session.getAttribute("apartmentNumber");
    if (resId == null) { response.sendRedirect("index.jsp"); return; }
    MaintenanceDAO dao = new MaintenanceDAO();
    List<Map<String, Object>> requests = dao.getResidentRequests(resId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Resident Portal | Maintenance System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ¢ Welcome, <%= resName %> (<%= flat %>)</h2>
        <a href="logout" class="btn btn-sm" style="background: #e63946;">Logout</a>
    </div>
    <div class="container">
        <% if ("submitted".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Maintenance request submitted successfully! Status: Pending review.</div>
        <% } %>

        <div class="card">
            <h3>ðŸ› ï¸ Submit Maintenance Request</h3>
            <form action="submitRequest" method="post">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group">
                        <label>Issue Category:</label>
                        <select name="category" required>
                            <option value="Plumbing">Plumbing</option>
                            <option value="Electrical">Electrical</option>
                            <option value="Carpentry">Carpentry</option>
                            <option value="HVAC">HVAC / Air Conditioning</option>
                            <option value="General">General Maintenance</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Priority Level:</label>
                        <select name="priority" required>
                            <option value="Low">Low</option>
                            <option value="Medium" selected>Medium</option>
                            <option value="High">High (Urgent)</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label>Issue Description:</label>
                    <textarea name="description" rows="3" placeholder="Describe the maintenance problem in detail..." required></textarea>
                </div>
                <button type="submit" class="btn">Submit Request</button>
            </form>
        </div>

        <div class="card">
            <h3>ðŸ“‹ My Maintenance Requests History</h3>
            <table>
                <thead>
                    <tr><th>Req ID</th><th>Category</th><th>Description</th><th>Priority</th><th>Date</th><th>Status</th><th>Manager Remarks</th></tr>
                </thead>
                <tbody>
                <% if (requests.isEmpty()) { %>
                    <tr><td colspan="7" style="text-align: center;">No maintenance requests submitted yet.</td></tr>
                <% } else { for (Map<String, Object> r : requests) { %>
                    <tr>
                        <td>#<%= r.get("requestId") %></td>
                        <td><%= r.get("category") %></td>
                        <td><%= r.get("description") %></td>
                        <td><span class="badge badge-<%= r.get("priority") %>"><%= r.get("priority") %></span></td>
                        <td><%= r.get("date") %></td>
                        <td><span class="badge badge-<%= r.get("status") %>"><%= r.get("status") %></span></td>
                        <td><%= r.get("remarks") != null ? r.get("remarks") : "<em>No remarks yet</em>" %></td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
