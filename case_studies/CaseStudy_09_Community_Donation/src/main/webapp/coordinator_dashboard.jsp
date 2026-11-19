<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.DonationDAO, java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("role") == null || !"coordinator".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp?err=access_denied"); return;
    }
    DonationDAO dao = new DonationDAO();
    List<Map<String, Object>> campaigns = dao.getActiveCampaigns();
    String campStr = request.getParameter("campaignId");
    Integer campId = (campStr != null && !campStr.isEmpty()) ? Integer.parseInt(campStr) : null;
    String status = request.getParameter("status");
    List<Map<String, Object>> donations = dao.getAllDonations(campId, status);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Coordinator Dashboard | Donation Verification</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ¤ Donation Campaign Coordinator Console</h2>
        <a href="logout" class="btn btn-sm" style="background: #e76f51;">Logout</a>
    </div>
    <div class="container">
        <% if ("status_updated".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Donation entry updated! Verified donations added to campaign total.</div>
        <% } %>

        <div class="card">
            <h3>Filter Donations</h3>
            <form method="get" style="display: flex; gap: 15px; align-items: flex-end;">
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Campaign:</label>
                    <select name="campaignId">
                        <option value="">-- All Campaigns --</option>
                        <% for (Map<String, Object> c : campaigns) { %>
                            <option value="<%= c.get("campaignId") %>" <%= (campId != null && (Integer)c.get("campaignId") == campId) ? "selected" : "" %>>
                                <%= c.get("title") %>
                            </option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label>Status:</label>
                    <select name="status">
                        <option value="">-- All Statuses --</option>
                        <option value="Pending Verification" <%= "Pending Verification".equals(status) ? "selected" : "" %>>Pending Verification</option>
                        <option value="Verified" <%= "Verified".equals(status) ? "selected" : "" %>>Verified</option>
                        <option value="Rejected" <%= "Rejected".equals(status) ? "selected" : "" %>>Rejected</option>
                    </select>
                </div>
                <button type="submit" class="btn">Filter</button>
                <a href="coordinator_dashboard.jsp" class="btn" style="background: #6c757d;">Reset</a>
            </form>
        </div>

        <div class="card">
            <h3>Community Donations Audit Roster</h3>
            <table>
                <thead>
                    <tr><th>ID</th><th>Donor</th><th>Campaign</th><th>Amount</th><th>Ref No</th><th>Date</th><th>Status</th><th>Verification Action</th></tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> d : donations) { %>
                    <tr>
                        <td>#<%= d.get("donationId") %></td>
                        <td><%= d.get("donor") %></td>
                        <td><%= d.get("campaign") %></td>
                        <td><strong>â‚¹<%= String.format("%.2f", (Double)d.get("amount")) %></strong></td>
                        <td><code><%= d.get("refNo") %></code></td>
                        <td><%= d.get("date") %></td>
                        <td>
                            <span class="badge badge-<%= ((String)d.get("status")).replace(" ", "-") %>">
                                <%= d.get("status") %>
                            </span>
                        </td>
                        <td>
                            <% if ("Pending Verification".equals(d.get("status"))) { %>
                                <form action="updateDonation" method="post" style="display: inline;">
                                    <input type="hidden" name="donationId" value="<%= d.get("donationId") %>">
                                    <input type="hidden" name="status" value="Verified">
                                    <button type="submit" class="btn btn-sm" style="background: #2a9d8f;">Verify &amp; Add</button>
                                </form>
                                <form action="updateDonation" method="post" style="display: inline;">
                                    <input type="hidden" name="donationId" value="<%= d.get("donationId") %>">
                                    <input type="hidden" name="status" value="Rejected">
                                    <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                                </form>
                            <% } else { %>
                                <em><%= d.get("status") %></em>
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
