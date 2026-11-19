package com.restaurant.dao;

import com.restaurant.model.RestaurantTable;
import com.restaurant.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TableDAO {

    public List<RestaurantTable> getTablesByRestaurant(int restaurantId) {
        List<RestaurantTable> list = new ArrayList<>();
        String sql = "SELECT t.*, r.name AS restaurant_name FROM restaurant_tables t " +
                     "JOIN restaurants r ON t.restaurant_id = r.restaurant_id " +
                     "WHERE t.restaurant_id = ? ORDER BY t.capacity ASC, t.table_number ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            rs = ps.executeQuery();
            while (rs.next()) {
                RestaurantTable t = mapResultSetToTable(rs);
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return list;
    }

    /**
     * Finds active tables with capacity >= guestCount that are NOT reserved
     * for the given date and time slot (where status is PENDING or APPROVED).
     */
    public List<RestaurantTable> getAvailableTables(int restaurantId, Date date, String timeSlot, int guestCount) {
        List<RestaurantTable> list = new ArrayList<>();
        String sql = "SELECT t.*, r.name AS restaurant_name FROM restaurant_tables t " +
                     "JOIN restaurants r ON t.restaurant_id = r.restaurant_id " +
                     "WHERE t.restaurant_id = ? " +
                     "AND t.is_active = TRUE " +
                     "AND t.capacity >= ? " +
                     "AND t.table_id NOT IN (" +
                     "   SELECT res.table_id FROM reservations res " +
                     "   WHERE res.restaurant_id = ? " +
                     "   AND res.reservation_date = ? " +
                     "   AND res.time_slot = ? " +
                     "   AND res.status IN ('PENDING', 'APPROVED')" +
                     ") ORDER BY t.capacity ASC, t.table_number ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            ps.setInt(2, guestCount);
            ps.setInt(3, restaurantId);
            ps.setDate(4, date);
            ps.setString(5, timeSlot);
            rs = ps.executeQuery();
            while (rs.next()) {
                RestaurantTable t = mapResultSetToTable(rs);
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return list;
    }

    public RestaurantTable getById(int tableId) {
        String sql = "SELECT t.*, r.name AS restaurant_name FROM restaurant_tables t " +
                     "JOIN restaurants r ON t.restaurant_id = r.restaurant_id " +
                     "WHERE t.table_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, tableId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToTable(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    public boolean create(RestaurantTable table) {
        String sql = "INSERT INTO restaurant_tables (restaurant_id, table_number, capacity, is_active) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, table.getRestaurantId());
            ps.setString(2, table.getTableNumber());
            ps.setInt(3, table.getCapacity());
            ps.setBoolean(4, table.isActive());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    table.setTableId(rs.getInt(1));
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

    public boolean update(RestaurantTable table) {
        String sql = "UPDATE restaurant_tables SET table_number = ?, capacity = ?, is_active = ? WHERE table_id = ? AND restaurant_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, table.getTableNumber());
            ps.setInt(2, table.getCapacity());
            ps.setBoolean(3, table.isActive());
            ps.setInt(4, table.getTableId());
            ps.setInt(5, table.getRestaurantId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    public boolean delete(int tableId, int restaurantId) {
        String sql = "DELETE FROM restaurant_tables WHERE table_id = ? AND restaurant_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, tableId);
            ps.setInt(2, restaurantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    private RestaurantTable mapResultSetToTable(ResultSet rs) throws SQLException {
        RestaurantTable t = new RestaurantTable();
        t.setTableId(rs.getInt("table_id"));
        t.setRestaurantId(rs.getInt("restaurant_id"));
        t.setTableNumber(rs.getString("table_number"));
        t.setCapacity(rs.getInt("capacity"));
        t.setActive(rs.getBoolean("is_active"));
        t.setRestaurantName(rs.getString("restaurant_name"));
        return t;
    }
}

