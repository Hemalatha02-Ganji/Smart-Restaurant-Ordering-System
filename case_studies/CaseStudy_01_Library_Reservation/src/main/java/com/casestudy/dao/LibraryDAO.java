package com.casestudy.dao;

import com.casestudy.model.*;
import com.casestudy.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LibraryDAO {

    public boolean registerMember(Member m) throws SQLException {
        String sql = "INSERT INTO members (member_id, full_name, email, phone, department, password) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, m.getMemberId());
            ps.setString(2, m.getFullName());
            ps.setString(3, m.getEmail());
            ps.setString(4, m.getPhone());
            ps.setString(5, m.getDepartment());
            ps.setString(6, m.getPassword());
            return ps.executeUpdate() > 0;
        }
    }

    public Member loginMember(String memberId, String password) throws SQLException {
        String sql = "SELECT * FROM members WHERE member_id = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, memberId);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Member(rs.getString("member_id"), rs.getString("full_name"), rs.getString("email"),
                            rs.getString("phone"), rs.getString("department"), rs.getString("password"));
                }
            }
        }
        return null;
    }

    public boolean loginLibrarian(String username, String password) throws SQLException {
        String sql = "SELECT * FROM librarians WHERE username = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Resource> searchResources(String keyword) throws SQLException {
        List<Resource> list = new ArrayList<>();
        String sql = "SELECT * FROM resources";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " WHERE title LIKE ? OR author LIKE ? OR category LIKE ?";
        }
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                String k = "%" + keyword.trim() + "%";
                ps.setString(1, k);
                ps.setString(2, k);
                ps.setString(3, k);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Resource(rs.getInt("resource_id"), rs.getString("title"),
                            rs.getString("author"), rs.getString("category"), rs.getString("status")));
                }
            }
        }
        return list;
    }

    public boolean requestReservation(String memberId, int resourceId) throws SQLException {
        String checkSql = "SELECT status FROM resources WHERE resource_id = ?";
        String insertSql = "INSERT INTO reservations (member_id, resource_id, status) VALUES (?, ?, 'PENDING')";
        try (Connection con = DBUtil.getConnection()) {
            try (PreparedStatement check = con.prepareStatement(checkSql)) {
                check.setInt(1, resourceId);
                try (ResultSet rs = check.executeQuery()) {
                    if (!rs.next() || !"AVAILABLE".equalsIgnoreCase(rs.getString("status"))) {
                        return false;
                    }
                }
            }
            try (PreparedStatement insert = con.prepareStatement(insertSql)) {
                insert.setString(1, memberId);
                insert.setInt(2, resourceId);
                return insert.executeUpdate() > 0;
            }
        }
    }

    public List<Reservation> getMemberReservations(String memberId) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, res.title FROM reservations r JOIN resources res ON r.resource_id = res.resource_id WHERE r.member_id = ? ORDER BY r.request_date DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, memberId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation res = new Reservation();
                    res.setReservationId(rs.getInt("reservation_id"));
                    res.setMemberId(rs.getString("member_id"));
                    res.setResourceId(rs.getInt("resource_id"));
                    res.setResourceTitle(rs.getString("title"));
                    res.setRequestDate(rs.getTimestamp("request_date"));
                    res.setStatus(rs.getString("status"));
                    list.add(res);
                }
            }
        }
        return list;
    }

    public List<Reservation> getAllReservations() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, res.title, m.full_name FROM reservations r " +
                     "JOIN resources res ON r.resource_id = res.resource_id " +
                     "JOIN members m ON r.member_id = m.member_id ORDER BY r.request_date DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Reservation res = new Reservation();
                res.setReservationId(rs.getInt("reservation_id"));
                res.setMemberId(rs.getString("member_id"));
                res.setMemberName(rs.getString("full_name"));
                res.setResourceId(rs.getInt("resource_id"));
                res.setResourceTitle(rs.getString("title"));
                res.setRequestDate(rs.getTimestamp("request_date"));
                res.setStatus(rs.getString("status"));
                list.add(res);
            }
        }
        return list;
    }

    public boolean updateReservationStatus(int reservationId, String status) throws SQLException {
        String updateRes = "UPDATE reservations SET status = ? WHERE reservation_id = ?";
        String updateBook = "UPDATE resources r JOIN reservations res ON r.resource_id = res.resource_id SET r.status = ? WHERE res.reservation_id = ?";
        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps1 = con.prepareStatement(updateRes);
                 PreparedStatement ps2 = con.prepareStatement(updateBook)) {
                ps1.setString(1, status);
                ps1.setInt(2, reservationId);
                ps1.executeUpdate();

                if ("APPROVED".equalsIgnoreCase(status)) {
                    ps2.setString(1, "RESERVED");
                } else {
                    ps2.setString(1, "AVAILABLE");
                }
                ps2.setInt(2, reservationId);
                ps2.executeUpdate();

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
}
