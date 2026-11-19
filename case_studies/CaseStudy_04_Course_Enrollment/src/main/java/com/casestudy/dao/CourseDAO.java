package com.casestudy.dao;

import com.casestudy.model.Course;
import com.casestudy.util.DBUtil;
import java.sql.*;
import java.util.*;

public class CourseDAO {

    public boolean registerLearner(String id, String name, String email, String phone, String qual, String pass) throws SQLException {
        String sql = "INSERT INTO learners (learner_id, learner_name, email, phone, qualification, password) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, qual);
            ps.setString(6, pass);
            return ps.executeUpdate() > 0;
        }
    }

    public Map<String, String> loginLearner(String idOrEmail, String pass) throws SQLException {
        String sql = "SELECT * FROM learners WHERE (learner_id = ? OR email = ?) AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, idOrEmail);
            ps.setString(2, idOrEmail);
            ps.setString(3, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("learnerId", rs.getString("learner_id"));
                    map.put("learnerName", rs.getString("learner_name"));
                    map.put("email", rs.getString("email"));
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

    public List<Course> searchCourses(String query) throws SQLException {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses";
        if (query != null && !query.trim().isEmpty()) {
            sql += " WHERE title LIKE ? OR duration LIKE ?";
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
                    list.add(new Course(rs.getInt("course_id"), rs.getString("title"),
                            rs.getString("duration"), rs.getDouble("fee"),
                            rs.getInt("total_seats"), rs.getInt("available_seats")));
                }
            }
        }
        return list;
    }

    public boolean enrollCourse(String learnerId, int courseId) throws SQLException {
        String checkSeatSql = "SELECT available_seats FROM courses WHERE course_id = ? FOR UPDATE";
        String insertEnrollSql = "INSERT INTO enrollments (learner_id, course_id, status) VALUES (?, ?, 'CONFIRMED')";
        String updateSeatSql = "UPDATE courses SET available_seats = available_seats - 1 WHERE course_id = ?";

        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement check = con.prepareStatement(checkSeatSql)) {
                check.setInt(1, courseId);
                try (ResultSet rs = check.executeQuery()) {
                    if (!rs.next() || rs.getInt("available_seats") <= 0) {
                        con.rollback();
                        return false; // No seats available!
                    }
                }
                try (PreparedStatement insert = con.prepareStatement(insertEnrollSql);
                     PreparedStatement update = con.prepareStatement(updateSeatSql)) {
                    insert.setString(1, learnerId);
                    insert.setInt(2, courseId);
                    insert.executeUpdate();

                    update.setInt(1, courseId);
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

    public List<Map<String, Object>> getLearnerEnrollments(String learnerId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT e.*, c.title, c.duration, c.fee FROM enrollments e " +
                     "JOIN courses c ON e.course_id = c.course_id WHERE e.learner_id = ? ORDER BY e.enrolled_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, learnerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("enrollmentId", rs.getInt("enrollment_id"));
                    map.put("title", rs.getString("title"));
                    map.put("duration", rs.getString("duration"));
                    map.put("fee", rs.getDouble("fee"));
                    map.put("enrolledAt", rs.getTimestamp("enrolled_at"));
                    map.put("status", rs.getString("status"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public List<Map<String, Object>> getAllEnrollments() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT e.*, c.title, l.learner_name, l.email FROM enrollments e " +
                     "JOIN courses c ON e.course_id = c.course_id " +
                     "JOIN learners l ON e.learner_id = l.learner_id ORDER BY e.enrolled_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("enrollmentId", rs.getInt("enrollment_id"));
                map.put("title", rs.getString("title"));
                map.put("learnerName", rs.getString("learner_name"));
                map.put("email", rs.getString("email"));
                map.put("enrolledAt", rs.getTimestamp("enrolled_at"));
                map.put("status", rs.getString("status"));
                list.add(map);
            }
        }
        return list;
    }

    public boolean addCourse(String title, String duration, double fee, int seats) throws SQLException {
        String sql = "INSERT INTO courses (title, duration, fee, total_seats, available_seats) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, duration);
            ps.setDouble(3, fee);
            ps.setInt(4, seats);
            ps.setInt(5, seats);
            return ps.executeUpdate() > 0;
        }
    }
}
