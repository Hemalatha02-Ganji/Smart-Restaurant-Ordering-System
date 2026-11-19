package com.restaurant.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
    private int paymentId;
    private int orderId;
    private BigDecimal amount;
    private String paymentMethod = "CASH_ON_DELIVERY"; // COD ONLY
    private String paymentStatus = "PENDING"; // 'PENDING' or 'PAID'
    private Timestamp paidAt;
    private Timestamp createdAt;

    public Payment() {}

    public Payment(BigDecimal amount) {
        this.amount = amount;
        this.paymentMethod = "CASH_ON_DELIVERY";
        this.paymentStatus = "PENDING";
    }

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Timestamp getPaidAt() { return paidAt; }
    public void setPaidAt(Timestamp paidAt) { this.paidAt = paidAt; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isPaid() {
        return "PAID".equalsIgnoreCase(paymentStatus);
    }
}

