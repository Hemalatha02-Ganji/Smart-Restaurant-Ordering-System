<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.LibraryDAO, com.casestudy.model.*, java.util.List" %>
<%
    Member m = (Member) session.getAttribute("member");
    if (m == null) { response.sendRedirect("index.jsp"); return; }
    LibraryDAO dao = new LibraryDAO();
    String keyword = request.getParameter("search");
    List<Resource> resources = dao.searchResources(keyword);
    List<Reservation> myReservations = dao.getMemberReservations(m.getMemberId());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Member Home | Library Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ“š Library Portal - Welcome, <%= m.getFullName() %> (<%= m.getMemberId() %>)</h2>
        <div>
            <a href="logout" class="btn btn-danger btn-sm">Logout</a>
        </div>
    </div>
    <div class="container">
        <% if ("reserved".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Reservation request submitted successfully! Pending approval.</div>
        <% } %>
        <% if ("unavailable".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: Resource is currently unavailable for reservation!</div>
        <% } %>

        <div class="card">
            <h3>ðŸ” Browse & Search Resources</h3>
            <form method="get" style="display: flex; gap: 10px;">
                <input type="text" name="search" placeholder="Search by title, author, or category..." value="<%= keyword != null ? keyword : "" %>">
                <button type="submit" class="btn">Search</button>
                <a href="member_home.jsp" class="btn" style="background: #6c757d;">Reset</a>
            </form>
            <table>
                <thead>
                    <tr>
                        <th>ID</th><th>Title</th><th>Author</th><th>Category</th><th>Status</th><th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Resource r : resources) { %>
                    <tr>
                        <td><%= r.getResourceId() %></td>
                        <td><strong><%= r.getTitle() %></strong></td>
                        <td><%= r.getAuthor() %></td>
                        <td><%= r.getCategory() %></td>
                        <td>
                            <span class="badge <%= "AVAILABLE".equals(r.getStatus()) ? "badge-available" : "badge-reserved" %>">
                                <%= r.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <% if ("AVAILABLE".equals(r.getStatus())) { %>
                                <form action="resourceAction" method="post" style="margin: 0;">
                                    <input type="hidden" name="action" value="reserve">
                                    <input type="hidden" name="resourceId" value="<%= r.getResourceId() %>">
                                    <button type="submit" class="btn btn-success btn-sm">Request Reservation</button>
                                </form>
                            <% } else { %>
                                <span style="color: #999; font-size: 13px;">Not Available</span>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h3>ðŸ“‘ View My Reservations</h3>
            <table>
                <thead>
                    <tr><th>Reservation ID</th><th>Resource Title</th><th>Requested Date</th><th>Status</th></tr>
                </thead>
                <tbody>
                <% if (myReservations.isEmpty()) { %>
                    <tr><td colspan="4" style="text-align: center;">No reservations requested yet.</td></tr>
                <% } else { for (Reservation res : myReservations) { %>
                    <tr>
                        <td>#<%= res.getReservationId() %></td>
                        <td><%= res.getResourceTitle() %></td>
                        <td><%= res.getRequestDate() %></td>
                        <td>
                            <span class="badge <%= "APPROVED".equals(res.getStatus()) ? "badge-available" : ("REJECTED".equals(res.getStatus()) ? "badge-reserved" : "badge-pending") %>">
                                <%= res.getStatus() %>
                            </span>
                        </td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
