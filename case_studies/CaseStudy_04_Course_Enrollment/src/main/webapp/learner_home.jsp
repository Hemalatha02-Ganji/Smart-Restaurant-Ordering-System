<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.CourseDAO, com.casestudy.model.Course, java.util.List, java.util.Map" %>
<%
    String lrnId = (String) session.getAttribute("learnerId");
    String lrnName = (String) session.getAttribute("learnerName");
    if (lrnId == null) { response.sendRedirect("index.jsp"); return; }
    CourseDAO dao = new CourseDAO();
    String search = request.getParameter("search");
    List<Course> courses = dao.searchCourses(search);
    List<Map<String, Object>> myEnrollments = dao.getLearnerEnrollments(lrnId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Learner Home | Course Catalog</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸŽ“ Welcome, <%= lrnName %> (<%= lrnId %>)</h2>
        <a href="logout" class="btn btn-danger btn-sm" style="background: #e63946;">Logout</a>
    </div>
    <div class="container">
        <% if ("enrolled".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Course enrollment confirmed! Seat reserved successfully.</div>
        <% } %>
        <% if ("no_seats".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: Sorry, all seats for this course are fully booked!</div>
        <% } %>
        <% if ("duplicate_or_error".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: You are already enrolled in this course! Duplicate enrollment is not allowed.</div>
        <% } %>

        <div class="card">
            <h3>ðŸ“– Available Course Catalogue</h3>
            <form method="get" style="display: flex; gap: 10px;">
                <input type="text" name="search" placeholder="Search by course title or duration..." value="<%= search != null ? search : "" %>">
                <button type="submit" class="btn">Search</button>
                <a href="learner_home.jsp" class="btn" style="background: #6c757d;">Reset</a>
            </form>
            <table>
                <thead>
                    <tr><th>Course Title</th><th>Duration</th><th>Fee (INR)</th><th>Available Seats</th><th>Action</th></tr>
                </thead>
                <tbody>
                <% for (Course c : courses) { %>
                    <tr>
                        <td><strong><%= c.getTitle() %></strong></td>
                        <td><%= c.getDuration() %></td>
                        <td>â‚¹<%= String.format("%.2f", c.getFee()) %></td>
                        <td>
                            <span class="badge <%= c.getAvailableSeats() > 0 ? "badge-open" : "badge-full" %>">
                                <%= c.getAvailableSeats() %> / <%= c.getTotalSeats() %> Left
                            </span>
                        </td>
                        <td>
                            <% if (c.getAvailableSeats() > 0) { %>
                                <form action="enrollCourse" method="post" style="margin: 0;">
                                    <input type="hidden" name="courseId" value="<%= c.getCourseId() %>">
                                    <button type="submit" class="btn btn-success btn-sm">Enroll Now</button>
                                </form>
                            <% } else { %>
                                <span style="color: #999;">Seats Full</span>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h3>ðŸ“‘ My Active Enrollments</h3>
            <table>
                <thead>
                    <tr><th>Enroll ID</th><th>Course Title</th><th>Duration</th><th>Course Fee</th><th>Enrolled Date</th><th>Status</th></tr>
                </thead>
                <tbody>
                <% if (myEnrollments.isEmpty()) { %>
                    <tr><td colspan="6" style="text-align: center;">You have not enrolled in any course yet.</td></tr>
                <% } else { for (Map<String, Object> e : myEnrollments) { %>
                    <tr>
                        <td>#<%= e.get("enrollmentId") %></td>
                        <td><strong><%= e.get("title") %></strong></td>
                        <td><%= e.get("duration") %></td>
                        <td>â‚¹<%= String.format("%.2f", (Double)e.get("fee")) %></td>
                        <td><%= e.get("enrolledAt") %></td>
                        <td><span class="badge badge-open"><%= e.get("status") %></span></td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
