<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Participant Registration | Event Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸŽª Campus Event Registration &amp; Attendance Portal</h2>
        <a href="index.jsp">Back to Login</a>
    </div>
    <div class="container" style="max-width: 500px;">
        <div class="card">
            <h3>New Participant Registration</h3>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <form action="register" method="post">
                <div class="form-group">
                    <label>Participant ID (Roll No / College ID):</label>
                    <input type="text" name="participantId" placeholder="e.g. 24761A05S2" required>
                </div>
                <div class="form-group">
                    <label>Full Name:</label>
                    <input type="text" name="participantName" required>
                </div>
                <div class="form-group">
                    <label>Email ID:</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Phone Number:</label>
                    <input type="tel" name="phone" required>
                </div>
                <div class="form-group">
                    <label>Institution / College:</label>
                    <input type="text" name="institution" placeholder="e.g. LBRCE Autonomous" required>
                </div>
                <div class="form-group">
                    <label>Password:</label>
                    <input type="password" name="password" minlength="4" required>
                </div>
                <button type="submit" class="btn" style="width: 100%;">Create Account</button>
            </form>
        </div>
    </div>
</body>
</html>
