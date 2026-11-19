<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.casestudy.dao.ClinicDAO, com.casestudy.model.*, java.util.List" %>
<%
    Patient p = (Patient) session.getAttribute("patient");
    if (p == null) { response.sendRedirect("index.jsp"); return; }
    ClinicDAO dao = new ClinicDAO();
    List<Appointment> myAppointments = dao.getPatientAppointments(p.getPatientId());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Portal | Clinic Appointments</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <h2>ðŸ¥ Welcome, <%= p.getPatientName() %> (ID: <%= p.getPatientId() %>)</h2>
        <a href="logout" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="container">
        <% if ("booked".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Appointment scheduled successfully! Status: PENDING confirmation.</div>
        <% } %>
        <% if ("slot_taken".equals(request.getParameter("err"))) { %>
            <div class="alert alert-danger">Error: The selected Doctor is already booked for this Date & Time slot! Please choose another slot.</div>
        <% } %>

        <div class="card">
            <h3>ðŸ“… Book a New Doctor Appointment</h3>
            <form action="bookAppointment" method="post">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group">
                        <label>Select Doctor & Specialization:</label>
                        <select name="doctorId" required>
                            <option value="1">Dr. Ramesh Sharma (Cardiology)</option>
                            <option value="2">Dr. Sunita Patel (Pediatrics)</option>
                            <option value="3">Dr. K. V. Rao (Orthopedics)</option>
                            <option value="4">Dr. Ananya Reddy (Dermatology)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Appointment Date:</label>
                        <input type="date" name="date" required>
                    </div>
                    <div class="form-group">
                        <label>Preferred Time Slot:</label>
                        <select name="timeSlot" required>
                            <option value="09:00 AM - 10:00 AM">09:00 AM - 10:00 AM</option>
                            <option value="10:00 AM - 11:00 AM">10:00 AM - 11:00 AM</option>
                            <option value="11:30 AM - 12:30 PM">11:30 AM - 12:30 PM</option>
                            <option value="02:00 PM - 03:00 PM">02:00 PM - 03:00 PM</option>
                            <option value="03:30 PM - 04:30 PM">03:30 PM - 04:30 PM</option>
                            <option value="05:00 PM - 06:00 PM">05:00 PM - 06:00 PM</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Reason for Visit:</label>
                        <input type="text" name="reason" placeholder="e.g. Regular Checkup / Joint Pain" required>
                    </div>
                </div>
                <button type="submit" class="btn">Confirm Appointment Booking</button>
            </form>
        </div>

        <div class="card">
            <h3>ðŸ“‹ My Appointments (Upcoming & Previous)</h3>
            <table>
                <thead>
                    <tr><th>App ID</th><th>Doctor</th><th>Specialization</th><th>Date</th><th>Time Slot</th><th>Reason</th><th>Status</th></tr>
                </thead>
                <tbody>
                <% if (myAppointments.isEmpty()) { %>
                    <tr><td colspan="7" style="text-align: center;">No appointments scheduled yet.</td></tr>
                <% } else { for (Appointment a : myAppointments) { %>
                    <tr>
                        <td>#<%= a.getAppointmentId() %></td>
                        <td><strong><%= a.getDoctorName() %></strong></td>
                        <td><%= a.getSpecialization() %></td>
                        <td><%= a.getAppointmentDate() %></td>
                        <td><%= a.getTimeSlot() %></td>
                        <td><%= a.getReason() %></td>
                        <td>
                            <span class="badge <%= "CONFIRMED".equals(a.getStatus()) ? "badge-confirmed" : ("CANCELLED".equals(a.getStatus()) ? "badge-cancelled" : "badge-pending") %>">
                                <%= a.getStatus() %>
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
