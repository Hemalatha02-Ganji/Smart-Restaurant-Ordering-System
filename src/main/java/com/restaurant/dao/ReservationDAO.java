package com.restaurant.dao;

import com.restaurant.model.Reservation;
import com.restaurant.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    /**
     * Creates a table reservation with transactional double-booking prevention.
     * Uses SELECT ... FOR UPDATE to lock the table/slot atomically.
     */
    public synchronized boolean createReservation(Reservation res) {
        String checkSql = "SELECT reservation_id FROM reservations " +
                          "WHERE restaurant_id = ? AND table_id = ? " +
                          "AND reservation_date = ? AND time_slot = ? " +
                          "AND status IN ('PENDING', 'APPROVED') FOR UPDATE";

        String insertSql = "INSERT INTO reservations (restaurant_id, table_id, order_id, customer_name, customer_mobile, " +
                           "reservation_date, time_slot, guest_count, special_requests, status) " +
                           "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement checkPs = null;
        PreparedStatement insertPs = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            // 1. Check for overlapping active reservations on the same table, date & slot
            checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, res.getRestaurantId());
            checkPs.setInt(2, res.getTableId());
            checkPs.setDate(3, res.getReservationDate());
            checkPs.setString(4, res.getTimeSlot());
            rs = checkPs.executeQuery();

            if (rs.next()) {
                // Already reserved! Rollback and reject
                conn.rollback();
                return false;
            }

            // 2. Insert new reservation
            insertPs = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            insertPs.setInt(1, res.getRestaurantId());
            insertPs.setInt(2, res.getTableId());
            if (res.getOrderId() != null) {
                insertPs.setInt(3, res.getOrderId());
            } else {
                insertPs.setNull(3, Types.INTEGER);
            }
            insertPs.setString(4, res.getCustomerName());
            insertPs.setString(5, res.getCustomerMobile());
            insertPs.setDate(6, res.getReservationDate());
            insertPs.setString(7, res.getTimeSlot());
            insertPs.setInt(8, res.getGuestCount());
            insertPs.setString(9, res.getSpecialRequests());
            insertPs.setString(10, res.getStatus() != null ? res.getStatus() : "PENDING");

            int rows = insertPs.executeUpdate();
            if (rows > 0) {
                ResultSet genKeys = insertPs.getGeneratedKeys();
                if (genKeys.next()) {
                    res.setReservationId(genKeys.getInt(1));
                }
                DBConnectionUtil.close(genKeys);
                conn.commit(); // Commit transaction
                return true;
            } else {
                conn.rollback();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
        } finally {
            DBConnectionUtil.close(rs, checkPs, insertPs, conn);
        }
        return false;
    }

    public boolean isTableAvailable(int restaurantId, int tableId, Date date, String timeSlot) {
        String sql = "SELECT COUNT(*) FROM reservations " +
                     "WHERE restaurant_id = ? AND table_id = ? " +
                     "AND reservation_date = ? AND time_slot = ? " +
                     "AND status IN ('PENDING', 'APPROVED')";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            ps.setInt(2, tableId);
            ps.setDate(3, date);
            ps.setString(4, timeSlot);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return false;
    }

    public List<Reservation> getByRestaurant(int restaurantId) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT res.*, r.name AS restaurant_name, t.table_number, t.capacity AS table_capacity " +
                     "FROM reservations res " +
                     "JOIN restaurants r ON res.restaurant_id = r.restaurant_id " +
                     "JOIN restaurant_tables t ON res.table_id = t.table_id " +
                     "WHERE res.restaurant_id = ? ORDER BY res.reservation_date DESC, res.created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return list;
    }

    public List<Reservation> getAll() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT res.*, r.name AS restaurant_name, t.table_number, t.capacity AS table_capacity " +
                     "FROM reservations res " +
                     "JOIN restaurants r ON res.restaurant_id = r.restaurant_id " +
                     "JOIN restaurant_tables t ON res.table_id = t.table_id " +
                     "ORDER BY res.reservation_date DESC, res.created_at DESC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                list.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, stmt, conn);
        }
        return list;
    }

    public Reservation getById(int reservationId) {
        String sql = "SELECT res.*, r.name AS restaurant_name, t.table_number, t.capacity AS table_capacity " +
                     "FROM reservations res " +
                     "JOIN restaurants r ON res.restaurant_id = r.restaurant_id " +
                     "JOIN restaurant_tables t ON res.table_id = t.table_id " +
                     "WHERE res.reservation_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, reservationId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToReservation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    public boolean updateStatus(int reservationId, String status) {
        String sql = "UPDATE reservations SET status = ? WHERE reservation_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, reservationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation res = new Reservation();
        res.setReservationId(rs.getInt("reservation_id"));
        res.setRestaurantId(rs.getInt("restaurant_id"));
        res.setTableId(rs.getInt("table_id"));
        int ordId = rs.getInt("order_id");
        if (!rs.wasNull()) {
            res.setOrderId(ordId);
        }
        res.setCustomerName(rs.getString("customer_name"));
        res.setCustomerMobile(rs.getString("customer_mobile"));
        res.setReservationDate(rs.getDate("reservation_date"));
        res.setTimeSlot(rs.getString("time_slot"));
        res.setGuestCount(rs.getInt("guest_count"));
        res.setSpecialRequests(rs.getString("special_requests"));
        res.setStatus(rs.getString("status"));
        res.setCreatedAt(rs.getTimestamp("created_at"));
        res.setRestaurantName(rs.getString("restaurant_name"));
        res.setTableNumber(rs.getString("table_number"));
        res.setTableCapacity(rs.getInt("table_capacity"));
        return res;
    }
}

