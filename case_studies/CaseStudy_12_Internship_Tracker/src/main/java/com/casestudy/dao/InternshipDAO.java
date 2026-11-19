package com.casestudy.dao;

import com.casestudy.util.DBUtil;
import java.sql.*;
import java.util.*;

public class InternshipDAO {

    public boolean registerStudent(String roll, String name, String branch, String sem, String email, String phone, String pass) throws SQLException {
        String sql = "INSERT INTO students (roll_number, student_name, branch, semester, email, phone, password) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, roll);
            ps.setString(2, name);
            ps.setString(3, branch);
            ps.setString(4, sem);
            ps.setString(5, email);
            ps.setString(6, phone);
            ps.setString(7, pass);
            return ps.executeUpdate() > 0;
        }
    }

    public Map<String, String> loginStudent(String rollOrEmail, String pass) throws SQLException {
        String sql = "SELECT * FROM students WHERE (roll_number = ? OR email = ?) AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, rollOrEmail);
            ps.setString(2, rollOrEmail);
            ps.setString(3, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("rollNumber", rs.getString("roll_number"));
                    map.put("studentName", rs.getString("student_name"));
                    return map;
                }
            }
        }
        return null;
    }

    public boolean loginCoordinator(String user, String pass) throws SQLException {
        String sql = "SELECT * FROM coordinators WHERE username = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Map<String, Object>> searchInternships(String org, String role, String loc) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM internships WHERE 1=1 ";
        if (org != null && !org.trim().isEmpty()) sql += " AND organisation LIKE ? ";
        if (role != null && !role.trim().isEmpty()) sql += " AND role LIKE ? ";
        if (loc != null && !loc.trim().isEmpty()) sql += " AND location LIKE ? ";
        sql += " ORDER BY last_date ASC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int idx = 1;
            if (org != null && !org.trim().isEmpty()) ps.setString(idx++, "%" + org.trim() + "%");
            if (role != null && !role.trim().isEmpty()) ps.setString(idx++, "%" + role.trim() + "%");
            if (loc != null && !loc.trim().isEmpty()) ps.setString(idx++, "%" + loc.trim() + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("internshipId", rs.getInt("internship_id"));
                    map.put("organisation", rs.getString("organisation"));
                    map.put("role", rs.getString("role"));
                    map.put("eligibility", rs.getString("eligibility"));
                    map.put("location", rs.getString("location"));
                    map.put("stipend", rs.getString("stipend"));
                    map.put("lastDate", rs.getDate("last_date"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public boolean applyForInternship(int internId, String roll) throws SQLException {
        String checkSql = "SELECT last_date FROM internships WHERE internship_id = ?";
        String insertSql = "INSERT INTO applications (internship_id, roll_number, status) VALUES (?, ?, 'Applied')";

        try (Connection con = DBUtil.getConnection()) {
            try (PreparedStatement check = con.prepareStatement(checkSql)) {
                check.setInt(1, internId);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        Date lastDate = rs.getDate("last_date");
                        if (lastDate.before(new java.util.Date())) {
                            return false; // Deadline passed!
                        }
                    }
                }
            }
            try (PreparedStatement insert = con.prepareStatement(insertSql)) {
                insert.setInt(1, internId);
                insert.setString(2, roll);
                return insert.executeUpdate() > 0;
            }
        }
    }

    public List<Map<String, Object>> getStudentApplications(String roll) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT a.*, i.organisation, i.role, i.location FROM applications a " +
                     "JOIN internships i ON a.internship_id = i.internship_id WHERE a.roll_number = ? ORDER BY a.applied_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, roll);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("appId", rs.getInt("app_id"));
                    map.put("organisation", rs.getString("organisation"));
                    map.put("role", rs.getString("role"));
                    map.put("location", rs.getString("location"));
                    map.put("appliedAt", rs.getTimestamp("applied_at"));
                    map.put("status", rs.getString("status"));
                    map.put("remarks", rs.getString("coordinator_remarks"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public List<Map<String, Object>> getAllApplicants() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT a.*, i.organisation, i.role, s.student_name, s.branch, s.email, s.phone FROM applications a " +
                     "JOIN internships i ON a.internship_id = i.internship_id " +
                     "JOIN students s ON a.roll_number = s.roll_number ORDER BY a.applied_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("appId", rs.getInt("app_id"));
                map.put("roll", rs.getString("roll_number"));
                map.put("student", rs.getString("student_name") + " (" + rs.getString("branch") + ")");
                map.put("email", rs.getString("email"));
                map.put("phone", rs.getString("phone"));
                map.put("opportunity", rs.getString("organisation") + " - " + rs.getString("role"));
                map.put("status", rs.getString("status"));
                map.put("remarks", rs.getString("coordinator_remarks"));
                list.add(map);
            }
        }
        return list;
    }

    public boolean updateStatusAndRemarks(int appId, String status, String remarks) throws SQLException {
        String sql = "UPDATE applications SET status = ?, coordinator_remarks = ? WHERE app_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, remarks);
            ps.setInt(3, appId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean publishInternship(String org, String role, String elig, String loc, String stip, String date) throws SQLException {
        String sql = "INSERT INTO internships (organisation, role, eligibility, location, stipend, last_date) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, org);
            ps.setString(2, role);
            ps.setString(3, elig);
            ps.setString(4, loc);
            ps.setString(5, stip);
            ps.setDate(6, Date.valueOf(date));
            return ps.executeUpdate() > 0;
        }
    }
}
