package com.restaurant.model;

import java.math.BigDecimal;

public class CartItem {
    private MenuItem menuItem;
    private int quantity;
    private BigDecimal subtotal;

    public CartItem() {}

    public CartItem(MenuItem menuItem, int quantity) {
        this.menuItem = menuItem;
        this.quantity = quantity;
        calculateSubtotal();
    }

    public MenuItem getMenuItem() { return menuItem; }
    public void setMenuItem(MenuItem menuItem) {
        this.menuItem = menuItem;
        calculateSubtotal();
    }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
        calculateSubtotal();
    }

    public BigDecimal getSubtotal() { return subtotal; }

    public void calculateSubtotal() {
        if (menuItem != null && menuItem.getPrice() != null) {
            this.subtotal = menuItem.getPrice().multiply(BigDecimal.valueOf(quantity));
        } else {
            this.subtotal = BigDecimal.ZERO;
        }
    }
}

