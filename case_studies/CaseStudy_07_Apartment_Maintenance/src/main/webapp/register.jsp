<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Resident Registration | Maintenance System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ¢ Apartment Maintenance Portal</h2>
        <a href="index.jsp">Back to Login</a>
    </div>
    <div class="container" style="max-width: 500px;">
        <div class="card">
            <h3>New Resident Registration</h3>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <form action="register" method="post">
                <div class="form-group">
                    <label>Resident ID:</label>
                    <input type="text" name="residentId" placeholder="e.g. RES102" required>
                </div>
                <div class="form-group">
                    <label>Resident Full Name:</label>
                    <input type="text" name="residentName" required>
                </div>
                <div class="form-group">
                    <label>Apartment / Flat Number:</label>
                    <input type="text" name="apartmentNumber" placeholder="e.g. Flat 301, Block A" required>
                </div>
                <div class="form-group">
                    <label>Phone Number:</label>
                    <input type="tel" name="phone" required>
                </div>
                <div class="form-group">
                    <label>Email ID:</label>
                    <input type="email" name="email" required>
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
