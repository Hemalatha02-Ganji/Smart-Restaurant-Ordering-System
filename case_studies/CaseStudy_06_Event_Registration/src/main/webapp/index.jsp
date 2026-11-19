<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Event Registration and Attendance Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸŽª Campus Event Registration &amp; Attendance Portal</h2>
    </div>
    <div class="container" style="max-width: 450px;">
        <div class="card">
            <h3>Login to Events Portal</h3>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>
            <form action="login" method="post">
                <div class="form-group">
                    <label>Role:</label>
                    <select name="role" required>
                        <option value="participant">Student / Participant</option>
                        <option value="organizer">Faculty / Event Organizer</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Participant ID / Email / Username:</label>
                    <input type="text" name="username" placeholder="e.g. PART101 or organizer" required>
                </div>
                <div class="form-group">
                    <label>Password:</label>
                    <input type="password" name="password" placeholder="Enter password" required>
                </div>
                <button type="submit" class="btn" style="width: 100%;">Sign In</button>
            </form>
            <p style="text-align: center; margin-top: 15px;">
                New Participant? <a href="register.jsp">Register Here</a>
            </p>
        </div>
    </div>
</body>
</html>
