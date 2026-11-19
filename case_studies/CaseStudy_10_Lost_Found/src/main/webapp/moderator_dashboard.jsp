<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.LostFoundDAO, java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("role") == null || !"moderator".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp?err=access_denied"); return;
    }
    LostFoundDAO dao = new LostFoundDAO();
    List<Map<String, Object>> reports = dao.getAllReportsForModerator();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Moderator Dashboard | Lost & Found</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ” Moderator Operations Console</h2>
        <a href="logout" class="btn btn-sm" style="background: #dc2626;">Logout</a>
    </div>
    <div class="container">
        <% if ("hidden".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Report hidden from public board successfully.</div>
        <% } %>

        <div class="card">
            <h3>Campus Report Moderation &amp; Duplicate Removal</h3>
            <table>
                <thead>
                    <tr><th>ID</th><th>Type</th><th>Item Name</th><th>Category</th><th>Location</th><th>Reporter</th><th>Status</th><th>Action</th></tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> r : reports) { %>
                    <tr>
                        <td>#<%= r.get("reportId") %></td>
                        <td><span class="badge badge-<%= r.get("type") %>"><%= r.get("type") %></span></td>
                        <td><strong><%= r.get("name") %></strong></td>
                        <td><%= r.get("category") %></td>
                        <td><%= r.get("location") %></td>
                        <td><%= r.get("reporter") %></td>
                        <td><span class="badge badge-<%= r.get("status") %>"><%= r.get("status") %></span></td>
                        <td>
                            <% if (!"Hidden".equals(r.get("status"))) { %>
                                <form action="hideReport" method="post" style="margin: 0;">
                                    <input type="hidden" name="reportId" value="<%= r.get("reportId") %>">
                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Hide this report as duplicate/inappropriate?')">Hide</button>
                                </form>
                            <% } else { %>
                                <span style="color: #999;">Hidden</span>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
