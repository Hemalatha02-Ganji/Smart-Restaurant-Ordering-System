<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Registration | Internship Tracker</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ’¼ Campus Internship Application Tracker</h2>
        <a href="index.jsp">Back to Login</a>
    </div>
    <div class="container" style="max-width: 500px;">
        <div class="card">
            <h3>New Student Registration</h3>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <form action="register" method="post">
                <div class="form-group">
                    <label>Roll Number:</label>
                    <input type="text" name="rollNumber" placeholder="e.g. 24761A05S2" required>
                </div>
                <div class="form-group">
                    <label>Student Full Name:</label>
                    <input type="text" name="studentName" required>
                </div>
                <div class="form-group">
                    <label>Branch / Department:</label>
                    <input type="text" name="branch" placeholder="e.g. CSE" required>
                </div>
                <div class="form-group">
                    <label>Semester:</label>
                    <select name="semester" required>
                        <option value="V Semester">V Semester</option>
                        <option value="VI Semester">VI Semester</option>
                        <option value="VII Semester">VII Semester</option>
                        <option value="VIII Semester">VIII Semester</option>
                    </select>
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
