<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.LostFoundDAO, java.util.List, java.util.Map" %>
<%
    String sId = (String) session.getAttribute("studentId");
    String sName = (String) session.getAttribute("studentName");
    if (sId == null) { response.sendRedirect("index.jsp"); return; }
    LostFoundDAO dao = new LostFoundDAO();
    String q = request.getParameter("query");
    String cat = request.getParameter("category");
    String loc = request.getParameter("location");
    String type = request.getParameter("type");
    List<Map<String, Object>> openReports = dao.searchOpenReports(q, cat, loc, type);
    List<Map<String, Object>> myReports = dao.getStudentReports(sId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Portal | Lost & Found</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ” Welcome, <%= sName %> (<%= sId %>)</h2>
        <a href="logout" class="btn btn-sm" style="background: #dc2626;">Logout</a>
    </div>
    <div class="container">
        <% if ("reported".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Item report posted successfully! Published to the public campus board.</div>
        <% } %>
        <% if ("resolved".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Report marked as Resolved! Thank you for updating.</div>
        <% } %>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <div class="card">
                <h3>ðŸ“¢ Report Lost / Found Item</h3>
                <form action="reportItem" method="post">
                    <div class="form-group">
                        <label>Report Type:</label>
                        <select name="reportType" required>
                            <option value="Lost">I LOST an item</option>
                            <option value="Found">I FOUND an item</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Item Name:</label>
                        <input type="text" name="itemName" placeholder="e.g. Dell Wireless Mouse" required>
                    </div>
                    <div class="form-group">
                        <label>Category:</label>
                        <select name="category" required>
                            <option value="Electronics">Electronics</option>
                            <option value="Books/ID">Books / College ID</option>
                            <option value="Accessories">Accessories</option>
                            <option value="Documents">Documents</option>
                            <option value="Others">Others</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Location on Campus:</label>
                        <input type="text" name="location" placeholder="e.g. Ground Floor Seminar Hall" required>
                    </div>
                    <div class="form-group">
                        <label>Date Lost/Found:</label>
                        <input type="date" name="itemDate" required>
                    </div>
                    <div class="form-group">
                        <label>Description &amp; Identifying Details:</label>
                        <textarea name="description" rows="2" placeholder="Color, brand, key marks..." required></textarea>
                    </div>
                    <button type="submit" class="btn">Post Report</button>
                </form>
            </div>

            <div class="card">
                <h3>ðŸ” Search Campus Reports</h3>
                <form method="get">
                    <div class="form-group">
                        <label>Search Keyword:</label>
                        <input type="text" name="query" placeholder="e.g. Calculator, Bag, ID..." value="<%= q != null ? q : "" %>">
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                        <div class="form-group">
                            <label>Category:</label>
                            <select name="category">
                                <option value="">-- All --</option>
                                <option value="Electronics" <%= "Electronics".equals(cat) ? "selected" : "" %>>Electronics</option>
                                <option value="Books/ID" <%= "Books/ID".equals(cat) ? "selected" : "" %>>Books / ID</option>
                                <option value="Accessories" <%= "Accessories".equals(cat) ? "selected" : "" %>>Accessories</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Report Type:</label>
                            <select name="type">
                                <option value="">-- All --</option>
                                <option value="Lost" <%= "Lost".equals(type) ? "selected" : "" %>>Lost</option>
                                <option value="Found" <%= "Found".equals(type) ? "selected" : "" %>>Found</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn">Filter</button>
                    <a href="student_home.jsp" class="btn" style="background: #6c757d;">Reset</a>
                </form>
            </div>
        </div>

        <div class="card">
            <h3>ðŸ“Œ Active Campus Lost &amp; Found Board</h3>
            <table>
                <thead>
                    <tr><th>Type</th><th>Item Name</th><th>Category</th><th>Location</th><th>Date</th><th>Description</th><th>Contact Reporter</th></tr>
                </thead>
                <tbody>
                <% if (openReports.isEmpty()) { %>
                    <tr><td colspan="7" style="text-align: center;">No matching open item reports found.</td></tr>
                <% } else { for (Map<String, Object> r : openReports) { %>
                    <tr>
                        <td><span class="badge badge-<%= r.get("type") %>"><%= r.get("type") %></span></td>
                        <td><strong><%= r.get("name") %></strong></td>
                        <td><%= r.get("category") %></td>
                        <td><%= r.get("location") %></td>
                        <td><%= r.get("date") %></td>
                        <td><%= r.get("description") %></td>
                        <td><%= r.get("reporter") %></td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h3>ðŸ“‘ Manage My Reported Items</h3>
            <table>
                <thead>
                    <tr><th>Type</th><th>Item Name</th><th>Category</th><th>Date</th><th>Status</th><th>Action</th></tr>
                </thead>
                <tbody>
                <% if (myReports.isEmpty()) { %>
                    <tr><td colspan="6" style="text-align: center;">You have not reported any items.</td></tr>
                <% } else { for (Map<String, Object> m : myReports) { %>
                    <tr>
                        <td><span class="badge badge-<%= m.get("type") %>"><%= m.get("type") %></span></td>
                        <td><strong><%= m.get("name") %></strong></td>
                        <td><%= m.get("category") %></td>
                        <td><%= m.get("date") %></td>
                        <td><span class="badge badge-<%= m.get("status") %>"><%= m.get("status") %></span></td>
                        <td>
                            <% if ("Open".equals(m.get("status"))) { %>
                                <form action="resolveReport" method="post" style="margin: 0;">
                                    <input type="hidden" name="reportId" value="<%= m.get("reportId") %>">
                                    <button type="submit" class="btn btn-success btn-sm">Mark Resolved</button>
                                </form>
                            <% } else { %>
                                <em><%= m.get("status") %></em>
                            <% } %>
                        </td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
