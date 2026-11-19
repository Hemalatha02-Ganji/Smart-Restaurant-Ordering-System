package com.restaurant.dao;

import com.restaurant.model.Restaurant;
import com.restaurant.model.ServiceArea;
import com.restaurant.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantDAO {

    /**
     * Retrieves active restaurants that serve the specified area using case-insensitive matching.
     * Matches either through restaurant_service_areas mapping or primary_area.
     */
    public List<Restaurant> getRestaurantsByArea(String areaName) {
        List<Restaurant> list = new ArrayList<>();
        if (areaName == null || areaName.trim().isEmpty()) {
            return list;
        }

        String sql = "SELECT r.*, " +
                     "COALESCE(MIN(rsa.delivery_charge), 40.00) AS resolved_delivery_charge, " +
                     "COALESCE(MIN(rsa.estimated_time), '30-45 mins') AS resolved_estimated_time " +
                     "FROM restaurants r " +
                     "LEFT JOIN (" +
                     "    restaurant_service_areas rsa " +
                     "    JOIN service_areas sa ON rsa.area_id = sa.area_id AND LOWER(TRIM(sa.area_name)) = LOWER(TRIM(?)) AND sa.is_active = TRUE" +
                     ") ON r.restaurant_id = rsa.restaurant_id " +
                     "WHERE r.is_active = TRUE AND (" +
                     "    LOWER(TRIM(r.primary_area)) = LOWER(TRIM(?)) " +
                     "    OR rsa.restaurant_id IS NOT NULL" +
                     ") " +
                     "GROUP BY r.restaurant_id " +
                     "ORDER BY r.rating DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, areaName);
            ps.setString(2, areaName);
            rs = ps.executeQuery();
            while (rs.next()) {
                Restaurant r = mapResultSetToRestaurant(rs);
                r.setDeliveryCharge(rs.getBigDecimal("resolved_delivery_charge"));
                r.setEstimatedTime(rs.getString("resolved_estimated_time"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return list;
    }

    public List<Restaurant> getAll(boolean onlyActive) {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT * FROM restaurants " + (onlyActive ? "WHERE is_active = TRUE " : "") + "ORDER BY name ASC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                list.add(mapResultSetToRestaurant(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, stmt, conn);
        }
        return list;
    }

    public Restaurant getById(int restaurantId) {
        String sql = "SELECT * FROM restaurants WHERE restaurant_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Restaurant r = mapResultSetToRestaurant(rs);
                r.setServiceAreas(getServiceAreasForRestaurant(conn, restaurantId));
                return r;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    public boolean create(Restaurant r) {
        String sql = "INSERT INTO restaurants (name, cuisine, description, rating, address, primary_area, opening_hours, is_active, image_url, contact_number) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, r.getName());
            ps.setString(2, r.getCuisine());
            ps.setString(3, r.getDescription());
            ps.setBigDecimal(4, r.getRating());
            ps.setString(5, r.getAddress());
            ps.setString(6, r.getPrimaryArea());
            ps.setString(7, r.getOpeningHours());
            ps.setBoolean(8, r.isActive());
            ps.setString(9, r.getImageUrl());
            ps.setString(10, r.getContactNumber());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    r.setRestaurantId(rs.getInt(1));
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

    public boolean update(Restaurant r) {
        String sql = "UPDATE restaurants SET name = ?, cuisine = ?, description = ?, rating = ?, address = ?, " +
                     "primary_area = ?, opening_hours = ?, is_active = ?, image_url = ?, contact_number = ? " +
                     "WHERE restaurant_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, r.getName());
            ps.setString(2, r.getCuisine());
            ps.setString(3, r.getDescription());
            ps.setBigDecimal(4, r.getRating());
            ps.setString(5, r.getAddress());
            ps.setString(6, r.getPrimaryArea());
            ps.setString(7, r.getOpeningHours());
            ps.setBoolean(8, r.isActive());
            ps.setString(9, r.getImageUrl());
            ps.setString(10, r.getContactNumber());
            ps.setInt(11, r.getRestaurantId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    public boolean toggleActive(int restaurantId, boolean isActive) {
        String sql = "UPDATE restaurants SET is_active = ? WHERE restaurant_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setBoolean(1, isActive);
            ps.setInt(2, restaurantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    public boolean delete(int restaurantId) {
        String sql = "DELETE FROM restaurants WHERE restaurant_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    private List<ServiceArea> getServiceAreasForRestaurant(Connection conn, int restaurantId) {
        List<ServiceArea> list = new ArrayList<>();
        String sql = "SELECT sa.*, rsa.delivery_charge, rsa.estimated_time FROM service_areas sa " +
                     "JOIN restaurant_service_areas rsa ON sa.area_id = rsa.area_id " +
                     "WHERE rsa.restaurant_id = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            rs = ps.executeQuery();
            while (rs.next()) {
                ServiceArea sa = new ServiceArea();
                sa.setAreaId(rs.getInt("area_id"));
                sa.setAreaName(rs.getString("area_name"));
                sa.setPincode(rs.getString("pincode"));
                sa.setActive(rs.getBoolean("is_active"));
                sa.setDeliveryCharge(rs.getBigDecimal("delivery_charge"));
                sa.setEstimatedTime(rs.getString("estimated_time"));
                list.add(sa);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps);
        }
        return list;
    }

    private Restaurant mapResultSetToRestaurant(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setRestaurantId(rs.getInt("restaurant_id"));
        r.setName(rs.getString("name"));
        r.setCuisine(rs.getString("cuisine"));
        r.setDescription(rs.getString("description"));
        r.setRating(rs.getBigDecimal("rating"));
        r.setAddress(rs.getString("address"));
        r.setPrimaryArea(rs.getString("primary_area"));
        r.setOpeningHours(rs.getString("opening_hours"));
        r.setActive(rs.getBoolean("is_active"));
        r.setImageUrl(rs.getString("image_url"));
        r.setContactNumber(rs.getString("contact_number"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        return r;
    }
}
