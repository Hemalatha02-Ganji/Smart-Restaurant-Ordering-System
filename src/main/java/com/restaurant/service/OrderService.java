package com.restaurant.service;

import com.restaurant.dao.MenuItemDAO;
import com.restaurant.dao.OrderDAO;
import com.restaurant.dao.RestaurantDAO;
import com.restaurant.model.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.*;

public class OrderService {

    private final OrderDAO orderDAO = new OrderDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final RestaurantDAO restaurantDAO = new RestaurantDAO();

    /**
     * Creates and validates an order from cart items with strict server-side price validation.
     */
    public Order placeOrder(Cart cart, String customerName, String customerMobile, String customerArea,
                           String orderType, Address deliveryAddress, String specialNotes) {
        if (cart == null || cart.isEmpty()) {
            throw new IllegalArgumentException("Cart cannot be empty");
        }
        if (customerName == null || customerName.trim().isEmpty()) {
            throw new IllegalArgumentException("Customer name is required");
        }
        if (customerMobile == null || customerMobile.trim().isEmpty()) {
            throw new IllegalArgumentException("Customer mobile number is required");
        }

        // 1. Server-side price re-verification directly from DB
        List<OrderItem> items = new ArrayList<>();
        BigDecimal verifiedSubtotal = BigDecimal.ZERO;

        for (CartItem ci : cart.getItems()) {
            MenuItem dbItem = menuItemDAO.getById(ci.getMenuItem().getItemId());
            if (dbItem == null || !dbItem.isAvailable()) {
                throw new IllegalStateException("Food item '" + ci.getMenuItem().getName() + "' is currently unavailable.");
            }

            BigDecimal unitPrice = dbItem.getPrice();
            BigDecimal itemSubtotal = unitPrice.multiply(BigDecimal.valueOf(ci.getQuantity()));
            verifiedSubtotal = verifiedSubtotal.add(itemSubtotal);

            OrderItem orderItem = new OrderItem(
                dbItem.getItemId(),
                dbItem.getName(),
                unitPrice,
                ci.getQuantity(),
                itemSubtotal.setScale(2, RoundingMode.HALF_UP)
            );
            items.add(orderItem);
        }

        verifiedSubtotal = verifiedSubtotal.setScale(2, RoundingMode.HALF_UP);
        BigDecimal gstAmount = verifiedSubtotal.multiply(BigDecimal.valueOf(0.05)).setScale(2, RoundingMode.HALF_UP);

        BigDecimal deliveryCharge = BigDecimal.ZERO;
        if ("HOME_DELIVERY".equalsIgnoreCase(orderType)) {
            deliveryCharge = cart.getDeliveryCharge() != null ? cart.getDeliveryCharge() : BigDecimal.valueOf(40.00);
        }

        BigDecimal grandTotal = verifiedSubtotal.add(gstAmount).add(deliveryCharge).setScale(2, RoundingMode.HALF_UP);

        // 2. Build Order object
        String orderCode = generateOrderCode();
        Order order = new Order();
        order.setOrderCode(orderCode);
        order.setRestaurantId(cart.getRestaurantId());
        order.setCustomerName(customerName.trim());
        order.setCustomerMobile(customerMobile.trim());
        order.setCustomerArea(customerArea != null ? customerArea.trim() : "Mylavaram");
        order.setOrderType("DINE_IN".equalsIgnoreCase(orderType) ? "DINE_IN" : "HOME_DELIVERY");
        order.setOrderStatus("PLACED");
        order.setSubtotal(verifiedSubtotal);
        order.setGstAmount(gstAmount);
        order.setDeliveryCharge(deliveryCharge);
        order.setGrandTotal(grandTotal);
        order.setSpecialNotes(specialNotes);

        Restaurant r = restaurantDAO.getById(cart.getRestaurantId());
        if (r != null) {
            order.setRestaurantName(r.getName());
            order.setRestaurantAddress(r.getAddress());
        }

        Payment payment = new Payment(grandTotal);
        order.setPayment(payment);
        order.setItems(items);

        if ("HOME_DELIVERY".equalsIgnoreCase(orderType) && deliveryAddress != null) {
            deliveryAddress.setMobile(customerMobile);
            deliveryAddress.setArea(order.getCustomerArea());
            order.setAddress(deliveryAddress);
        }

        // 3. Persist atomically
        boolean success = orderDAO.placeOrderTransaction(order, deliveryAddress, payment, items);
        if (success) {
            return order;
        } else {
            throw new RuntimeException("Failed to place order in database transaction.");
        }
    }

    public Order getOrderById(int orderId) {
        return orderDAO.getById(orderId);
    }

    public Order getOrderByCode(String orderCode) {
        return orderDAO.getByCode(orderCode);
    }

    public Order trackOrder(String orderCode, String mobile) {
        return orderDAO.getByCodeAndMobile(orderCode, mobile);
    }

    public List<Order> getOrdersByRestaurant(int restaurantId) {
        return orderDAO.getOrdersByRestaurant(restaurantId);
    }

    public List<Order> getAllOrders() {
        return orderDAO.getAllOrders();
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        return orderDAO.updateOrderStatus(orderId, newStatus);
    }

    public boolean markCodPaymentPaid(int orderId) {
        return orderDAO.updatePaymentStatus(orderId, "PAID");
    }

    public Map<String, Object> getRestaurantStatistics(int restaurantId) {
        return orderDAO.getRestaurantStatistics(restaurantId);
    }

    public Map<String, Object> getPlatformStatistics() {
        return orderDAO.getPlatformStatistics();
    }

    private String generateOrderCode() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String datePart = sdf.format(new java.util.Date());
        int randomPart = 1000 + new Random().nextInt(9000);
        return "ORD-" + datePart + "-" + randomPart;
    }
}

