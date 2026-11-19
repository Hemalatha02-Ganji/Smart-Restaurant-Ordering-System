<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.LabDAO, java.util.List, java.util.Map" %>
<%
    String staffId = (String) session.getAttribute("staffId");
    String fullName = (String) session.getAttribute("fullName");
    String role = (String) session.getAttribute("role");
    if (staffId == null) { response.sendRedirect("index.jsp"); return; }
    LabDAO dao = new LabDAO();
    String q = request.getParameter("query");
    List<Map<String, Object>> equipment = dao.searchEquipment(q);
    List<Map<String, Object>> activeIssues = dao.getActiveIssues();
    String reportType = request.getParameter("reportType");
    List<Map<String, Object>> reports = (reportType != null) ? dao.getReports(reportType) : java.util.Collections.emptyList();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Dashboard | Lab Register</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ”¬ Welcome, <%= fullName %> (<%= role %>)</h2>
        <a href="logout" class="btn btn-sm" style="background: #dc2626;">Logout</a>
    </div>
    <div class="container">
        <% if ("issued".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Equipment successfully issued! Available stock updated.</div>
        <% } %>
        <% if ("returned".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Equipment return recorded! Condition logged.</div>
        <% } %>
        <% if ("out_of_stock".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: Insufficient quantity! Selected equipment is currently out of stock.</div>
        <% } %>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <div class="card">
                <h3>ðŸ” View &amp; Search Equipment</h3>
                <form method="get" style="display: flex; gap: 10px; margin-bottom: 15px;">
                    <input type="text" name="query" placeholder="Search equipment or category..." value="<%= q != null ? q : "" %>">
                    <button type="submit" class="btn">Search</button>
                </form>
                <table>
                    <thead>
                        <tr><th>Equipment</th><th>Category</th><th>Available / Total</th></tr>
                    </thead>
                    <tbody>
                    <% for (Map<String, Object> eq : equipment) { %>
                        <tr>
                            <td><strong><%= eq.get("name") %></strong></td>
                            <td><%= eq.get("category") %></td>
                            <td>
                                <span class="badge" style="background: #e2e8f0;">
                                    <%= eq.get("availableQty") %> / <%= eq.get("totalQty") %>
                                </span>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <div class="card">
                <h3>ðŸ“¤ Issue Equipment to Student</h3>
                <form action="issueEquipment" method="post">
                    <div class="form-group">
                        <label>Student Roll Number:</label>
                        <input type="text" name="studentRoll" placeholder="e.g. 24761A05S2" required>
                    </div>
                    <div class="form-group">
                        <label>Student Full Name:</label>
                        <input type="text" name="studentName" required>
                    </div>
                    <div class="form-group">
                        <label>Select Equipment:</label>
                        <select name="equipmentId" required>
                            <% for (Map<String, Object> eq : equipment) { %>
                                <option value="<%= eq.get("equipmentId") %>" <%= ((Integer)eq.get("availableQty") <= 0) ? "disabled" : "" %>>
                                    <%= eq.get("name") %> (<%= eq.get("availableQty") %> available)
                                </option>
                            <% } %>
                        </select>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                        <div class="form-group">
                            <label>Issue Date:</label>
                            <input type="date" name="issueDate" required>
                        </div>
                        <div class="form-group">
                            <label>Due Return Date:</label>
                            <input type="date" name="dueDate" required>
                        </div>
                    </div>
                    <button type="submit" class="btn">Issue Equipment</button>
                </form>
            </div>
        </div>

        <div class="card">
            <h3>ðŸ“¥ Record Equipment Return</h3>
            <table>
                <thead>
                    <tr><th>ID</th><th>Roll No</th><th>Student</th><th>Equipment</th><th>Due Date</th><th>Return Action</th></tr>
                </thead>
                <tbody>
                <% if (activeIssues.isEmpty()) { %>
                    <tr><td colspan="6" style="text-align: center;">No equipment currently issued out.</td></tr>
                <% } else { for (Map<String, Object> is : activeIssues) { %>
                    <tr>
                        <td>#<%= is.get("issueId") %></td>
                        <td><strong><%= is.get("roll") %></strong></td>
                        <td><%= is.get("student") %></td>
                        <td><%= is.get("equipment") %></td>
                        <td><%= is.get("dueDate") %></td>
                        <td>
                            <form action="returnEquipment" method="post" style="display: flex; gap: 5px;">
                                <input type="hidden" name="issueId" value="<%= is.get("issueId") %>">
                                <input type="date" name="returnDate" required style="padding: 3px; font-size: 11px;">
                                <select name="condition" required style="padding: 3px; font-size: 11px; width: 90px;">
                                    <option value="Good">Good</option>
                                    <option value="Damaged">Damaged</option>
                                </select>
                                <button type="submit" class="btn btn-sm btn-success">Return</button>
                            </form>
                        </td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h3>ðŸ“Š Supervisor Audit Reports</h3>
            <div style="display: flex; gap: 10px; margin-bottom: 15px;">
                <a href="dashboard.jsp?reportType=all" class="btn btn-sm">All Records</a>
                <a href="dashboard.jsp?reportType=overdue" class="btn btn-sm" style="background: #ea580c;">Overdue Equipment</a>
                <a href="dashboard.jsp?reportType=damaged" class="btn btn-sm" style="background: #dc2626;">Damaged Equipment</a>
            </div>
            <% if (reportType != null) { %>
                <table>
                    <thead>
                        <tr><th>ID</th><th>Roll No</th><th>Student</th><th>Equipment</th><th>Issue Date</th><th>Return Date</th><th>Condition</th><th>Status</th></tr>
                    </thead>
                    <tbody>
                    <% for (Map<String, Object> r : reports) { %>
                        <tr>
                            <td>#<%= r.get("issueId") %></td>
                            <td><%= r.get("roll") %></td>
                            <td><%= r.get("student") %></td>
                            <td><strong><%= r.get("equipment") %></strong></td>
                            <td><%= r.get("issueDate") %></td>
                            <td><%= r.get("returnDate") != null ? r.get("returnDate") : "Not Returned" %></td>
                            <td><%= r.get("condition") != null ? r.get("condition") : "N/A" %></td>
                            <td><span class="badge badge-<%= r.get("status") %>"><%= r.get("status") %></span></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
</body>
</html>
