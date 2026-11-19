<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Donor Registration | Donation Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ¤ Community Donation Tracking Portal</h2>
        <a href="index.jsp">Back to Login</a>
    </div>
    <div class="container" style="max-width: 500px;">
        <div class="card">
            <h3>New Donor Registration</h3>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <form action="register" method="post">
                <div class="form-group">
                    <label>Donor ID:</label>
                    <input type="text" name="donorId" placeholder="e.g. DONOR102" required>
                </div>
                <div class="form-group">
                    <label>Donor Full Name:</label>
                    <input type="text" name="donorName" required>
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
                <button type="submit" class="btn" style="width: 100%;">Complete Registration</button>
            </form>
        </div>
    </div>
</body>
</html>
