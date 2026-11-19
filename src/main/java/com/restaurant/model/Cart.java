package com.restaurant.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {
    private Integer restaurantId;
    private String restaurantName;
    private Map<Integer, CartItem> items = new LinkedHashMap<>();
    private String orderType = "HOME_DELIVERY"; // or 'DINE_IN'
    private BigDecimal deliveryCharge = BigDecimal.valueOf(40.00);
    private static final BigDecimal GST_RATE = BigDecimal.valueOf(0.05); // 5% GST

    public Cart() {}

    public Integer getRestaurantId() { return restaurantId; }
    public void setRestaurantId(Integer restaurantId) { this.restaurantId = restaurantId; }

    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public Map<Integer, CartItem> getItemMap() {
        return items;
    }

    public String getOrderType() { return orderType; }
    public void setOrderType(String orderType) {
        this.orderType = orderType;
        if ("DINE_IN".equalsIgnoreCase(orderType)) {
            this.deliveryCharge = BigDecimal.ZERO;
        } else {
            this.deliveryCharge = BigDecimal.valueOf(40.00);
        }
    }

    public BigDecimal getDeliveryCharge() {
        if ("DINE_IN".equalsIgnoreCase(orderType)) {
            return BigDecimal.ZERO;
        }
        return deliveryCharge != null ? deliveryCharge : BigDecimal.ZERO;
    }

    public void setDeliveryCharge(BigDecimal deliveryCharge) {
        this.deliveryCharge = deliveryCharge;
    }

    public boolean canAddItemFromRestaurant(int newRestaurantId) {
        if (items.isEmpty() || restaurantId == null) {
            return true;
        }
        return this.restaurantId == newRestaurantId;
    }

    public void addItem(MenuItem item, int qty, String restName) {
        if (items.isEmpty()) {
            this.restaurantId = item.getRestaurantId();
            this.restaurantName = restName;
        } else if (this.restaurantId != item.getRestaurantId()) {
            throw new IllegalStateException("Cart contains items from " + this.restaurantName + ". Please clear cart before adding items from another restaurant.");
        }

        if (items.containsKey(item.getItemId())) {
            CartItem existing = items.get(item.getItemId());
            existing.setQuantity(existing.getQuantity() + qty);
        } else {
            items.put(item.getItemId(), new CartItem(item, qty));
        }
    }

    public void updateQuantity(int itemId, int qty) {
        if (items.containsKey(itemId)) {
            if (qty <= 0) {
                items.remove(itemId);
                if (items.isEmpty()) {
                    clear();
                }
            } else {
                items.get(itemId).setQuantity(qty);
            }
        }
    }

    public void removeItem(int itemId) {
        items.remove(itemId);
        if (items.isEmpty()) {
            clear();
        }
    }

    public void clear() {
        items.clear();
        restaurantId = null;
        restaurantName = null;
    }

    public int getTotalCount() {
        int count = 0;
        for (CartItem ci : items.values()) {
            count += ci.getQuantity();
        }
        return count;
    }

    public BigDecimal getSubtotal() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem ci : items.values()) {
            total = total.add(ci.getSubtotal());
        }
        return total.setScale(2, RoundingMode.HALF_UP);
    }

    public BigDecimal getGstAmount() {
        return getSubtotal().multiply(GST_RATE).setScale(2, RoundingMode.HALF_UP);
    }

    public BigDecimal getGrandTotal() {
        return getSubtotal().add(getGstAmount()).add(getDeliveryCharge()).setScale(2, RoundingMode.HALF_UP);
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }
}

