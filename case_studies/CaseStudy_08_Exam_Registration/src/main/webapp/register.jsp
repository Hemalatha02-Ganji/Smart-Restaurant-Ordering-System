<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Candidate Registration | Exam Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ“ Online Examination Registration Portal</h2>
        <a href="index.jsp">Back to Login</a>
    </div>
    <div class="container" style="max-width: 500px;">
        <div class="card">
            <h3>Candidate Registration</h3>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <form action="register" method="post">
                <div class="form-group">
                    <label>Candidate ID:</label>
                    <input type="text" name="candidateId" placeholder="e.g. CAND102" required>
                </div>
                <div class="form-group">
                    <label>Full Name:</label>
                    <input type="text" name="candidateName" required>
                </div>
                <div class="form-group">
                    <label>Hall Ticket / Roll Number:</label>
                    <input type="text" name="rollNumber" placeholder="e.g. 24761A05S2" required>
                </div>
                <div class="form-group">
                    <label>Degree / Programme:</label>
                    <input type="text" name="programme" placeholder="e.g. B.Tech CSE" required>
                </div>
                <div class="form-group">
                    <label>Semester:</label>
                    <select name="semester" required>
                        <option value="I Semester">I Semester</option>
                        <option value="II Semester">II Semester</option>
                        <option value="III Semester">III Semester</option>
                        <option value="IV Semester">IV Semester</option>
                        <option value="V Semester">V Semester</option>
                        <option value="VI Semester">VI Semester</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Email ID:</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Password:</label>
                    <input type="password" name="password" minlength="4" required>
                </div>
                <button type="submit" class="btn" style="width: 100%;">Complete Registration</button>
            </form>
        </div>
    </div>
</body>
</html>
