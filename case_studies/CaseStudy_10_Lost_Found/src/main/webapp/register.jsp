<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Registration | Lost & Found</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ” Campus Lost and Found Portal</h2>
        <a href="index.jsp">Back to Login</a>
    </div>
    <div class="container" style="max-width: 500px;">
        <div class="card">
            <h3>Student Registration</h3>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <form action="register" method="post">
                <div class="form-group">
                    <label>Student ID (Roll Number):</label>
                    <input type="text" name="studentId" placeholder="e.g. 24761A05S2" required>
                </div>
                <div class="form-group">
                    <label>Full Name:</label>
                    <input type="text" name="studentName" required>
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
                    <label>Password:</label>
                    <input type="password" name="password" minlength="4" required>
                </div>
                <button type="submit" class="btn" style="width: 100%;">Create Account</button>
            </form>
        </div>
    </div>
</body>
</html>
