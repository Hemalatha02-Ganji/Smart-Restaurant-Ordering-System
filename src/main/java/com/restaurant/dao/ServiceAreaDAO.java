package com.restaurant.dao;

import com.restaurant.model.ServiceArea;
import com.restaurant.util.DBConnectionUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceAreaDAO {

    public List<ServiceArea> getAllAreas(boolean onlyActive) {
        List<ServiceArea> list = new ArrayList<>();
        String sql = "SELECT * FROM service_areas " + (onlyActive ? "WHERE is_active = TRUE " : "") + "ORDER BY area_name ASC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                list.add(mapResultSetToServiceArea(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, stmt, conn);
        }
        return list;
    }

    public ServiceArea getById(int areaId) {
        String sql = "SELECT * FROM service_areas WHERE area_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, areaId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToServiceArea(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    public ServiceArea getByName(String areaName) {
        if (areaName == null) return null;
        String sql = "SELECT * FROM service_areas WHERE LOWER(TRIM(area_name)) = LOWER(TRIM(?))";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, areaName);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToServiceArea(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    public boolean create(ServiceArea area) {
        String sql = "INSERT INTO service_areas (area_name, pincode, is_active) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, area.getAreaName());
            ps.setString(2, area.getPincode());
            ps.setBoolean(3, area.isActive());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    area.setAreaId(rs.getInt(1));
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

    public boolean assignAreaToRestaurant(int restaurantId, int areaId, BigDecimal deliveryCharge, String estTime) {
        String sql = "INSERT INTO restaurant_service_areas (restaurant_id, area_id, delivery_charge, estimated_time) " +
                     "VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE delivery_charge = VALUES(delivery_charge), estimated_time = VALUES(estimated_time)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            ps.setInt(2, areaId);
            ps.setBigDecimal(3, deliveryCharge != null ? deliveryCharge : BigDecimal.valueOf(40.00));
            ps.setString(4, estTime != null ? estTime : "30-45 mins");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    public boolean removeAreaFromRestaurant(int restaurantId, int areaId) {
        String sql = "DELETE FROM restaurant_service_areas WHERE restaurant_id = ? AND area_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            ps.setInt(2, areaId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    public boolean delete(int areaId) {
        String sql = "DELETE FROM service_areas WHERE area_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, areaId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    private ServiceArea mapResultSetToServiceArea(ResultSet rs) throws SQLException {
        ServiceArea sa = new ServiceArea();
        sa.setAreaId(rs.getInt("area_id"));
        sa.setAreaName(rs.getString("area_name"));
        sa.setPincode(rs.getString("pincode"));
        sa.setActive(rs.getBoolean("is_active"));
        return sa;
    }
}

