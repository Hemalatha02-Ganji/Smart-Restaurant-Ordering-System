package com.casestudy.dao;

import com.casestudy.model.*;
import com.casestudy.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClinicDAO {

    public boolean registerPatient(Patient p) throws SQLException {
        String sql = "INSERT INTO patients (patient_id, patient_name, dob, gender, phone, email, password) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getPatientId());
            ps.setString(2, p.getPatientName());
            ps.setDate(3, Date.valueOf(p.getDob()));
            ps.setString(4, p.getGender());
            ps.setString(5, p.getPhone());
            ps.setString(6, p.getEmail());
            ps.setString(7, p.getPassword());
            return ps.executeUpdate() > 0;
        }
    }

    public Patient loginPatient(String idOrEmail, String password) throws SQLException {
        String sql = "SELECT * FROM patients WHERE (patient_id = ? OR email = ?) AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, idOrEmail);
            ps.setString(2, idOrEmail);
            ps.setString(3, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Patient(rs.getString("patient_id"), rs.getString("patient_name"),
                            rs.getString("dob"), rs.getString("gender"), rs.getString("phone"),
                            rs.getString("email"), rs.getString("password"));
                }
            }
        }
        return null;
    }

    public boolean loginReceptionist(String username, String password) throws SQLException {
        String sql = "SELECT * FROM receptionists WHERE username = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean bookAppointment(String patientId, int doctorId, String date, String timeSlot, String reason) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND appointment_date = ? AND time_slot = ? AND status != 'CANCELLED'";
        String insertSql = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, time_slot, reason, status) VALUES (?, ?, ?, ?, ?, 'PENDING')";

        try (Connection con = DBUtil.getConnection()) {
            try (PreparedStatement check = con.prepareStatement(checkSql)) {
                check.setInt(1, doctorId);
                check.setDate(2, Date.valueOf(date));
                check.setString(3, timeSlot);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        return false; // Doctor slot already booked!
                    }
                }
            }
            try (PreparedStatement insert = con.prepareStatement(insertSql)) {
                insert.setString(1, patientId);
                insert.setInt(2, doctorId);
                insert.setDate(3, Date.valueOf(date));
                insert.setString(4, timeSlot);
                insert.setString(5, reason);
                return insert.executeUpdate() > 0;
            }
        }
    }

    public List<Appointment> getPatientAppointments(String patientId) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, d.doctor_name, d.specialization FROM appointments a JOIN doctors d ON a.doctor_id = d.doctor_id WHERE a.patient_id = ? ORDER BY a.appointment_date DESC, a.time_slot ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment app = new Appointment();
                    app.setAppointmentId(rs.getInt("appointment_id"));
                    app.setPatientId(rs.getString("patient_id"));
                    app.setDoctorId(rs.getInt("doctor_id"));
                    app.setDoctorName(rs.getString("doctor_name"));
                    app.setSpecialization(rs.getString("specialization"));
                    app.setAppointmentDate(rs.getString("appointment_date"));
                    app.setTimeSlot(rs.getString("time_slot"));
                    app.setReason(rs.getString("reason"));
                    app.setStatus(rs.getString("status"));
                    list.add(app);
                }
            }
        }
        return list;
    }

    public List<Appointment> getAppointmentsByDate(String date) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, d.doctor_name, d.specialization, p.patient_name FROM appointments a " +
                     "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "JOIN patients p ON a.patient_id = p.patient_id ";
        if (date != null && !date.trim().isEmpty()) {
            sql += "WHERE a.appointment_date = ? ";
        }
        sql += "ORDER BY a.appointment_date DESC, a.time_slot ASC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (date != null && !date.trim().isEmpty()) {
                ps.setDate(1, Date.valueOf(date.trim()));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment app = new Appointment();
                    app.setAppointmentId(rs.getInt("appointment_id"));
                    app.setPatientId(rs.getString("patient_id"));
                    app.setPatientName(rs.getString("patient_name"));
                    app.setDoctorId(rs.getInt("doctor_id"));
                    app.setDoctorName(rs.getString("doctor_name"));
                    app.setSpecialization(rs.getString("specialization"));
                    app.setAppointmentDate(rs.getString("appointment_date"));
                    app.setTimeSlot(rs.getString("time_slot"));
                    app.setReason(rs.getString("reason"));
                    app.setStatus(rs.getString("status"));
                    list.add(app);
                }
            }
        }
        return list;
    }

    public boolean updateAppointmentStatus(int appointmentId, String status) throws SQLException {
        String sql = "UPDATE appointments SET status = ? WHERE appointment_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        }
    }
}
