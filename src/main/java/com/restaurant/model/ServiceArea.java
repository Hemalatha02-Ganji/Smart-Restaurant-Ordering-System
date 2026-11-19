package com.restaurant.model;

import java.math.BigDecimal;

public class ServiceArea {
    private int areaId;
    private String areaName;
    private String pincode;
    private boolean isActive;
    private BigDecimal deliveryCharge;
    private String estimatedTime;

    public ServiceArea() {}

    public ServiceArea(int areaId, String areaName, String pincode, boolean isActive) {
        this.areaId = areaId;
        this.areaName = areaName;
        this.pincode = pincode;
        this.isActive = isActive;
    }

    public int getAreaId() { return areaId; }
    public void setAreaId(int areaId) { this.areaId = areaId; }

    public String getAreaName() { return areaName; }
    public void setAreaName(String areaName) { this.areaName = areaName; }

    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public BigDecimal getDeliveryCharge() { return deliveryCharge; }
    public void setDeliveryCharge(BigDecimal deliveryCharge) { this.deliveryCharge = deliveryCharge; }

    public String getEstimatedTime() { return estimatedTime; }
    public void setEstimatedTime(String estimatedTime) { this.estimatedTime = estimatedTime; }
}

