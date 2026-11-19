<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.CourseDAO, com.casestudy.model.Course, java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("role") == null || !"coordinator".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp?err=access_denied"); return;
    }
    CourseDAO dao = new CourseDAO();
    List<Course> courses = dao.searchCourses(null);
    List<Map<String, Object>> enrollments = dao.getAllEnrollments();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Coordinator Dashboard | Course Enrollment</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸŽ“ Coordinator Control Panel</h2>
        <a href="logout" class="btn btn-danger btn-sm" style="background: #e63946;">Logout</a>
    </div>
    <div class="container">
        <% if ("course_added".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">New course successfully added to the catalogue!</div>
        <% } %>

        <div class="card">
            <h3>âž• Add New Course</h3>
            <form action="addCourse" method="post">
                <div style="display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 10px;">
                    <div class="form-group" style="margin: 0;">
                        <label>Course Title:</label>
                        <input type="text" name="title" placeholder="e.g. Flutter Mobile App Dev" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Duration:</label>
                        <input type="text" name="duration" placeholder="e.g. 8 Weeks" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Fee (INR):</label>
                        <input type="number" step="0.01" name="fee" placeholder="2500" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Total Seats:</label>
                        <input type="number" name="seats" placeholder="30" required>
                    </div>
                </div>
                <button type="submit" class="btn" style="margin-top: 15px;">Publish Course</button>
            </form>
        </div>

        <div class="card">
            <h3>ðŸ‘¥ Student Course Enrollments</h3>
            <table>
                <thead>
                    <tr><th>Enroll ID</th><th>Course Title</th><th>Student Name</th><th>Student Email</th><th>Enrolled Date</th><th>Status</th></tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> en : enrollments) { %>
                    <tr>
                        <td>#<%= en.get("enrollmentId") %></td>
                        <td><strong><%= en.get("title") %></strong></td>
                        <td><%= en.get("learnerName") %></td>
                        <td><%= en.get("email") %></td>
                        <td><%= en.get("enrolledAt") %></td>
                        <td><span class="badge badge-open"><%= en.get("status") %></span></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
