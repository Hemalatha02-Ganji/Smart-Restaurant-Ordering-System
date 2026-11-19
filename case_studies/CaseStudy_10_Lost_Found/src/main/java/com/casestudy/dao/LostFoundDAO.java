package com.casestudy.dao;

import com.casestudy.util.DBUtil;
import java.sql.*;
import java.util.*;

public class LostFoundDAO {

    public boolean registerStudent(String id, String name, String email, String phone, String pass) throws SQLException {
        String sql = "INSERT INTO students (student_id, student_name, email, phone, password) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, pass);
            return ps.executeUpdate() > 0;
        }
    }

    public Map<String, String> loginStudent(String idOrEmail, String pass) throws SQLException {
        String sql = "SELECT * FROM students WHERE (student_id = ? OR email = ?) AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, idOrEmail);
            ps.setString(2, idOrEmail);
            ps.setString(3, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("studentId", rs.getString("student_id"));
                    map.put("studentName", rs.getString("student_name"));
                    return map;
                }
            }
        }
        return null;
    }

    public boolean loginModerator(String user, String pass) throws SQLException {
        String sql = "SELECT * FROM moderators WHERE username = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean reportItem(String studId, String name, String desc, String cat, String loc, String date, String type) throws SQLException {
        String sql = "INSERT INTO item_reports (student_id, item_name, description, category, location, item_date, report_type, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, 'Open')";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, studId);
            ps.setString(2, name);
            ps.setString(3, desc);
            ps.setString(4, cat);
            ps.setString(5, loc);
            ps.setDate(6, Date.valueOf(date));
            ps.setString(7, type);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Map<String, Object>> searchOpenReports(String query, String cat, String loc, String type) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.*, s.student_name, s.phone FROM item_reports r " +
                     "JOIN students s ON r.student_id = s.student_id WHERE r.status = 'Open' ";
        if (query != null && !query.trim().isEmpty()) sql += " AND (r.item_name LIKE ? OR r.description LIKE ?) ";
        if (cat != null && !cat.trim().isEmpty()) sql += " AND r.category = ? ";
        if (loc != null && !loc.trim().isEmpty()) sql += " AND r.location LIKE ? ";
        if (type != null && !type.trim().isEmpty()) sql += " AND r.report_type = ? ";
        sql += " ORDER BY r.created_at DESC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int idx = 1;
            if (query != null && !query.trim().isEmpty()) {
                String q = "%" + query.trim() + "%";
                ps.setString(idx++, q);
                ps.setString(idx++, q);
            }
            if (cat != null && !cat.trim().isEmpty()) ps.setString(idx++, cat.trim());
            if (loc != null && !loc.trim().isEmpty()) ps.setString(idx++, "%" + loc.trim() + "%");
            if (type != null && !type.trim().isEmpty()) ps.setString(idx++, type.trim());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("reportId", rs.getInt("report_id"));
                    map.put("name", rs.getString("item_name"));
                    map.put("description", rs.getString("description"));
                    map.put("category", rs.getString("category"));
                    map.put("location", rs.getString("location"));
                    map.put("date", rs.getDate("item_date"));
                    map.put("type", rs.getString("report_type"));
                    map.put("reporter", rs.getString("student_name") + " (" + rs.getString("phone") + ")");
                    list.add(map);
                }
            }
        }
        return list;
    }

    public List<Map<String, Object>> getStudentReports(String studId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM item_reports WHERE student_id = ? ORDER BY created_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, studId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("reportId", rs.getInt("report_id"));
                    map.put("name", rs.getString("item_name"));
                    map.put("description", rs.getString("description"));
                    map.put("category", rs.getString("category"));
                    map.put("location", rs.getString("location"));
                    map.put("date", rs.getDate("item_date"));
                    map.put("type", rs.getString("report_type"));
                    map.put("status", rs.getString("status"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public boolean markResolved(int reportId, String studId) throws SQLException {
        String sql = "UPDATE item_reports SET status = 'Resolved' WHERE report_id = ? AND student_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            ps.setString(2, studId);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Map<String, Object>> getAllReportsForModerator() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.*, s.student_name, s.email, s.phone FROM item_reports r " +
                     "JOIN students s ON r.student_id = s.student_id ORDER BY r.created_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("reportId", rs.getInt("report_id"));
                map.put("name", rs.getString("item_name"));
                map.put("description", rs.getString("description"));
                map.put("category", rs.getString("category"));
                map.put("location", rs.getString("location"));
                map.put("date", rs.getDate("item_date"));
                map.put("type", rs.getString("report_type"));
                map.put("status", rs.getString("status"));
                map.put("reporter", rs.getString("student_name") + " (" + rs.getString("student_id") + ")");
                list.add(map);
            }
        }
        return list;
    }

    public boolean hideReport(int reportId) throws SQLException {
        String sql = "UPDATE item_reports SET status = 'Hidden' WHERE report_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            return ps.executeUpdate() > 0;
        }
    }
}
