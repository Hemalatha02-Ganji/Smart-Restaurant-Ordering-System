package com.restaurant.dao;

import com.restaurant.model.*;
import com.restaurant.util.DBConnectionUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO {

    /**
     * Executes an atomic database transaction to persist the complete order:
     * 1. Inserts order record
     * 2. Inserts all order item records
     * 3. Inserts delivery address (if HOME_DELIVERY)
     * 4. Inserts payment record (CASH_ON_DELIVERY, PENDING)
     * 5. Inserts digital invoice record
     */
    public boolean placeOrderTransaction(Order order, Address address, Payment payment, List<OrderItem> items) {
        String insertOrderSql = "INSERT INTO orders (order_code, restaurant_id, customer_name, customer_mobile, " +
                                "customer_area, order_type, order_status, subtotal, gst_amount, delivery_charge, grand_total, special_notes) " +
                                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String insertItemSql = "INSERT INTO order_items (order_id, item_id, item_name, unit_price, quantity, subtotal) " +
                               "VALUES (?, ?, ?, ?, ?, ?)";

        String insertAddressSql = "INSERT INTO addresses (order_id, house_no, street, landmark, area, mobile, instructions) " +
                                  "VALUES (?, ?, ?, ?, ?, ?, ?)";

        String insertPaymentSql = "INSERT INTO payments (order_id, amount, payment_method, payment_status) " +
                                  "VALUES (?, ?, 'CASH_ON_DELIVERY', 'PENDING')";

        String insertInvoiceSql = "INSERT INTO invoices (invoice_number, order_id, restaurant_name, restaurant_address, " +
                                  "customer_name, customer_mobile, order_type, subtotal, gst_amount, delivery_charge, grand_total, payment_method, payment_status) " +
                                  "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'CASH_ON_DELIVERY', 'PENDING')";

        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItem = null;
        PreparedStatement psAddress = null;
        PreparedStatement psPayment = null;
        PreparedStatement psInvoice = null;
        ResultSet rsOrder = null;

        try {
            conn = DBConnectionUtil.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            // 1. Insert Order
            psOrder = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, order.getOrderCode());
            psOrder.setInt(2, order.getRestaurantId());
            psOrder.setString(3, order.getCustomerName());
            psOrder.setString(4, order.getCustomerMobile());
            psOrder.setString(5, order.getCustomerArea());
            psOrder.setString(6, order.getOrderType());
            psOrder.setString(7, order.getOrderStatus() != null ? order.getOrderStatus() : "PLACED");
            psOrder.setBigDecimal(8, order.getSubtotal());
            psOrder.setBigDecimal(9, order.getGstAmount());
            psOrder.setBigDecimal(10, order.getDeliveryCharge());
            psOrder.setBigDecimal(11, order.getGrandTotal());
            psOrder.setString(12, order.getSpecialNotes());

            int affected = psOrder.executeUpdate();
            if (affected == 0) {
                conn.rollback();
                return false;
            }

            rsOrder = psOrder.getGeneratedKeys();
            int generatedOrderId = 0;
            if (rsOrder.next()) {
                generatedOrderId = rsOrder.getInt(1);
                order.setOrderId(generatedOrderId);
            } else {
                conn.rollback();
                return false;
            }

            // 2. Insert Order Items
            psItem = conn.prepareStatement(insertItemSql);
            for (OrderItem it : items) {
                psItem.setInt(1, generatedOrderId);
                psItem.setInt(2, it.getItemId());
                psItem.setString(3, it.getItemName());
                psItem.setBigDecimal(4, it.getUnitPrice());
                psItem.setInt(5, it.getQuantity());
                psItem.setBigDecimal(6, it.getSubtotal());
                psItem.addBatch();
            }
            psItem.executeBatch();

            // 3. Insert Address if HOME_DELIVERY
            if ("HOME_DELIVERY".equalsIgnoreCase(order.getOrderType()) && address != null) {
                psAddress = conn.prepareStatement(insertAddressSql);
                psAddress.setInt(1, generatedOrderId);
                psAddress.setString(2, address.getHouseNo());
                psAddress.setString(3, address.getStreet());
                psAddress.setString(4, address.getLandmark());
                psAddress.setString(5, address.getArea());
                psAddress.setString(6, address.getMobile());
                psAddress.setString(7, address.getInstructions());
                psAddress.executeUpdate();
            }

            // 4. Insert Payment (Strictly COD, PENDING)
            psPayment = conn.prepareStatement(insertPaymentSql);
            psPayment.setInt(1, generatedOrderId);
            psPayment.setBigDecimal(2, order.getGrandTotal());
            psPayment.executeUpdate();

            // 5. Generate and Insert Invoice
            String invoiceNumber = "INV-" + order.getOrderCode().replace("ORD-", "");
            psInvoice = conn.prepareStatement(insertInvoiceSql);
            psInvoice.setString(1, invoiceNumber);
            psInvoice.setInt(2, generatedOrderId);
            psInvoice.setString(3, order.getRestaurantName() != null ? order.getRestaurantName() : "Restaurant #" + order.getRestaurantId());
            psInvoice.setString(4, order.getRestaurantAddress() != null ? order.getRestaurantAddress() : order.getCustomerArea());
            psInvoice.setString(5, order.getCustomerName());
            psInvoice.setString(6, order.getCustomerMobile());
            psInvoice.setString(7, order.getOrderType());
            psInvoice.setBigDecimal(8, order.getSubtotal());
            psInvoice.setBigDecimal(9, order.getGstAmount());
            psInvoice.setBigDecimal(10, order.getDeliveryCharge());
            psInvoice.setBigDecimal(11, order.getGrandTotal());
            psInvoice.executeUpdate();

            // All successful -> commit!
            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            return false;
        } finally {
            DBConnectionUtil.close(rsOrder, psOrder, psItem, psAddress, psPayment, psInvoice, conn);
        }
    }

    public Order getById(int orderId) {
        String sql = "SELECT o.*, r.name AS restaurant_name, r.address AS restaurant_address, " +
                     "p.payment_status, p.payment_method, p.paid_at, " +
                     "inv.invoice_number, inv.invoice_date " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.restaurant_id " +
                     "LEFT JOIN payments p ON o.order_id = p.order_id " +
                     "LEFT JOIN invoices inv ON o.order_id = inv.order_id " +
                     "WHERE o.order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setItems(getOrderItems(conn, orderId));
                order.setAddress(getOrderAddress(conn, orderId));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    public Order getByCode(String orderCode) {
        String sql = "SELECT o.*, r.name AS restaurant_name, r.address AS restaurant_address, " +
                     "p.payment_status, p.payment_method, p.paid_at, " +
                     "inv.invoice_number, inv.invoice_date " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.restaurant_id " +
                     "LEFT JOIN payments p ON o.order_id = p.order_id " +
                     "LEFT JOIN invoices inv ON o.order_id = inv.order_id " +
                     "WHERE LOWER(TRIM(o.order_code)) = LOWER(TRIM(?))";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, orderCode);
            rs = ps.executeQuery();
            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setItems(getOrderItems(conn, order.getOrderId()));
                order.setAddress(getOrderAddress(conn, order.getOrderId()));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    /**
     * Customer tracking validation: Requires both order code and customer mobile number to match.
     */
    public Order getByCodeAndMobile(String orderCode, String mobile) {
        if (orderCode == null || mobile == null) return null;
        String sql = "SELECT o.*, r.name AS restaurant_name, r.address AS restaurant_address, " +
                     "p.payment_status, p.payment_method, p.paid_at, " +
                     "inv.invoice_number, inv.invoice_date " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.restaurant_id " +
                     "LEFT JOIN payments p ON o.order_id = p.order_id " +
                     "LEFT JOIN invoices inv ON o.order_id = inv.order_id " +
                     "WHERE LOWER(TRIM(o.order_code)) = LOWER(TRIM(?)) AND TRIM(o.customer_mobile) = TRIM(?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, orderCode);
            ps.setString(2, mobile);
            rs = ps.executeQuery();
            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setItems(getOrderItems(conn, order.getOrderId()));
                order.setAddress(getOrderAddress(conn, order.getOrderId()));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return null;
    }

    public List<Order> getOrdersByRestaurant(int restaurantId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.name AS restaurant_name, r.address AS restaurant_address, " +
                     "p.payment_status, p.payment_method, p.paid_at, " +
                     "inv.invoice_number, inv.invoice_date " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.restaurant_id " +
                     "LEFT JOIN payments p ON o.order_id = p.order_id " +
                     "LEFT JOIN invoices inv ON o.order_id = inv.order_id " +
                     "WHERE o.restaurant_id = ? ORDER BY o.created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setItems(getOrderItems(conn, order.getOrderId()));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return list;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.name AS restaurant_name, r.address AS restaurant_address, " +
                     "p.payment_status, p.payment_method, p.paid_at, " +
                     "inv.invoice_number, inv.invoice_date " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.restaurant_id " +
                     "LEFT JOIN payments p ON o.order_id = p.order_id " +
                     "LEFT JOIN invoices inv ON o.order_id = inv.order_id " +
                     "ORDER BY o.created_at DESC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setItems(getOrderItems(conn, order.getOrderId()));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, stmt, conn);
        }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(ps, conn);
        }
        return false;
    }

    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE payments SET payment_status = ?, paid_at = CASE WHEN ? = 'PAID' THEN CURRENT_TIMESTAMP ELSE NULL END WHERE order_id = ?";
        String updateInv = "UPDATE invoices SET payment_status = ? WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        try {
            conn = DBConnectionUtil.getConnection();
            conn.setAutoCommit(false);
            ps1 = conn.prepareStatement(sql);
            ps1.setString(1, paymentStatus);
            ps1.setString(2, paymentStatus);
            ps1.setInt(3, orderId);
            ps1.executeUpdate();

            ps2 = conn.prepareStatement(updateInv);
            ps2.setString(1, paymentStatus);
            ps2.setInt(2, orderId);
            ps2.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
        } finally {
            DBConnectionUtil.close(ps1, ps2, conn);
        }
        return false;
    }

    public Map<String, Object> getRestaurantStatistics(int restaurantId) {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) AS total_orders, " +
                     "SUM(CASE WHEN order_status IN ('PLACED', 'ACCEPTED', 'PREPARING') THEN 1 ELSE 0 END) AS pending_orders, " +
                     "SUM(CASE WHEN order_status IN ('DELIVERED', 'COMPLETED') THEN 1 ELSE 0 END) AS completed_orders, " +
                     "SUM(CASE WHEN DATE(created_at) = CURDATE() THEN 1 ELSE 0 END) AS today_orders, " +
                     "COALESCE(SUM(CASE WHEN order_status IN ('DELIVERED', 'COMPLETED') THEN grand_total ELSE 0 END), 0) AS total_revenue, " +
                     "COALESCE(SUM(CASE WHEN DATE(created_at) = CURDATE() AND order_status IN ('DELIVERED', 'COMPLETED') THEN grand_total ELSE 0 END), 0) AS today_revenue " +
                     "FROM orders WHERE restaurant_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("totalOrders", rs.getInt("total_orders"));
                stats.put("pendingOrders", rs.getInt("pending_orders"));
                stats.put("completedOrders", rs.getInt("completed_orders"));
                stats.put("todayOrders", rs.getInt("today_orders"));
                stats.put("totalRevenue", rs.getBigDecimal("total_revenue"));
                stats.put("todayRevenue", rs.getBigDecimal("today_revenue"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps, conn);
        }
        return stats;
    }

    public Map<String, Object> getPlatformStatistics() {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(DISTINCT r.restaurant_id) AS total_restaurants, " +
                     "COUNT(DISTINCT o.order_id) AS total_orders, " +
                     "COUNT(DISTINCT o.customer_mobile) AS total_customers, " +
                     "COUNT(DISTINCT res.reservation_id) AS total_reservations, " +
                     "COALESCE(SUM(CASE WHEN o.order_status IN ('DELIVERED', 'COMPLETED') THEN o.grand_total ELSE 0 END), 0) AS total_revenue " +
                     "FROM restaurants r " +
                     "LEFT JOIN orders o ON 1=1 " +
                     "LEFT JOIN reservations res ON 1=1";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                stats.put("totalRestaurants", rs.getInt("total_restaurants"));
                stats.put("totalOrders", rs.getInt("total_orders"));
                stats.put("totalCustomers", rs.getInt("total_customers"));
                stats.put("totalReservations", rs.getInt("total_reservations"));
                stats.put("totalRevenue", rs.getBigDecimal("total_revenue"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, stmt, conn);
        }
        return stats;
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

    private Address getOrderAddress(Connection conn, int orderId) {
        String sql = "SELECT * FROM addresses WHERE order_id = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Address a = new Address();
                a.setAddressId(rs.getInt("address_id"));
                a.setOrderId(rs.getInt("order_id"));
                a.setHouseNo(rs.getString("house_no"));
                a.setStreet(rs.getString("street"));
                a.setLandmark(rs.getString("landmark"));
                a.setArea(rs.getString("area"));
                a.setMobile(rs.getString("mobile"));
                a.setInstructions(rs.getString("instructions"));
                return a;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnectionUtil.close(rs, ps);
        }
        return null;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setOrderCode(rs.getString("order_code"));
        o.setRestaurantId(rs.getInt("restaurant_id"));
        o.setCustomerName(rs.getString("customer_name"));
        o.setCustomerMobile(rs.getString("customer_mobile"));
        o.setCustomerArea(rs.getString("customer_area"));
        o.setOrderType(rs.getString("order_type"));
        o.setOrderStatus(rs.getString("order_status"));
        o.setSubtotal(rs.getBigDecimal("subtotal"));
        o.setGstAmount(rs.getBigDecimal("gst_amount"));
        o.setDeliveryCharge(rs.getBigDecimal("delivery_charge"));
        o.setGrandTotal(rs.getBigDecimal("grand_total"));
        o.setSpecialNotes(rs.getString("special_notes"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        o.setRestaurantName(rs.getString("restaurant_name"));
        o.setRestaurantAddress(rs.getString("restaurant_address"));

        Payment p = new Payment();
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setPaymentStatus(rs.getString("payment_status"));
        p.setPaidAt(rs.getTimestamp("paid_at"));
        o.setPayment(p);

        String invNum = rs.getString("invoice_number");
        if (invNum != null) {
            Invoice inv = new Invoice();
            inv.setInvoiceNumber(invNum);
            inv.setInvoiceDate(rs.getTimestamp("invoice_date"));
            inv.setGrandTotal(o.getGrandTotal());
            inv.setPaymentStatus(p.getPaymentStatus());
            o.setInvoice(inv);
        }

        return o;
    }
}

