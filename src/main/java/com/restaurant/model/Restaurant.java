package com.restaurant.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Restaurant {
    private int restaurantId;
    private String name;
    private String cuisine;
    private String description;
    private BigDecimal rating;
    private String address;
    private String primaryArea;
    private String openingHours;
    private boolean isActive;
    private String imageUrl;
    private String contactNumber;
    private Timestamp createdAt;

    // Additional helper fields
    private List<ServiceArea> serviceAreas = new ArrayList<>();
    private BigDecimal deliveryCharge = BigDecimal.valueOf(40.00);
    private String estimatedTime = "30-45 mins";

    public Restaurant() {}

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCuisine() { return cuisine; }
    public void setCuisine(String cuisine) { this.cuisine = cuisine; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getRating() { return rating; }
    public void setRating(BigDecimal rating) { this.rating = rating; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPrimaryArea() { return primaryArea; }
    public void setPrimaryArea(String primaryArea) { this.primaryArea = primaryArea; }

    public String getOpeningHours() { return openingHours; }
    public void setOpeningHours(String openingHours) { this.openingHours = openingHours; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public List<ServiceArea> getServiceAreas() { return serviceAreas; }
    public void setServiceAreas(List<ServiceArea> serviceAreas) { this.serviceAreas = serviceAreas; }

    public BigDecimal getDeliveryCharge() { return deliveryCharge; }
    public void setDeliveryCharge(BigDecimal deliveryCharge) { this.deliveryCharge = deliveryCharge; }

    public String getEstimatedTime() { return estimatedTime; }
    public void setEstimatedTime(String estimatedTime) { this.estimatedTime = estimatedTime; }
}

