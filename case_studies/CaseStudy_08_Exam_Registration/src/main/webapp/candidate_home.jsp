<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.ExamDAO, java.util.List, java.util.Map" %>
<%
    String candId = (String) session.getAttribute("candidateId");
    String candName = (String) session.getAttribute("candidateName");
    String roll = (String) session.getAttribute("rollNumber");
    if (candId == null) { response.sendRedirect("index.jsp"); return; }
    ExamDAO dao = new ExamDAO();
    List<Map<String, Object>> exams = dao.getAvailableExams();
    List<Map<String, Object>> mySchedule = dao.getCandidateSchedule(candId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Candidate Portal | Examination System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ“ Welcome, <%= candName %> (<%= roll %>)</h2>
        <a href="logout" class="btn btn-sm" style="background: #e53e3e;">Logout</a>
    </div>
    <div class="container">
        <% if ("registered".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Examination registration confirmed! Added to your schedule.</div>
        <% } %>
        <% if ("closed_or_expired".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Registration Error: The registration deadline has passed or registration is officially closed!</div>
        <% } %>
        <% if ("already_registered".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: You have already registered for this subject examination! Duplicate registration is not permitted.</div>
        <% } %>

        <div class="card">
            <h3>ðŸ“‘ Available Examinations for Registration</h3>
            <table>
                <thead>
                    <tr><th>Subject Code</th><th>Subject Name</th><th>Exam Date</th><th>Session</th><th>Deadline</th><th>Status</th><th>Action</th></tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> ex : exams) { 
                    boolean closed = (Boolean) ex.get("isClosed");
                %>
                    <tr>
                        <td><strong><%= ex.get("subjectCode") %></strong></td>
                        <td><%= ex.get("subjectName") %></td>
                        <td><%= ex.get("examDate") %></td>
                        <td><%= ex.get("session") %></td>
                        <td><%= ex.get("deadline") %></td>
                        <td>
                            <span class="badge <%= closed ? "badge-closed" : "badge-open" %>">
                                <%= closed ? "Closed" : "Open" %>
                            </span>
                        </td>
                        <td>
                            <% if (!closed) { %>
                                <form action="registerExam" method="post" style="margin: 0;">
                                    <input type="hidden" name="examId" value="<%= ex.get("examId") %>">
                                    <button type="submit" class="btn btn-success btn-sm">Register</button>
                                </form>
                            <% } else { %>
                                <span style="color: #999;">Registration Closed</span>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h3>ðŸ—“ï¸ My Registered Examination Schedule</h3>
            <table>
                <thead>
                    <tr><th>Subject Code</th><th>Subject Name</th><th>Date</th><th>Session</th><th>Status</th></tr>
                </thead>
                <tbody>
                <% if (mySchedule.isEmpty()) { %>
                    <tr><td colspan="5" style="text-align: center;">No examinations registered yet.</td></tr>
                <% } else { for (Map<String, Object> s : mySchedule) { %>
                    <tr>
                        <td><strong><%= s.get("subjectCode") %></strong></td>
                        <td><%= s.get("subjectName") %></td>
                        <td><%= s.get("examDate") %></td>
                        <td><%= s.get("session") %></td>
                        <td><span class="badge badge-open"><%= s.get("status") %></span></td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
