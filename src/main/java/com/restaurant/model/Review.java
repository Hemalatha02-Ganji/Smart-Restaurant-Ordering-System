package com.restaurant.model;

import java.sql.Timestamp;

public class Review {
    private int reviewId;
    private int restaurantId;
    private String customerName;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    public Review() {}

    public Review(int restaurantId, String customerName, int rating, String comment) {
        this.restaurantId = restaurantId;
        this.customerName = customerName;
        this.rating = rating;
        this.comment = comment;
    }

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

