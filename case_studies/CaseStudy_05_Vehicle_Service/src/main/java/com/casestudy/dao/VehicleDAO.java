package com.casestudy.dao;

import com.casestudy.util.DBUtil;
import java.sql.*;
import java.util.*;

public class VehicleDAO {

    public boolean registerCustomer(String id, String name, String email, String phone, String pass) throws SQLException {
        String sql = "INSERT INTO customers (customer_id, customer_name, email, phone, password) VALUES (?, ?, ?, ?, ?)";
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

    public Map<String, String> loginCustomer(String idOrEmail, String pass) throws SQLException {
        String sql = "SELECT * FROM customers WHERE (customer_id = ? OR email = ?) AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, idOrEmail);
            ps.setString(2, idOrEmail);
            ps.setString(3, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("customerId", rs.getString("customer_id"));
                    map.put("customerName", rs.getString("customer_name"));
                    return map;
                }
            }
        }
        return null;
    }

    public boolean loginAdvisor(String user, String pass) throws SQLException {
        String sql = "SELECT * FROM service_advisors WHERE username = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean addVehicle(String custId, String regNo, String make, String model, int year) throws SQLException {
        String sql = "INSERT INTO vehicles (customer_id, reg_number, make, model, mfg_year) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, custId);
            ps.setString(2, regNo.toUpperCase());
            ps.setString(3, make);
            ps.setString(4, model);
            ps.setInt(5, year);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Map<String, Object>> getCustomerVehicles(String custId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM vehicles WHERE customer_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, custId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("vehicleId", rs.getInt("vehicle_id"));
                    map.put("regNumber", rs.getString("reg_number"));
                    map.put("make", rs.getString("make"));
                    map.put("model", rs.getString("model"));
                    map.put("mfgYear", rs.getInt("mfg_year"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public boolean bookService(String custId, int vehicleId, String type, String date, String slot) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM service_bookings WHERE vehicle_id = ? AND preferred_date = ? AND time_slot = ? AND status != 'Cancelled'";
        String insertSql = "INSERT INTO service_bookings (customer_id, vehicle_id, service_type, preferred_date, time_slot, status) VALUES (?, ?, ?, ?, ?, 'Pending')";

        try (Connection con = DBUtil.getConnection()) {
            try (PreparedStatement check = con.prepareStatement(checkSql)) {
                check.setInt(1, vehicleId);
                check.setDate(2, Date.valueOf(date));
                check.setString(3, slot);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        return false; // Duplicate slot booking!
                    }
                }
            }
            try (PreparedStatement insert = con.prepareStatement(insertSql)) {
                insert.setString(1, custId);
                insert.setInt(2, vehicleId);
                insert.setString(3, type);
                insert.setDate(4, Date.valueOf(date));
                insert.setString(5, slot);
                return insert.executeUpdate() > 0;
            }
        }
    }

    public List<Map<String, Object>> getCustomerBookings(String custId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.*, v.reg_number, v.make, v.model FROM service_bookings b " +
                     "JOIN vehicles v ON b.vehicle_id = v.vehicle_id WHERE b.customer_id = ? ORDER BY b.preferred_date DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, custId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("bookingId", rs.getInt("booking_id"));
                    map.put("vehicle", rs.getString("reg_number") + " (" + rs.getString("make") + " " + rs.getString("model") + ")");
                    map.put("serviceType", rs.getString("service_type"));
                    map.put("date", rs.getDate("preferred_date"));
                    map.put("timeSlot", rs.getString("time_slot"));
                    map.put("status", rs.getString("status"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public List<Map<String, Object>> getAllBookings(String date, String status) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.*, c.customer_name, c.phone, v.reg_number, v.make, v.model FROM service_bookings b " +
                     "JOIN customers c ON b.customer_id = c.customer_id " +
                     "JOIN vehicles v ON b.vehicle_id = v.vehicle_id WHERE 1=1 ";
        if (date != null && !date.trim().isEmpty()) sql += " AND b.preferred_date = ? ";
        if (status != null && !status.trim().isEmpty()) sql += " AND b.status = ? ";
        sql += " ORDER BY b.preferred_date DESC, b.time_slot ASC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int idx = 1;
            if (date != null && !date.trim().isEmpty()) ps.setDate(idx++, Date.valueOf(date.trim()));
            if (status != null && !status.trim().isEmpty()) ps.setString(idx++, status.trim());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("bookingId", rs.getInt("booking_id"));
                    map.put("customer", rs.getString("customer_name") + " (" + rs.getString("phone") + ")");
                    map.put("vehicle", rs.getString("reg_number") + " (" + rs.getString("make") + " " + rs.getString("model") + ")");
                    map.put("serviceType", rs.getString("service_type"));
                    map.put("date", rs.getDate("preferred_date"));
                    map.put("timeSlot", rs.getString("time_slot"));
                    map.put("status", rs.getString("status"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public boolean updateStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE service_bookings SET status = ? WHERE booking_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        }
    }
}
