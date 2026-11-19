package com.casestudy.dao;

import com.casestudy.util.DBUtil;
import java.sql.*;
import java.util.*;

public class ExamDAO {

    public boolean registerCandidate(String id, String name, String roll, String prog, String sem, String email, String pass) throws SQLException {
        String sql = "INSERT INTO candidates (candidate_id, candidate_name, roll_number, programme, semester, email, password) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, roll);
            ps.setString(4, prog);
            ps.setString(5, sem);
            ps.setString(6, email);
            ps.setString(7, pass);
            return ps.executeUpdate() > 0;
        }
    }

    public Map<String, String> loginCandidate(String idOrRoll, String pass) throws SQLException {
        String sql = "SELECT * FROM candidates WHERE (candidate_id = ? OR roll_number = ?) AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, idOrRoll);
            ps.setString(2, idOrRoll);
            ps.setString(3, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("candidateId", rs.getString("candidate_id"));
                    map.put("candidateName", rs.getString("candidate_name"));
                    map.put("rollNumber", rs.getString("roll_number"));
                    return map;
                }
            }
        }
        return null;
    }

    public boolean loginOfficer(String user, String pass) throws SQLException {
        String sql = "SELECT * FROM exam_officers WHERE username = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Map<String, Object>> getAvailableExams() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM examinations ORDER BY exam_date ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("examId", rs.getInt("exam_id"));
                map.put("subjectCode", rs.getString("subject_code"));
                map.put("subjectName", rs.getString("subject_name"));
                map.put("examDate", rs.getDate("exam_date"));
                map.put("session", rs.getString("session"));
                map.put("deadline", rs.getDate("registration_deadline"));
                map.put("isClosed", rs.getBoolean("is_closed"));
                list.add(map);
            }
        }
        return list;
    }

    public boolean registerForExam(String candId, int examId) throws SQLException {
        String checkSql = "SELECT registration_deadline, is_closed FROM examinations WHERE exam_id = ?";
        String insertSql = "INSERT INTO exam_registrations (candidate_id, exam_id, status) VALUES (?, ?, 'Registered')";

        try (Connection con = DBUtil.getConnection()) {
            try (PreparedStatement check = con.prepareStatement(checkSql)) {
                check.setInt(1, examId);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        Date deadline = rs.getDate("registration_deadline");
                        boolean closed = rs.getBoolean("is_closed");
                        if (closed || deadline.before(new java.util.Date())) {
                            return false; // Registration closed or deadline passed!
                        }
                    }
                }
            }
            try (PreparedStatement insert = con.prepareStatement(insertSql)) {
                insert.setString(1, candId);
                insert.setInt(2, examId);
                return insert.executeUpdate() > 0;
            }
        }
    }

    public List<Map<String, Object>> getCandidateSchedule(String candId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.*, e.subject_code, e.subject_name, e.exam_date, e.session FROM exam_registrations r " +
                     "JOIN examinations e ON r.exam_id = e.exam_id WHERE r.candidate_id = ? ORDER BY e.exam_date ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, candId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("regId", rs.getInt("reg_id"));
                    map.put("subjectCode", rs.getString("subject_code"));
                    map.put("subjectName", rs.getString("subject_name"));
                    map.put("examDate", rs.getDate("exam_date"));
                    map.put("session", rs.getString("session"));
                    map.put("status", rs.getString("status"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public List<Map<String, Object>> getCandidateListBySubject(int examId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.*, c.candidate_name, c.roll_number, c.programme, c.semester FROM exam_registrations r " +
                     "JOIN candidates c ON r.candidate_id = c.candidate_id WHERE r.exam_id = ? ORDER BY c.roll_number ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, examId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("regId", rs.getInt("reg_id"));
                    map.put("name", rs.getString("candidate_name"));
                    map.put("roll", rs.getString("roll_number"));
                    map.put("programme", rs.getString("programme"));
                    map.put("semester", rs.getString("semester"));
                    map.put("status", rs.getString("status"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public boolean addExam(String code, String name, String date, String session, String deadline) throws SQLException {
        String sql = "INSERT INTO examinations (subject_code, subject_name, exam_date, session, registration_deadline, is_closed) VALUES (?, ?, ?, ?, ?, FALSE)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setString(2, name);
            ps.setDate(3, Date.valueOf(date));
            ps.setString(4, session);
            ps.setDate(5, Date.valueOf(deadline));
            return ps.executeUpdate() > 0;
        }
    }

    public boolean closeRegistration(int examId) throws SQLException {
        String sql = "UPDATE examinations SET is_closed = TRUE WHERE exam_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, examId);
            return ps.executeUpdate() > 0;
        }
    }
}
