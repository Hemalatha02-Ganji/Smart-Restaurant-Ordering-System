package com.restaurant.dao;

import com.restaurant.model.MenuItem;
import com.restaurant.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuItemDAO {

    public List<MenuItem> getByRestaurant(int restaurantId, boolean onlyAvailable) {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT m.*, c.category_name, r.name AS restaurant_name FROM menu_items m " +
                     "JOIN categories c ON m.category_id = c.category_id " +
                     "JOIN restaurants r ON m.restaurant_id = r.restaurant_id " +
                     "WHERE m.restaurant_id = ? " +
                     (onlyAvailable ? "AND m.is_available = TRUE " : "") +
                     "ORDER BY c.display_order ASC, m.name ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToMenuItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return list;
    }

    public List<MenuItem> getByRestaurantAndCategory(int restaurantId, int categoryId) {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT m.*, c.category_name, r.name AS restaurant_name FROM menu_items m " +
                     "JOIN categories c ON m.category_id = c.category_id " +
                     "JOIN restaurants r ON m.restaurant_id = r.restaurant_id " +
                     "WHERE m.restaurant_id = ? AND m.category_id = ? " +
                     "ORDER BY m.name ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            ps.setInt(2, categoryId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToMenuItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return list;
    }

    public List<MenuItem> searchItems(int restaurantId, String query) {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT m.*, c.category_name, r.name AS restaurant_name FROM menu_items m " +
                     "JOIN categories c ON m.category_id = c.category_id " +
                     "JOIN restaurants r ON m.restaurant_id = r.restaurant_id " +
                     "WHERE m.restaurant_id = ? AND (LOWER(m.name) LIKE ? OR LOWER(m.description) LIKE ?) " +
                     "ORDER BY m.name ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            String searchPattern = "%" + query.toLowerCase() + "%";
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToMenuItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return list;
    }

    public MenuItem getById(int itemId) {
        String sql = "SELECT m.*, c.category_name, r.name AS restaurant_name FROM menu_items m " +
                     "JOIN categories c ON m.category_id = c.category_id " +
                     "JOIN restaurants r ON m.restaurant_id = r.restaurant_id " +
                     "WHERE m.item_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, itemId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToMenuItem(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    public boolean create(MenuItem item) {
        String sql = "INSERT INTO menu_items (restaurant_id, category_id, name, description, price, food_type, is_available, image_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, item.getRestaurantId());
            ps.setInt(2, item.getCategoryId());
            ps.setString(3, item.getName());
            ps.setString(4, item.getDescription());
            ps.setBigDecimal(5, item.getPrice());
            ps.setString(6, item.getFoodType());
            ps.setBoolean(7, item.isAvailable());
            ps.setString(8, item.getImageUrl());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    item.setItemId(rs.getInt(1));
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

    public boolean update(MenuItem item) {
        String sql = "UPDATE menu_items SET category_id = ?, name = ?, description = ?, price = ?, " +
                     "food_type = ?, is_available = ?, image_url = ? WHERE item_id = ? AND restaurant_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, item.getCategoryId());
            ps.setString(2, item.getName());
            ps.setString(3, item.getDescription());
            ps.setBigDecimal(4, item.getPrice());
            ps.setString(5, item.getFoodType());
            ps.setBoolean(6, item.isAvailable());
            ps.setString(7, item.getImageUrl());
            ps.setInt(8, item.getItemId());
            ps.setInt(9, item.getRestaurantId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    public boolean toggleAvailability(int itemId, int restaurantId, boolean isAvailable) {
        String sql = "UPDATE menu_items SET is_available = ? WHERE item_id = ? AND restaurant_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setBoolean(1, isAvailable);
            ps.setInt(2, itemId);
            ps.setInt(3, restaurantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    public boolean delete(int itemId, int restaurantId) {
        String sql = "DELETE FROM menu_items WHERE item_id = ? AND restaurant_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, itemId);
            ps.setInt(2, restaurantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    private MenuItem mapResultSetToMenuItem(ResultSet rs) throws SQLException {
        MenuItem m = new MenuItem();
        m.setItemId(rs.getInt("item_id"));
        m.setRestaurantId(rs.getInt("restaurant_id"));
        m.setCategoryId(rs.getInt("category_id"));
        m.setName(rs.getString("name"));
        m.setDescription(rs.getString("description"));
        m.setPrice(rs.getBigDecimal("price"));
        m.setFoodType(rs.getString("food_type"));
        m.setAvailable(rs.getBoolean("is_available"));
        m.setImageUrl(rs.getString("image_url"));
        m.setCreatedAt(rs.getTimestamp("created_at"));
        m.setCategoryName(rs.getString("category_name"));
        m.setRestaurantName(rs.getString("restaurant_name"));
        return m;
    }
}

