<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.InternshipDAO, java.util.List, java.util.Map" %>
<%
    String roll = (String) session.getAttribute("rollNumber");
    String name = (String) session.getAttribute("studentName");
    if (roll == null) { response.sendRedirect("index.jsp"); return; }
    InternshipDAO dao = new InternshipDAO();
    String org = request.getParameter("org");
    String role = request.getParameter("role");
    String loc = request.getParameter("loc");
    List<Map<String, Object>> internships = dao.searchInternships(org, role, loc);
    List<Map<String, Object>> myApps = dao.getStudentApplications(roll);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Portal | Internship Tracker</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ’¼ Welcome, <%= name %> (<%= roll %>)</h2>
        <a href="logout" class="btn btn-sm" style="background: #dc2626;">Logout</a>
    </div>
    <div class="container">
        <% if ("applied".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Application submitted successfully! Track coordinator updates below.</div>
        <% } %>
        <% if ("deadline_passed".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: The application deadline for this internship has already expired!</div>
        <% } %>
        <% if ("already_applied".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: You have already applied for this specific internship position! Duplicate applications are prohibited.</div>
        <% } %>

        <div class="card">
            <h3>ðŸ¢ Available Internship Opportunities</h3>
            <form method="get" style="display: flex; gap: 10px; margin-bottom: 15px;">
                <input type="text" name="org" placeholder="Filter by Organisation..." value="<%= org != null ? org : "" %>">
                <input type="text" name="role" placeholder="Filter by Role..." value="<%= role != null ? role : "" %>">
                <input type="text" name="loc" placeholder="Location..." value="<%= loc != null ? loc : "" %>">
                <button type="submit" class="btn">Filter</button>
                <a href="student_home.jsp" class="btn" style="background: #6c757d;">Reset</a>
            </form>
            <table>
                <thead>
                    <tr><th>Organisation</th><th>Role</th><th>Eligibility</th><th>Location</th><th>Stipend</th><th>Last Date</th><th>Action</th></tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> i : internships) { %>
                    <tr>
                        <td><strong><%= i.get("organisation") %></strong></td>
                        <td><%= i.get("role") %></td>
                        <td><%= i.get("eligibility") %></td>
                        <td><%= i.get("location") %></td>
                        <td><%= i.get("stipend") %></td>
                        <td><%= i.get("lastDate") %></td>
                        <td>
                            <form action="applyInternship" method="post" style="margin: 0;">
                                <input type="hidden" name="internshipId" value="<%= i.get("internshipId") %>">
                                <button type="submit" class="btn btn-success btn-sm">Apply Now</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h3>ðŸ“‘ My Internship Applications</h3>
            <table>
                <thead>
                    <tr><th>App ID</th><th>Organisation</th><th>Role</th><th>Location</th><th>Applied Date</th><th>Status</th><th>Coordinator Remarks</th></tr>
                </thead>
                <tbody>
                <% if (myApps.isEmpty()) { %>
                    <tr><td colspan="7" style="text-align: center;">You have not applied for any internships yet.</td></tr>
                <% } else { for (Map<String, Object> a : myApps) { %>
                    <tr>
                        <td>#<%= a.get("appId") %></td>
                        <td><strong><%= a.get("organisation") %></strong></td>
                        <td><%= a.get("role") %></td>
                        <td><%= a.get("location") %></td>
                        <td><%= a.get("appliedAt") %></td>
                        <td>
                            <span class="badge badge-<%= a.get("status") %>"><%= a.get("status") %></span>
                        </td>
                        <td><%= a.get("remarks") != null ? a.get("remarks") : "<em>Pending review</em>" %></td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
