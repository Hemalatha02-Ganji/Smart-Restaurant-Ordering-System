package com.restaurant.dao;

import com.restaurant.model.Invoice;
import com.restaurant.model.OrderItem;
import com.restaurant.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    public Invoice getByOrderId(int orderId) {
        String sql = "SELECT inv.*, o.order_code FROM invoices inv " +
                     "JOIN orders o ON inv.order_id = o.order_id " +
                     "WHERE inv.order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Invoice inv = mapResultSetToInvoice(rs);
                inv.setItems(getOrderItems(conn, orderId));
                return inv;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    public Invoice getByInvoiceNumber(String invoiceNumber) {
        String sql = "SELECT inv.*, o.order_code FROM invoices inv " +
                     "JOIN orders o ON inv.order_id = o.order_id " +
                     "WHERE LOWER(TRIM(inv.invoice_number)) = LOWER(TRIM(?))";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, invoiceNumber);
            rs = ps.executeQuery();
            if (rs.next()) {
                Invoice inv = mapResultSetToInvoice(rs);
                inv.setItems(getOrderItems(conn, inv.getOrderId()));
                return inv;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    public List<Invoice> getByRestaurant(int restaurantId) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT inv.*, o.order_code FROM invoices inv " +
                     "JOIN orders o ON inv.order_id = o.order_id " +
                     "WHERE o.restaurant_id = ? ORDER BY inv.invoice_date DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Invoice inv = mapResultSetToInvoice(rs);
                list.add(inv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return list;
    }

    public List<Invoice> getAll() {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT inv.*, o.order_code FROM invoices inv " +
                     "JOIN orders o ON inv.order_id = o.order_id " +
                     "ORDER BY inv.invoice_date DESC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Invoice inv = mapResultSetToInvoice(rs);
                list.add(inv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, stmt, conn);
        }
        return list;
    }

    private List<OrderItem> getOrderItems(Connection conn, int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem it = new OrderItem();
                it.setOrderItemId(rs.getInt("order_item_id"));
                it.setOrderId(rs.getInt("order_id"));
                it.setItemId(rs.getInt("item_id"));
                it.setItemName(rs.getString("item_name"));
                it.setUnitPrice(rs.getBigDecimal("unit_price"));
                it.setQuantity(rs.getInt("quantity"));
                it.setSubtotal(rs.getBigDecimal("subtotal"));
                items.add(it);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps);
        }
        return items;
    }

    private Invoice mapResultSetToInvoice(ResultSet rs) throws SQLException {
        Invoice inv = new Invoice();
        inv.setInvoiceId(rs.getInt("invoice_id"));
        inv.setInvoiceNumber(rs.getString("invoice_number"));
        inv.setOrderId(rs.getInt("order_id"));
        inv.setRestaurantName(rs.getString("restaurant_name"));
        inv.setRestaurantAddress(rs.getString("restaurant_address"));
        inv.setCustomerName(rs.getString("customer_name"));
        inv.setCustomerMobile(rs.getString("customer_mobile"));
        inv.setOrderType(rs.getString("order_type"));
        inv.setSubtotal(rs.getBigDecimal("subtotal"));
        inv.setGstAmount(rs.getBigDecimal("gst_amount"));
        inv.setDeliveryCharge(rs.getBigDecimal("delivery_charge"));
        inv.setGrandTotal(rs.getBigDecimal("grand_total"));
        inv.setPaymentMethod(rs.getString("payment_method"));
        inv.setPaymentStatus(rs.getString("payment_status"));
        inv.setInvoiceDate(rs.getTimestamp("invoice_date"));
        inv.setOrderCode(rs.getString("order_code"));
        return inv;
    }
}

