<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Laboratory Equipment Issue Register</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ”¬ Laboratory Equipment Issue Register</h2>
    </div>
    <div class="container" style="max-width: 450px;">
        <div class="card">
            <h3>Staff &amp; Assistant Login</h3>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <form action="login" method="post">
                <div class="form-group">
                    <label>Staff ID:</label>
                    <input type="text" name="staffId" placeholder="e.g. lab_asst or supervisor" required>
                </div>
                <div class="form-group">
                    <label>Password:</label>
                    <input type="password" name="password" placeholder="Enter password" required>
                </div>
                <button type="submit" class="btn" style="width: 100%;">Sign In</button>
            </form>
            <div style="background: #f8fafc; padding: 12px; border-radius: 5px; margin-top: 15px; font-size: 13px;">
                <strong>Default Accounts:</strong><br>
                Assistant: <code>lab_asst</code> / <code>admin123</code><br>
                Supervisor: <code>supervisor</code> / <code>admin123</code>
            </div>
        </div>
    </div>
</body>
</html>
