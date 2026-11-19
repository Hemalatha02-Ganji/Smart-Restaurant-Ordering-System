package com.clinic.dao;

import com.clinic.model.Receptionist;
import com.clinic.util.DBConnectionUtil;
import com.clinic.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Data Access Object for Receptionist Staff.
 */
public class ReceptionistDAO {

    public Receptionist authenticate(String username, String password) {
        String sql = "SELECT * FROM receptionists WHERE username = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    if (PasswordUtil.verifyPassword(password, storedPassword)) {
                        Receptionist r = new Receptionist();
                        r.setUsername(rs.getString("username"));
                        r.setPassword(storedPassword);
                        r.setFullName(rs.getString("full_name"));
                        r.setEmail(rs.getString("email"));
                        r.setPhone(rs.getString("phone"));
                        r.setCreatedAt(rs.getTimestamp("created_at"));
                        return r;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Receptionist getReceptionist(String username) {
        String sql = "SELECT * FROM receptionists WHERE username = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Receptionist r = new Receptionist();
                    r.setUsername(rs.getString("username"));
                    r.setFullName(rs.getString("full_name"));
                    r.setEmail(rs.getString("email"));
                    r.setPhone(rs.getString("phone"));
                    return r;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
