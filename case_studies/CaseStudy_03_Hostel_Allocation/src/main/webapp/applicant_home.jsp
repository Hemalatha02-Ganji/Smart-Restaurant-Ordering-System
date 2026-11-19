<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.HostelDAO, com.casestudy.model.Applicant, java.util.Map" %>
<%
    Applicant a = (Applicant) session.getAttribute("applicant");
    if (a == null) { response.sendRedirect("index.jsp"); return; }
    HostelDAO dao = new HostelDAO();
    Map<String, Object> myApp = dao.getApplicantApplication(a.getRollNumber());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Applicant Home | Hostel Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ  Welcome, <%= a.getStudentName() %> (<%= a.getRollNumber() %>)</h2>
        <a href="logout" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="container">
        <% if ("applied".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Hostel application submitted successfully! Status: PENDING review by warden.</div>
        <% } %>
        <% if ("duplicate".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: You have already submitted a hostel application for this academic year! Duplicate applications are prohibited.</div>
        <% } %>

        <div class="card">
            <h3>ðŸ“ Submit Hostel Application</h3>
            <form action="submitApplication" method="post" style="display: flex; gap: 15px; align-items: flex-end;">
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Academic Year:</label>
                    <select name="academicYear" required>
                        <option value="2026-2027">2026-2027</option>
                        <option value="2027-2028">2027-2028</option>
                    </select>
                </div>
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Preferred Block:</label>
                    <input type="text" value="<%= a.getPreferredHostel() %>" readonly style="background: #e9ecef;">
                </div>
                <button type="submit" class="btn">Submit Application</button>
            </form>
        </div>

        <div class="card">
            <h3>ðŸšª View Room Allocation Status</h3>
            <% if (myApp == null) { %>
                <p style="color: #666;">No application submitted yet. Please submit an application above.</p>
            <% } else { %>
                <p><strong>Academic Year:</strong> <%= myApp.get("academicYear") %></p>
                <p><strong>Application Status:</strong> 
                    <span class="badge <%= "APPROVED".equals(myApp.get("status")) ? "badge-approved" : ("REJECTED".equals(myApp.get("status")) ? "badge-rejected" : "badge-pending") %>">
                        <%= myApp.get("status") %>
                    </span>
                </p>
                <% if ("APPROVED".equals(myApp.get("status"))) { %>
                    <div style="background: #e8f5e9; border: 1px solid #c8e6c9; padding: 15px; border-radius: 5px; margin-top: 15px;">
                        <h4 style="color: #2e7d32; margin-top: 0;">ðŸŽ‰ Congratulations! Room Allocated</h4>
                        <p><strong>Hostel Block:</strong> <%= myApp.get("hostelBlock") %></p>
                        <p><strong>Allocated Room Number:</strong> <%= myApp.get("roomNumber") %></p>
                    </div>
                <% } else if ("REJECTED".equals(myApp.get("status"))) { %>
                    <div class="alert alert-danger" style="margin-top: 15px;">
                        Your hostel application was rejected by the warden due to unavailability of rooms.
                    </div>
                <% } else { %>
                    <div class="alert alert-pending" style="background: #fff3cd; color: #856404; margin-top: 15px;">
                        â³ Your application is currently pending review and room assignment by the hostel warden.
                    </div>
                <% } %>
            <% } %>
        </div>
    </div>
</body>
</html>
