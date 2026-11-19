package com.clinic.dao;

import com.clinic.model.Appointment;
import com.clinic.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Enterprise Data Access Object for Appointment Management.
 * Implements strict concurrency protection to prevent double-booking.
 * 
 * Developer: Hemalatha Ganji (Roll No: 24761A05S2)
 */
public class AppointmentDAO {

    /**
     * Checks if a doctor already has an active appointment for the given date and time slot.
     */
    public boolean isSlotBooked(int doctorId, Date appointmentDate, String timeSlot) {
        String sql = "SELECT COUNT(*) FROM appointments " +
                     "WHERE doctor_id = ? AND appointment_date = ? AND time_slot = ? AND status != 'Cancelled'";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setDate(2, appointmentDate);
            ps.setString(3, timeSlot);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Books an appointment using a transactional check to eliminate race conditions.
     * Prevents duplicate slot bookings for the same doctor.
     */
    public boolean bookAppointment(Appointment apt) throws SQLException {
        Connection conn = null;
        PreparedStatement checkPs = null;
        PreparedStatement insertPs = null;
        PreparedStatement logPs = null;
        ResultSet rs = null;

        try {
            conn = DBConnectionUtil.getConnection();
            conn.setAutoCommit(false); // Begin Transaction

            // 1. Pessimistic check with row locking
            String checkSql = "SELECT COUNT(*) FROM appointments " +
                             "WHERE doctor_id = ? AND appointment_date = ? AND time_slot = ? AND status != 'Cancelled' FOR UPDATE";
            checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, apt.getDoctorId());
            checkPs.setDate(2, apt.getAppointmentDate());
            checkPs.setString(3, apt.getTimeSlot());
            rs = checkPs.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                // Duplicate booking detected! Rollback and reject.
                conn.rollback();
                return false;
            }

            // 2. Generate unique Token
            String token = "APT-" + LocalDate.now().getYear() + "-" + (1000 + (int)(Math.random() * 9000));
            apt.setAppointmentToken(token);

            // 3. Insert Appointment with initial status 'Pending'
            String insertSql = "INSERT INTO appointments (appointment_token, patient_id, doctor_id, appointment_date, time_slot, reason, status, notes) " +
                              "VALUES (?, ?, ?, ?, ?, ?, 'Pending', ?)";
            insertPs = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);
            insertPs.setString(1, apt.getAppointmentToken());
            insertPs.setString(2, apt.getPatientId());
            insertPs.setInt(3, apt.getDoctorId());
            insertPs.setDate(4, apt.getAppointmentDate());
            insertPs.setString(5, apt.getTimeSlot());
            insertPs.setString(6, apt.getReason());
            insertPs.setString(7, apt.getNotes() != null ? apt.getNotes() : "Online booking request");

            int affected = insertPs.executeUpdate();
            if (affected == 0) {
                conn.rollback();
                return false;
            }

            // Retrieve generated key
            int generatedId = 0;
            try (ResultSet genKeys = insertPs.getGeneratedKeys()) {
                if (genKeys.next()) {
                    generatedId = genKeys.getInt(1);
                    apt.setAppointmentId(generatedId);
                }
            }

            // 4. Audit Log entry
            String logSql = "INSERT INTO appointment_audit_log (appointment_id, action, performed_by, old_status, new_status, remarks) " +
                           "VALUES (?, 'BOOK_APPOINTMENT', ?, NULL, 'Pending', 'Created by patient online')";
            logPs = conn.prepareStatement(logSql);
            logPs.setInt(1, generatedId);
            logPs.setString(2, apt.getPatientId());
            logPs.executeUpdate();

