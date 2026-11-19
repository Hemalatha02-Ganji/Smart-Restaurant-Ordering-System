package com.casestudy.dao;

import com.casestudy.model.*;
import com.casestudy.util.DBUtil;
import java.sql.*;
import java.util.*;

public class HostelDAO {

    public boolean registerApplicant(Applicant a) throws SQLException {
        String sql = "INSERT INTO applicants (roll_number, application_number, student_name, year, branch, phone, preferred_hostel, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, a.getRollNumber());
            ps.setString(2, a.getApplicationNumber());
            ps.setString(3, a.getStudentName());
            ps.setString(4, a.getYear());
            ps.setString(5, a.getBranch());
            ps.setString(6, a.getPhone());
            ps.setString(7, a.getPreferredHostel());
            ps.setString(8, a.getPassword());
            return ps.executeUpdate() > 0;
        }
    }

    public Applicant loginApplicant(String rollNumber, String password) throws SQLException {
        String sql = "SELECT * FROM applicants WHERE roll_number = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, rollNumber);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Applicant(rs.getString("roll_number"), rs.getString("application_number"),
                            rs.getString("student_name"), rs.getString("year"), rs.getString("branch"),
                            rs.getString("phone"), rs.getString("preferred_hostel"), rs.getString("password"));
                }
            }
        }
        return null;
    }

    public boolean loginWarden(String username, String password) throws SQLException {
        String sql = "SELECT * FROM wardens WHERE username = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean submitApplication(String rollNumber, String academicYear) throws SQLException {
        String sql = "INSERT INTO applications (roll_number, academic_year, status) VALUES (?, ?, 'PENDING')";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, rollNumber);
            ps.setString(2, academicYear);
            return ps.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            return false; // Duplicate application for same academic year
        }
    }

    public Map<String, Object> getApplicantApplication(String rollNumber) throws SQLException {
        String sql = "SELECT app.*, r.hostel_block, r.room_number FROM applications app " +
                     "LEFT JOIN rooms r ON app.allocated_room_id = r.room_id WHERE app.roll_number = ? ORDER BY app.created_at DESC LIMIT 1";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, rollNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("applicationId", rs.getInt("application_id"));
                    map.put("academicYear", rs.getString("academic_year"));
                    map.put("status", rs.getString("status"));
                    map.put("hostelBlock", rs.getString("hostel_block"));
                    map.put("roomNumber", rs.getString("room_number"));
                    return map;
                }
            }
        }
        return null;
    }

    public List<Map<String, Object>> getAllApplications() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT app.*, a.student_name, a.branch, a.preferred_hostel, r.hostel_block, r.room_number FROM applications app " +
                     "JOIN applicants a ON app.roll_number = a.roll_number " +
                     "LEFT JOIN rooms r ON app.allocated_room_id = r.room_id ORDER BY app.created_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("applicationId", rs.getInt("application_id"));
                map.put("rollNumber", rs.getString("roll_number"));
                map.put("studentName", rs.getString("student_name"));
                map.put("branch", rs.getString("branch"));
                map.put("preferredHostel", rs.getString("preferred_hostel"));
                map.put("academicYear", rs.getString("academic_year"));
                map.put("status", rs.getString("status"));
                map.put("hostelBlock", rs.getString("hostel_block"));
                map.put("roomNumber", rs.getString("room_number"));
                list.add(map);
            }
        }
        return list;
    }

    public List<Map<String, Object>> getAvailableRooms() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE current_occupancy < capacity";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("roomId", rs.getInt("room_id"));
                map.put("hostelBlock", rs.getString("hostel_block"));
                map.put("roomNumber", rs.getString("room_number"));
                map.put("capacity", rs.getInt("capacity"));
                map.put("currentOccupancy", rs.getInt("current_occupancy"));
                list.add(map);
            }
        }
        return list;
    }

    public boolean allocateRoom(int applicationId, int roomId) throws SQLException {
        String roomCheckSql = "SELECT capacity, current_occupancy FROM rooms WHERE room_id = ? FOR UPDATE";
        String updateAppSql = "UPDATE applications SET status = 'APPROVED', allocated_room_id = ? WHERE application_id = ?";
        String updateRoomSql = "UPDATE rooms SET current_occupancy = current_occupancy + 1 WHERE room_id = ?";

        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement check = con.prepareStatement(roomCheckSql)) {
                check.setInt(1, roomId);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        int cap = rs.getInt("capacity");
                        int occ = rs.getInt("current_occupancy");
                        if (occ >= cap) {
                            con.rollback();
                            return false; // Room full!
                        }
                    }
                }
                try (PreparedStatement psApp = con.prepareStatement(updateAppSql);
                     PreparedStatement psRoom = con.prepareStatement(updateRoomSql)) {
                    psApp.setInt(1, roomId);
                    psApp.setInt(2, applicationId);
                    psApp.executeUpdate();

                    psRoom.setInt(1, roomId);
                    psRoom.executeUpdate();
                }
                con.commit();
                return true;
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public boolean rejectApplication(int applicationId) throws SQLException {
        String sql = "UPDATE applications SET status = 'REJECTED' WHERE application_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, applicationId);
            return ps.executeUpdate() > 0;
        }
    }
}
