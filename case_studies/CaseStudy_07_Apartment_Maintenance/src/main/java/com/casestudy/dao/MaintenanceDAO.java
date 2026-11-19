package com.casestudy.dao;

import com.casestudy.util.DBUtil;
import java.sql.*;
import java.util.*;

public class MaintenanceDAO {

    public boolean registerResident(String id, String name, String flat, String phone, String email, String pass) throws SQLException {
        String sql = "INSERT INTO residents (resident_id, resident_name, apartment_number, phone, email, password) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, flat);
            ps.setString(4, phone);
            ps.setString(5, email);
            ps.setString(6, pass);
            return ps.executeUpdate() > 0;
        }
    }

    public Map<String, String> loginResident(String idOrEmail, String pass) throws SQLException {
        String sql = "SELECT * FROM residents WHERE (resident_id = ? OR email = ?) AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, idOrEmail);
            ps.setString(2, idOrEmail);
            ps.setString(3, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("residentId", rs.getString("resident_id"));
                    map.put("residentName", rs.getString("resident_name"));
                    map.put("apartmentNumber", rs.getString("apartment_number"));
                    return map;
                }
            }
        }
        return null;
    }

    public boolean loginManager(String user, String pass) throws SQLException {
        String sql = "SELECT * FROM managers WHERE username = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean submitRequest(String resId, String cat, String desc, String priority) throws SQLException {
        String sql = "INSERT INTO maintenance_requests (resident_id, category, description, priority, status) VALUES (?, ?, ?, ?, 'Pending')";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, resId);
            ps.setString(2, cat);
            ps.setString(3, desc);
            ps.setString(4, priority);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Map<String, Object>> getResidentRequests(String resId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM maintenance_requests WHERE resident_id = ? ORDER BY submission_date DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, resId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("requestId", rs.getInt("request_id"));
                    map.put("category", rs.getString("category"));
                    map.put("description", rs.getString("description"));
                    map.put("priority", rs.getString("priority"));
                    map.put("status", rs.getString("status"));
                    map.put("remarks", rs.getString("manager_remarks"));
                    map.put("date", rs.getTimestamp("submission_date"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public List<Map<String, Object>> getAllRequests(String cat, String priority, String status) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT req.*, res.resident_name, res.apartment_number, res.phone FROM maintenance_requests req " +
                     "JOIN residents res ON req.resident_id = res.resident_id WHERE 1=1 ";
        if (cat != null && !cat.trim().isEmpty()) sql += " AND req.category = ? ";
        if (priority != null && !priority.trim().isEmpty()) sql += " AND req.priority = ? ";
        if (status != null && !status.trim().isEmpty()) sql += " AND req.status = ? ";
        sql += " ORDER BY req.submission_date DESC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int idx = 1;
            if (cat != null && !cat.trim().isEmpty()) ps.setString(idx++, cat.trim());
            if (priority != null && !priority.trim().isEmpty()) ps.setString(idx++, priority.trim());
            if (status != null && !status.trim().isEmpty()) ps.setString(idx++, status.trim());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("requestId", rs.getInt("request_id"));
                    map.put("resident", rs.getString("resident_name") + " (" + rs.getString("apartment_number") + ")");
                    map.put("phone", rs.getString("phone"));
                    map.put("category", rs.getString("category"));
                    map.put("description", rs.getString("description"));
                    map.put("priority", rs.getString("priority"));
                    map.put("status", rs.getString("status"));
                    map.put("remarks", rs.getString("manager_remarks"));
                    map.put("date", rs.getTimestamp("submission_date"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public boolean updateStatusAndRemarks(int reqId, String status, String remarks) throws SQLException {
        String sql = "UPDATE maintenance_requests SET status = ?, manager_remarks = ? WHERE request_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, remarks);
            ps.setInt(3, reqId);
            return ps.executeUpdate() > 0;
        }
    }
}
