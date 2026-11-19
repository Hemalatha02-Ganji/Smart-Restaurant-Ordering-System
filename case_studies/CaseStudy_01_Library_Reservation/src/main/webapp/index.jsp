<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Library Resource Reservation Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ“š Library Resource Reservation Portal</h2>
    </div>
    <div class="container" style="max-width: 450px;">
        <div class="card">
            <h3>Login to Portal</h3>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>
            <% if ("auth_required".equals(request.getParameter("err"))) { %>
                <div class="alert alert-danger">Please login to access protected pages.</div>
            <% } %>
            <form action="login" method="post">
                <div class="form-group">
                    <label>Login As:</label>
                    <select name="role" required>
                        <option value="member">Library Member (Student/Faculty)</option>
                        <option value="librarian">Librarian / Staff</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Member ID / Username:</label>
                    <input type="text" name="username" placeholder="e.g. MEM101 or librarian" required>
                </div>
                <div class="form-group">
                    <label>Password:</label>
                    <input type="password" name="password" placeholder="Enter password" required>
                </div>
                <button type="submit" class="btn" style="width: 100%;">Sign In</button>
            </form>
            <p style="text-align: center; margin-top: 15px;">
                New Member? <a href="register.jsp">Register Here</a>
            </p>
        </div>
    </div>
</body>
</html>
