package com.restaurant.dao;

import com.restaurant.model.Review;
import com.restaurant.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public List<Review> getByRestaurant(int restaurantId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT * FROM reviews WHERE restaurant_id = ? ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("review_id"));
                r.setRestaurantId(rs.getInt("restaurant_id"));
                r.setCustomerName(rs.getString("customer_name"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return list;
    }

    public boolean create(Review review) {
        String sql = "INSERT INTO reviews (restaurant_id, customer_name, rating, comment) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, review.getRestaurantId());
            ps.setString(2, review.getCustomerName());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }
}

