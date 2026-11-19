<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.ExamDAO, java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("role") == null || !"officer".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp?err=access_denied"); return;
    }
    ExamDAO dao = new ExamDAO();
    List<Map<String, Object>> exams = dao.getAvailableExams();
    String selExamStr = request.getParameter("examId");
    int selExamId = (selExamStr != null && !selExamStr.isEmpty()) ? Integer.parseInt(selExamStr) : (exams.isEmpty() ? 0 : (Integer)exams.get(0).get("examId"));
    List<Map<String, Object>> candidates = (selExamId > 0) ? dao.getCandidateListBySubject(selExamId) : java.util.Collections.emptyList();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Examination Officer Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ“ Examination Controller Control Desk</h2>
        <a href="logout" class="btn btn-sm" style="background: #e53e3e;">Logout</a>
    </div>
    <div class="container">
        <% if ("exam_added".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">New subject examination schedule published successfully!</div>
        <% } %>
        <% if ("registration_closed".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Examination registration officially closed!</div>
        <% } %>

        <div class="card">
            <h3>âž• Add / Schedule Examination</h3>
            <form action="addExam" method="post">
                <div style="display: grid; grid-template-columns: 1fr 2fr 1fr; gap: 10px;">
                    <div class="form-group" style="margin: 0;">
                        <label>Subject Code:</label>
                        <input type="text" name="subjectCode" placeholder="e.g. 20CS504" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Subject Title:</label>
                        <input type="text" name="subjectName" placeholder="e.g. Computer Networks" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Exam Date:</label>
                        <input type="date" name="examDate" required>
                    </div>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 10px;">
                    <div class="form-group" style="margin: 0;">
                        <label>Session Timing:</label>
                        <select name="session" required>
                            <option value="FN (09:30 AM - 12:30 PM)">FN (09:30 AM - 12:30 PM)</option>
                            <option value="AN (02:00 PM - 05:00 PM)">AN (02:00 PM - 05:00 PM)</option>
                        </select>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Registration Deadline:</label>
                        <input type="date" name="deadline" required>
                    </div>
                </div>
                <button type="submit" class="btn" style="margin-top: 15px;">Publish Examination</button>
            </form>
        </div>

        <div class="card">
            <h3>ðŸ‘¥ Registered Candidates Roster &amp; Close Registration</h3>
            <form method="get" style="display: flex; gap: 10px; align-items: flex-end; margin-bottom: 15px;">
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Select Subject Exam:</label>
                    <select name="examId" onchange="this.form.submit()">
                        <% for (Map<String, Object> ex : exams) { %>
                            <option value="<%= ex.get("examId") %>" <%= ((Integer)ex.get("examId") == selExamId) ? "selected" : "" %>>
                                <%= ex.get("subjectCode") %> - <%= ex.get("subjectName") %> (<%= (Boolean)ex.get("isClosed") ? "Closed" : "Open" %>)
                            </option>
                        <% } %>
                    </select>
                </div>
            </form>

            <div style="margin-bottom: 15px;">
                <form action="closeRegistration" method="post" style="display: inline;">
                    <input type="hidden" name="examId" value="<%= selExamId %>">
                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to close registrations for this subject?')">
                        ðŸ”’ Close Registrations for this Subject
                    </button>
                </form>
            </div>

            <table>
                <thead>
                    <tr><th>Roll Number</th><th>Candidate Name</th><th>Programme</th><th>Semester</th><th>Status</th></tr>
                </thead>
                <tbody>
                <% if (candidates.isEmpty()) { %>
                    <tr><td colspan="5" style="text-align: center;">No candidates registered for this subject yet.</td></tr>
                <% } else { for (Map<String, Object> c : candidates) { %>
                    <tr>
                        <td><strong><%= c.get("roll") %></strong></td>
                        <td><%= c.get("name") %></td>
                        <td><%= c.get("programme") %></td>
                        <td><%= c.get("semester") %></td>
                        <td><span class="badge badge-open"><%= c.get("status") %></span></td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