            conn.commit(); // Transaction Successful
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { /* ignore */ }
            }
            throw e;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (checkPs != null) try { checkPs.close(); } catch (SQLException e) {}
            if (insertPs != null) try { insertPs.close(); } catch (SQLException e) {}
            if (logPs != null) try { logPs.close(); } catch (SQLException e) {}
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {}
            }
        }
    }

    /**
     * Retrieves all appointments for a specific patient.
     */
    public List<Appointment> getAppointmentsByPatient(String patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, d.doctor_name, d.specialization, d.room_number, d.consultation_fee, " +
                     "p.patient_name, p.phone AS patient_phone, p.email AS patient_email " +
                     "FROM appointments a " +
                     "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "WHERE a.patient_id = ? " +
                     "ORDER BY a.appointment_date DESC, a.created_at DESC";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAppointment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves appointments with optional filtering by Date, Doctor ID, and Status.
     */
    public List<Appointment> getAppointmentsByFilter(Date date, Integer doctorId, String status) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT a.*, d.doctor_name, d.specialization, d.room_number, d.consultation_fee, " +
            "p.patient_name, p.phone AS patient_phone, p.email AS patient_email, p.gender AS patient_gender, p.dob AS patient_dob " +
            "FROM appointments a " +
            "JOIN doctors d ON a.doctor_id = d.doctor_id " +
            "JOIN patients p ON a.patient_id = p.patient_id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (date != null) {
            sql.append("AND a.appointment_date = ? ");
            params.add(date);
        }
        if (doctorId != null && doctorId > 0) {
            sql.append("AND a.doctor_id = ? ");
            params.add(doctorId);
        }
        if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("ALL")) {
            sql.append("AND a.status = ? ");
            params.add(status);
        }

        sql.append("ORDER BY a.appointment_date ASC, a.time_slot ASC");

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Date) {
                    ps.setDate(i + 1, (Date) p);
                } else if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                } else {
                    ps.setString(i + 1, p.toString());
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAppointment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Updates an appointment's status (Confirmed, Cancelled, Completed) with an audit record.
     */
    public boolean updateStatus(int appointmentId, String newStatus, String remarks, String performedBy) {
        String fetchSql = "SELECT status FROM appointments WHERE appointment_id = ?";
        String updateSql = "UPDATE appointments SET status = ?, notes = CONCAT(IFNULL(notes,''), ' | ', ?) WHERE appointment_id = ?";
        String logSql = "INSERT INTO appointment_audit_log (appointment_id, action, performed_by, old_status, new_status, remarks) " +
                       "VALUES (?, 'STATUS_UPDATE', ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnectionUtil.getConnection();
            conn.setAutoCommit(false);

            String oldStatus = "";
            try (PreparedStatement psFetch = conn.prepareStatement(fetchSql)) {
                psFetch.setInt(1, appointmentId);
                try (ResultSet rs = psFetch.executeQuery()) {
                    if (rs.next()) {
                        oldStatus = rs.getString("status");
                    }
                }
            }

            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                psUpdate.setString(1, newStatus);
                psUpdate.setString(2, remarks != null ? remarks : "Updated by " + performedBy);
                psUpdate.setInt(3, appointmentId);
                psUpdate.executeUpdate();
            }

            try (PreparedStatement psLog = conn.prepareStatement(logSql)) {
                psLog.setInt(1, appointmentId);
                psLog.setString(2, performedBy);
                psLog.setString(3, oldStatus);
                psLog.setString(4, newStatus);
                psLog.setString(5, remarks);
                psLog.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {}
            }
        }
    }

    /**
     * Retrieves an Appointment by its Primary ID.
     */
    public Appointment getAppointmentById(int appointmentId) {
        String sql = "SELECT a.*, d.doctor_name, d.specialization, d.room_number, d.consultation_fee, " +
                     "p.patient_name, p.phone AS patient_phone, p.email AS patient_email, p.gender AS patient_gender, p.dob AS patient_dob " +
                     "FROM appointments a " +
                     "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "WHERE a.appointment_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAppointment(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves an Appointment by its Token.
     */
    public Appointment getAppointmentByToken(String token) {
        String sql = "SELECT a.*, d.doctor_name, d.specialization, d.room_number, d.consultation_fee, " +
                     "p.patient_name, p.phone AS patient_phone, p.email AS patient_email, p.gender AS patient_gender, p.dob AS patient_dob " +
                     "FROM appointments a " +
                     "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "WHERE a.appointment_token = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAppointment(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Dashboard statistics for receptionists.
     */
    public Map<String, Integer> getDashboardMetrics() {
        Map<String, Integer> metrics = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) AS total_count, " +
                     "SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END) AS pending_count, " +
                     "SUM(CASE WHEN status = 'Confirmed' THEN 1 ELSE 0 END) AS confirmed_count, " +
                     "SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_count, " +
                     "SUM(CASE WHEN appointment_date = CURDATE() THEN 1 ELSE 0 END) AS today_count " +
                     "FROM appointments";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                metrics.put("total", rs.getInt("total_count"));
                metrics.put("pending", rs.getInt("pending_count"));
                metrics.put("confirmed", rs.getInt("confirmed_count"));
                metrics.put("cancelled", rs.getInt("cancelled_count"));
                metrics.put("today", rs.getInt("today_count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return metrics;
    }

    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment apt = new Appointment();
        apt.setAppointmentId(rs.getInt("appointment_id"));
        apt.setAppointmentToken(rs.getString("appointment_token"));
        apt.setPatientId(rs.getString("patient_id"));
        apt.setDoctorId(rs.getInt("doctor_id"));
        apt.setAppointmentDate(rs.getDate("appointment_date"));
        apt.setTimeSlot(rs.getString("time_slot"));
        apt.setReason(rs.getString("reason"));
        apt.setStatus(rs.getString("status"));
        apt.setNotes(rs.getString("notes"));
        apt.setCreatedAt(rs.getTimestamp("created_at"));
        apt.setUpdatedAt(rs.getTimestamp("updated_at"));

        apt.setDoctorName(rs.getString("doctor_name"));
        apt.setDoctorSpecialization(rs.getString("specialization"));
        apt.setDoctorRoom(rs.getString("room_number"));
        apt.setConsultationFee(rs.getBigDecimal("consultation_fee"));

        apt.setPatientName(rs.getString("patient_name"));
        apt.setPatientPhone(rs.getString("patient_phone"));
        apt.setPatientEmail(rs.getString("patient_email"));
        try {
            apt.setPatientGender(rs.getString("patient_gender"));
            apt.setPatientDob(rs.getDate("patient_dob"));
        } catch (SQLException ignored) {}

        return apt;
    }
}
