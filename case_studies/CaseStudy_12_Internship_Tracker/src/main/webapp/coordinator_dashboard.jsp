<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.InternshipDAO, java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("role") == null || !"coordinator".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp?err=access_denied"); return;
    }
    InternshipDAO dao = new InternshipDAO();
    List<Map<String, Object>> applicants = dao.getAllApplicants();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Placement Coordinator Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ’¼ Placement &amp; Internship Coordinator Console</h2>
        <a href="logout" class="btn btn-sm" style="background: #dc2626;">Logout</a>
    </div>
    <div class="container">
        <% if ("published".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">New internship opening published successfully!</div>
        <% } %>
        <% if ("status_updated".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Applicant status and remarks updated successfully!</div>
        <% } %>

        <div class="card">
            <h3>ðŸ“¢ Publish Internship Opening</h3>
            <form action="publishInternship" method="post">
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px;">
                    <div class="form-group" style="margin: 0;">
                        <label>Organisation Name:</label>
                        <input type="text" name="organisation" placeholder="e.g. Microsoft" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Internship Role:</label>
                        <input type="text" name="role" placeholder="e.g. SDE Intern" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Eligibility:</label>
                        <input type="text" name="eligibility" placeholder="e.g. B.Tech CSE/IT CGPA > 8.0" required>
                    </div>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; margin-top: 10px;">
                    <div class="form-group" style="margin: 0;">
                        <label>Location:</label>
                        <input type="text" name="location" placeholder="e.g. Hyderabad / Remote" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Stipend:</label>
                        <input type="text" name="stipend" placeholder="e.g. Rs. 40,000 / month" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Application Deadline:</label>
                        <input type="date" name="lastDate" required>
                    </div>
                </div>
                <button type="submit" class="btn" style="margin-top: 15px;">Publish Opportunity</button>
            </form>
        </div>

        <div class="card">
            <h3>ðŸ‘¥ Student Applicant Tracking &amp; Status Management</h3>
            <table>
                <thead>
                    <tr><th>App ID</th><th>Roll No</th><th>Student</th><th>Opportunity</th><th>Status</th><th>Update Status &amp; Remarks</th></tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> a : applicants) { %>
                    <tr>
                        <td>#<%= a.get("appId") %></td>
                        <td><strong><%= a.get("roll") %></strong></td>
                        <td><%= a.get("student") %><br><small><%= a.get("email") %></small></td>
                        <td><%= a.get("opportunity") %></td>
                        <td>
                            <span class="badge badge-<%= a.get("status") %>"><%= a.get("status") %></span>
                        </td>
                        <td>
                            <form action="updateApplication" method="post" style="display: flex; flex-direction: column; gap: 5px;">
                                <input type="hidden" name="appId" value="<%= a.get("appId") %>">
                                <select name="status" style="padding: 3px; font-size: 12px;">
                                    <option value="Shortlisted">Shortlisted</option>
                                    <option value="Selected">Selected</option>
                                    <option value="Rejected">Rejected</option>
                                </select>
                                <input type="text" name="remarks" placeholder="Coordinator remarks..." value="<%= a.get("remarks") != null ? a.get("remarks") : "" %>" style="padding: 3px; font-size: 12px;">
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
