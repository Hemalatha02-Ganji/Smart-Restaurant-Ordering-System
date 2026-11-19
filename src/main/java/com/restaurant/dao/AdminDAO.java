package com.restaurant.dao;

import com.restaurant.model.Admin;
import com.restaurant.util.DBConnectionUtil;
import com.restaurant.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {

    /**
     * Authenticates an admin by username and password.
     */
    public Admin authenticate(String username, String plainPassword) {
        String sql = "SELECT a.*, r.name AS restaurant_name FROM admins a " +
                     "LEFT JOIN restaurants r ON a.restaurant_id = r.restaurant_id " +
                     "WHERE a.username = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                if (PasswordUtil.checkPassword(plainPassword, hashedPassword)) {
                    Admin admin = mapResultSetToAdmin(rs);
                    admin.setRestaurantName(rs.getString("restaurant_name"));
                    return admin;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    public Admin getById(int adminId) {
        String sql = "SELECT a.*, r.name AS restaurant_name FROM admins a " +
                     "LEFT JOIN restaurants r ON a.restaurant_id = r.restaurant_id " +
                     "WHERE a.admin_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, adminId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Admin admin = mapResultSetToAdmin(rs);
                admin.setRestaurantName(rs.getString("restaurant_name"));
                return admin;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    public List<Admin> getAll() {
        List<Admin> list = new ArrayList<>();
        String sql = "SELECT a.*, r.name AS restaurant_name FROM admins a " +
                     "LEFT JOIN restaurants r ON a.restaurant_id = r.restaurant_id " +
                     "ORDER BY a.admin_id ASC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Admin admin = mapResultSetToAdmin(rs);
                admin.setRestaurantName(rs.getString("restaurant_name"));
                list.add(admin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, stmt, conn);
        }
        return list;
    }

    public boolean create(Admin admin) {
        String sql = "INSERT INTO admins (username, password, full_name, email, role, restaurant_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, admin.getUsername());
            ps.setString(2, PasswordUtil.hashPassword(admin.getPassword()));
            ps.setString(3, admin.getFullName());
            ps.setString(4, admin.getEmail());
            ps.setString(5, admin.getRole());
            if (admin.getRestaurantId() != null) {
                ps.setInt(6, admin.getRestaurantId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    admin.setAdminId(rs.getInt(1));
                }
                DBConnectionUtil.close(rs);
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    public boolean update(Admin admin) {
        String sql = "UPDATE admins SET full_name = ?, email = ?, restaurant_id = ? " +
                     (admin.getPassword() != null && !admin.getPassword().isEmpty() ? ", password = ? " : " ") +
                     "WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, admin.getFullName());
            ps.setString(2, admin.getEmail());
            if (admin.getRestaurantId() != null) {
                ps.setInt(3, admin.getRestaurantId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            if (admin.getPassword() != null && !admin.getPassword().isEmpty()) {
                ps.setString(4, PasswordUtil.hashPassword(admin.getPassword()));
                ps.setInt(5, admin.getAdminId());
            } else {
                ps.setInt(4, admin.getAdminId());
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    public boolean delete(int adminId) {
        String sql = "DELETE FROM admins WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, adminId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setAdminId(rs.getInt("admin_id"));
        admin.setUsername(rs.getString("username"));
        admin.setPassword(rs.getString("password"));
        admin.setFullName(rs.getString("full_name"));
        admin.setEmail(rs.getString("email"));
        admin.setRole(rs.getString("role"));
        int rId = rs.getInt("restaurant_id");
        if (!rs.wasNull()) {
            admin.setRestaurantId(rId);
        }
        admin.setCreatedAt(rs.getTimestamp("created_at"));
        return admin;
    }
}

