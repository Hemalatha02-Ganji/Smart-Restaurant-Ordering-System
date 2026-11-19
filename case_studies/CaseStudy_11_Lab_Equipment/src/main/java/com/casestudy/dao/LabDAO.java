package com.casestudy.dao;

import com.casestudy.util.DBUtil;
import java.sql.*;
import java.util.*;

public class LabDAO {

    public Map<String, String> loginStaff(String id, String pass) throws SQLException {
        String sql = "SELECT * FROM staff WHERE staff_id = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("staffId", rs.getString("staff_id"));
                    map.put("fullName", rs.getString("full_name"));
                    map.put("role", rs.getString("role"));
                    return map;
                }
            }
        }
        return null;
    }

    public List<Map<String, Object>> searchEquipment(String query) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM equipment";
        if (query != null && !query.trim().isEmpty()) {
            sql += " WHERE name LIKE ? OR category LIKE ?";
        }
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (query != null && !query.trim().isEmpty()) {
                String q = "%" + query.trim() + "%";
                ps.setString(1, q);
                ps.setString(2, q);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("equipmentId", rs.getInt("equipment_id"));
                    map.put("name", rs.getString("name"));
                    map.put("category", rs.getString("category"));
                    map.put("totalQty", rs.getInt("total_qty"));
                    map.put("availableQty", rs.getInt("available_qty"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public boolean issueEquipment(String roll, String name, int equipId, String issueDate, String dueDate) throws SQLException {
        String checkSql = "SELECT available_qty FROM equipment WHERE equipment_id = ? FOR UPDATE";
        String insertSql = "INSERT INTO issues (student_roll, student_name, equipment_id, issue_date, due_date, status) VALUES (?, ?, ?, ?, ?, 'Issued')";
        String updateQtySql = "UPDATE equipment SET available_qty = available_qty - 1 WHERE equipment_id = ?";

        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);
            try {
                try (PreparedStatement check = con.prepareStatement(checkSql)) {
                    check.setInt(1, equipId);
                    try (ResultSet rs = check.executeQuery()) {
                        if (!rs.next() || rs.getInt("available_qty") <= 0) {
                            con.rollback();
                            return false; // Out of stock!
                        }
                    }
                }
                try (PreparedStatement insert = con.prepareStatement(insertSql);
                     PreparedStatement update = con.prepareStatement(updateQtySql)) {
                    insert.setString(1, roll);
                    insert.setString(2, name);
                    insert.setInt(3, equipId);
                    insert.setDate(4, Date.valueOf(issueDate));
                    insert.setDate(5, Date.valueOf(dueDate));
                    insert.executeUpdate();

                    update.setInt(1, equipId);
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

    public boolean recordReturn(int issueId, String returnDate, String condition) throws SQLException {
        String getSql = "SELECT equipment_id FROM issues WHERE issue_id = ?";
        String updateIssueSql = "UPDATE issues SET return_date = ?, condition_on_return = ?, status = 'Returned' WHERE issue_id = ?";
        String updateQtySql = "UPDATE equipment SET available_qty = available_qty + 1 WHERE equipment_id = ?";

        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);
            try {
                int equipId = 0;
                try (PreparedStatement ps = con.prepareStatement(getSql)) {
                    ps.setInt(1, issueId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) equipId = rs.getInt("equipment_id");
                    }
                }

                try (PreparedStatement ps = con.prepareStatement(updateIssueSql)) {
                    ps.setDate(1, Date.valueOf(returnDate));
                    ps.setString(2, condition);
                    ps.setInt(3, issueId);
                    ps.executeUpdate();
                }

                // If returned in good condition, replenish available inventory
                if ("Good".equalsIgnoreCase(condition)) {
                    try (PreparedStatement ps = con.prepareStatement(updateQtySql)) {
                        ps.setInt(1, equipId);
                        ps.executeUpdate();
                    }
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

    public List<Map<String, Object>> getActiveIssues() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT i.*, e.name AS equipment_name FROM issues i " +
                     "JOIN equipment e ON i.equipment_id = e.equipment_id WHERE i.status = 'Issued' ORDER BY i.due_date ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("issueId", rs.getInt("issue_id"));
                map.put("roll", rs.getString("student_roll"));
                map.put("student", rs.getString("student_name"));
                map.put("equipment", rs.getString("equipment_name"));
                map.put("issueDate", rs.getDate("issue_date"));
                map.put("dueDate", rs.getDate("due_date"));
                map.put("status", rs.getString("status"));
                list.add(map);
            }
        }
        return list;
    }

    public List<Map<String, Object>> getReports(String reportType) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT i.*, e.name AS equipment_name FROM issues i " +
                     "JOIN equipment e ON i.equipment_id = e.equipment_id WHERE 1=1 ";
        if ("overdue".equalsIgnoreCase(reportType)) {
            sql += " AND i.status = 'Issued' AND i.due_date < CURRENT_DATE() ";
        } else if ("damaged".equalsIgnoreCase(reportType)) {
            sql += " AND i.condition_on_return = 'Damaged' ";
        }
        sql += " ORDER BY i.issue_id DESC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("issueId", rs.getInt("issue_id"));
                map.put("roll", rs.getString("student_roll"));
                map.put("student", rs.getString("student_name"));
                map.put("equipment", rs.getString("equipment_name"));
                map.put("issueDate", rs.getDate("issue_date"));
                map.put("dueDate", rs.getDate("due_date"));
                map.put("returnDate", rs.getDate("return_date"));
                map.put("condition", rs.getString("condition_on_return"));
                map.put("status", rs.getString("status"));
                list.add(map);
            }
        }
        return list;
    }
}
