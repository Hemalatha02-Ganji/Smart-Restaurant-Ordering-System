<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.DonationDAO, java.util.List, java.util.Map" %>
<%
    String donorId = (String) session.getAttribute("donorId");
    String donorName = (String) session.getAttribute("donorName");
    if (donorId == null) { response.sendRedirect("index.jsp"); return; }
    DonationDAO dao = new DonationDAO();
    List<Map<String, Object>> campaigns = dao.getActiveCampaigns();
    List<Map<String, Object>> myHistory = dao.getDonorHistory(donorId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Donor Portal | Community Campaigns</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ¤ Welcome, <%= donorName %> (<%= donorId %>)</h2>
        <a href="logout" class="btn btn-sm" style="background: #e76f51;">Logout</a>
    </div>
    <div class="container">
        <% if ("recorded".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Donation entry recorded successfully! Status: Pending Coordinator Verification.</div>
        <% } %>
        <% if ("duplicate_ref".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: This transaction Reference Number has already been submitted!</div>
        <% } %>

        <div class="card">
            <h3>ðŸŽ¯ Active Community Campaigns</h3>
            <table>
                <thead>
                    <tr><th>Campaign Title</th><th>Mission / Purpose</th><th>Target Goal</th><th>Verified Raised</th></tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> c : campaigns) { %>
                    <tr>
                        <td><strong><%= c.get("title") %></strong></td>
                        <td><%= c.get("purpose") %></td>
                        <td>â‚¹<%= String.format("%.2f", (Double)c.get("targetAmount")) %></td>
                        <td style="color: #2a9d8f; font-weight: bold;">
                            â‚¹<%= String.format("%.2f", (Double)c.get("verifiedTotal")) %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h3>ðŸ’³ Record a Contribution / Donation</h3>
            <form action="recordDonation" method="post">
                <div style="display: grid; grid-template-columns: 2fr 1fr 1fr; gap: 10px;">
                    <div class="form-group" style="margin: 0;">
                        <label>Select Campaign:</label>
                        <select name="campaignId" required>
                            <% for (Map<String, Object> c : campaigns) { %>
                                <option value="<%= c.get("campaignId") %>"><%= c.get("title") %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Donation Amount (INR):</label>
                        <input type="number" step="0.01" name="amount" placeholder="e.g. 500.00" min="1" required>
                    </div>
                    <div class="form-group" style="margin: 0;">
                        <label>Bank/UPI Ref Number:</label>
                        <input type="text" name="referenceNumber" placeholder="e.g. UPI-REF-99238" required>
                    </div>
                </div>
                <button type="submit" class="btn" style="margin-top: 15px;">Submit Donation Record</button>
            </form>
        </div>

        <div class="card">
            <h3>ðŸ“œ My Donation History</h3>
            <table>
                <thead>
                    <tr><th>ID</th><th>Campaign</th><th>Amount</th><th>Ref No</th><th>Date</th><th>Verification Status</th></tr>
                </thead>
                <tbody>
                <% if (myHistory.isEmpty()) { %>
                    <tr><td colspan="6" style="text-align: center;">No donations recorded yet.</td></tr>
                <% } else { for (Map<String, Object> d : myHistory) { %>
                    <tr>
                        <td>#<%= d.get("donationId") %></td>
                        <td><strong><%= d.get("campaign") %></strong></td>
                        <td>â‚¹<%= String.format("%.2f", (Double)d.get("amount")) %></td>
                        <td><%= d.get("refNo") %></td>
                        <td><%= d.get("date") %></td>
                        <td>
                            <span class="badge badge-<%= ((String)d.get("status")).replace(" ", "-") %>">
                                <%= d.get("status") %>
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
