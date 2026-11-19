<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Applicant Registration | Hostel Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ  Hostel Room Allocation Portal</h2>
        <a href="index.jsp">Back to Login</a>
    </div>
    <div class="container" style="max-width: 500px;">
        <div class="card">
            <h3>New Hostel Registration Form</h3>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <form action="register" method="post">
                <div class="form-group">
                    <label>Application Number:</label>
                    <input type="text" name="applicationNumber" placeholder="e.g. APP-2026-101" required>
                </div>
                <div class="form-group">
                    <label>Student Name:</label>
                    <input type="text" name="studentName" required>
                </div>
                <div class="form-group">
                    <label>Roll Number:</label>
                    <input type="text" name="rollNumber" placeholder="e.g. 24761A05S2" required>
                </div>
                <div class="form-group">
                    <label>Year of Study:</label>
                    <select name="year" required>
                        <option value="I Year">I Year</option>
                        <option value="II Year">II Year</option>
                        <option value="III Year">III Year</option>
                        <option value="IV Year">IV Year</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Branch / Department:</label>
                    <input type="text" name="branch" placeholder="e.g. CSE" required>
                </div>
                <div class="form-group">
                    <label>Phone Number:</label>
                    <input type="tel" name="phone" required>
                </div>
                <div class="form-group">
                    <label>Preferred Hostel Block:</label>
                    <select name="preferredHostel" required>
                        <option value="Block A (Boys)">Block A (Boys)</option>
                        <option value="Block B (Girls)">Block B (Girls)</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Password:</label>
                    <input type="password" name="password" minlength="4" required>
                </div>
                <button type="submit" class="btn" style="width: 100%;">Submit Registration</button>
            </form>
        </div>
    </div>
</body>
</html>
