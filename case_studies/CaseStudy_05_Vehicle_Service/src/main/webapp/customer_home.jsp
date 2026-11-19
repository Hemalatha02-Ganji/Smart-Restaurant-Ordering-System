<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.VehicleDAO, java.util.List, java.util.Map" %>
<%
    String custId = (String) session.getAttribute("customerId");
    String custName = (String) session.getAttribute("customerName");
    if (custId == null) { response.sendRedirect("index.jsp"); return; }
    VehicleDAO dao = new VehicleDAO();
    List<Map<String, Object>> vehicles = dao.getCustomerVehicles(custId);
    List<Map<String, Object>> bookings = dao.getCustomerBookings(custId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard | Vehicle Service</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸš— Welcome, <%= custName %> (<%= custId %>)</h2>
        <a href="logout" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="container">
        <% if ("vehicle_added".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Vehicle registered successfully!</div>
        <% } %>
        <% if ("service_booked".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Service appointment booked successfully! Status: Pending.</div>
        <% } %>
        <% if ("slot_conflict".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: This vehicle is already booked for this specific Date and Time slot!</div>
        <% } %>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <div class="card">
                <h3>ðŸš˜ Register Vehicle</h3>
                <form action="addVehicle" method="post">
                    <div class="form-group">
                        <label>Registration Number:</label>
                        <input type="text" name="regNumber" placeholder="e.g. AP16-BK-9999" required>
                    </div>
                    <div class="form-group">
                        <label>Vehicle Make:</label>
                        <input type="text" name="make" placeholder="e.g. Maruti Suzuki / Honda" required>
                    </div>
                    <div class="form-group">
                        <label>Vehicle Model:</label>
                        <input type="text" name="model" placeholder="e.g. Swift / City" required>
                    </div>
                    <div class="form-group">
                        <label>Manufacturing Year:</label>
                        <input type="number" name="year" min="2000" max="2026" value="2023" required>
                    </div>
                    <button type="submit" class="btn">Register Vehicle</button>
                </form>
            </div>

            <div class="card">
                <h3>ðŸ“… Book Service Slot</h3>
                <% if (vehicles.isEmpty()) { %>
                    <p style="color: #666;">Please register at least one vehicle before booking a service slot.</p>
                <% } else { %>
                    <form action="bookService" method="post">
                        <div class="form-group">
                            <label>Select Your Vehicle:</label>
                            <select name="vehicleId" required>
                                <% for (Map<String, Object> v : vehicles) { %>
                                    <option value="<%= v.get("vehicleId") %>">
                                        <%= v.get("regNumber") %> - <%= v.get("make") %> <%= v.get("model") %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Service Type:</label>
                            <select name="serviceType" required>
                                <option value="General Periodic Service">General Periodic Service</option>
                                <option value="Oil & Filter Replacement">Oil & Filter Replacement</option>
                                <option value="Brake System Inspection">Brake System Inspection</option>
                                <option value="Wheel Alignment & Balancing">Wheel Alignment & Balancing</option>
                                <option value="Major Engine Diagnostics">Major Engine Diagnostics</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Preferred Date:</label>
                            <input type="date" name="date" required>
                        </div>
                        <div class="form-group">
                            <label>Time Slot:</label>
                            <select name="timeSlot" required>
                                <option value="09:00 AM - 11:00 AM">09:00 AM - 11:00 AM</option>
                                <option value="11:30 AM - 01:30 PM">11:30 AM - 01:30 PM</option>
                                <option value="02:30 PM - 04:30 PM">02:30 PM - 04:30 PM</option>
                            </select>
                        </div>
                        <button type="submit" class="btn">Book Service Appointment</button>
                    </form>
                <% } %>
            </div>
        </div>

        <div class="card">
            <h3>ðŸ“œ My Service History</h3>
            <table>
                <thead>
                    <tr><th>Booking ID</th><th>Vehicle</th><th>Service Type</th><th>Date</th><th>Slot</th><th>Status</th></tr>
                </thead>
                <tbody>
                <% if (bookings.isEmpty()) { %>
                    <tr><td colspan="6" style="text-align: center;">No service bookings found.</td></tr>
                <% } else { for (Map<String, Object> b : bookings) { %>
                    <tr>
                        <td>#<%= b.get("bookingId") %></td>
                        <td><strong><%= b.get("vehicle") %></strong></td>
                        <td><%= b.get("serviceType") %></td>
                        <td><%= b.get("date") %></td>
                        <td><%= b.get("timeSlot") %></td>
                        <td>
                            <span class="badge badge-<%= ((String)b.get("status")).replace(" ", "-") %>">
                                <%= b.get("status") %>
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
