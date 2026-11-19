package com.casestudy.dao;

import com.casestudy.util.DBUtil;
import java.sql.*;
import java.util.*;

public class EventDAO {

    public boolean registerParticipant(String id, String name, String email, String phone, String inst, String pass) throws SQLException {
        String sql = "INSERT INTO participants (participant_id, participant_name, email, phone, institution, password) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, inst);
            ps.setString(6, pass);
            return ps.executeUpdate() > 0;
        }
    }

    public Map<String, String> loginParticipant(String idOrEmail, String pass) throws SQLException {
        String sql = "SELECT * FROM participants WHERE (participant_id = ? OR email = ?) AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, idOrEmail);
            ps.setString(2, idOrEmail);
            ps.setString(3, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("participantId", rs.getString("participant_id"));
                    map.put("participantName", rs.getString("participant_name"));
                    return map;
                }
            }
        }
        return null;
    }

    public boolean loginOrganizer(String user, String pass) throws SQLException {
        String sql = "SELECT * FROM organizers WHERE username = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Map<String, Object>> getUpcomingEvents(String category, String date) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE 1=1 ";
        if (category != null && !category.trim().isEmpty()) sql += " AND category = ? ";
        if (date != null && !date.trim().isEmpty()) sql += " AND event_date = ? ";
        sql += " ORDER BY event_date ASC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int idx = 1;
            if (category != null && !category.trim().isEmpty()) ps.setString(idx++, category.trim());
            if (date != null && !date.trim().isEmpty()) ps.setDate(idx++, Date.valueOf(date.trim()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("eventId", rs.getInt("event_id"));
                    map.put("title", rs.getString("title"));
                    map.put("category", rs.getString("category"));
                    map.put("venue", rs.getString("venue"));
                    map.put("eventDate", rs.getDate("event_date"));
                    map.put("deadline", rs.getDate("deadline"));
                    map.put("capacity", rs.getInt("capacity"));
                    map.put("registeredCount", rs.getInt("registered_count"));
                    map.put("availableSeats", Math.max(0, rs.getInt("capacity") - rs.getInt("registered_count")));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public boolean registerForEvent(String partId, int eventId) throws SQLException {
        String checkSql = "SELECT capacity, registered_count, deadline FROM events WHERE event_id = ? FOR UPDATE";
        String insertSql = "INSERT INTO event_registrations (event_id, participant_id, attendance_status) VALUES (?, ?, 'Pending')";
        String updateCountSql = "UPDATE events SET registered_count = registered_count + 1 WHERE event_id = ?";

        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement check = con.prepareStatement(checkSql)) {
                check.setInt(1, eventId);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        int cap = rs.getInt("capacity");
                        int count = rs.getInt("registered_count");
                        Date deadline = rs.getDate("deadline");
                        long now = System.currentTimeMillis();
                        if (count >= cap || deadline.before(new Date(now))) {
                            con.rollback();
                            return false; // Full or deadline passed!
                        }
                    }
                }
                try (PreparedStatement insert = con.prepareStatement(insertSql);
                     PreparedStatement update = con.prepareStatement(updateCountSql)) {
                    insert.setInt(1, eventId);
                    insert.setString(2, partId);
                    insert.executeUpdate();

                    update.setInt(1, eventId);
                    update.executeUpdate();
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

    public List<Map<String, Object>> getParticipantRegistrations(String partId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.*, e.title, e.category, e.venue, e.event_date FROM event_registrations r " +
                     "JOIN events e ON r.event_id = e.event_id WHERE r.participant_id = ? ORDER BY e.event_date ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, partId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("regId", rs.getInt("reg_id"));
                    map.put("title", rs.getString("title"));
                    map.put("category", rs.getString("category"));
                    map.put("venue", rs.getString("venue"));
                    map.put("eventDate", rs.getDate("event_date"));
                    map.put("attendance", rs.getString("attendance_status"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public List<Map<String, Object>> getEventAttendees(int eventId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.*, p.participant_name, p.email, p.phone, p.institution FROM event_registrations r " +
                     "JOIN participants p ON r.participant_id = p.participant_id WHERE r.event_id = ? ORDER BY p.participant_name ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("regId", rs.getInt("reg_id"));
                    map.put("name", rs.getString("participant_name"));
                    map.put("email", rs.getString("email"));
                    map.put("phone", rs.getString("phone"));
                    map.put("institution", rs.getString("institution"));
                    map.put("attendance", rs.getString("attendance_status"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public Map<String, Integer> getAttendanceStats(int eventId) throws SQLException {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT attendance_status, COUNT(*) AS cnt FROM event_registrations WHERE event_id = ? GROUP BY attendance_status";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                int total = 0, present = 0, absent = 0;
                while (rs.next()) {
                    String st = rs.getString("attendance_status");
                    int c = rs.getInt("cnt");
                    total += c;
                    if ("Present".equalsIgnoreCase(st)) present += c;
                    if ("Absent".equalsIgnoreCase(st)) absent += c;
                }
                map.put("registered", total);
                map.put("present", present);
                map.put("absent", absent);
            }
        }
        return map;
    }

    public boolean updateAttendance(int regId, String status) throws SQLException {
        String sql = "UPDATE event_registrations SET attendance_status = ? WHERE reg_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, regId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean addEvent(String title, String category, String venue, String date, String deadline, int cap) throws SQLException {
        String sql = "INSERT INTO events (title, category, venue, event_date, deadline, capacity) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, category);
            ps.setString(3, venue);
            ps.setDate(4, Date.valueOf(date));
            ps.setDate(5, Date.valueOf(deadline));
            ps.setInt(6, cap);
            return ps.executeUpdate() > 0;
        }
    }
}
