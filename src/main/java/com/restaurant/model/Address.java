package com.restaurant.model;

public class Address {
    private int addressId;
    private int orderId;
    private String houseNo;
    private String street;
    private String landmark;
    private String area;
    private String mobile;
    private String instructions;

    public Address() {}

    public Address(String houseNo, String street, String landmark, String area, String mobile, String instructions) {
        this.houseNo = houseNo;
        this.street = street;
        this.landmark = landmark;
        this.area = area;
        this.mobile = mobile;
        this.instructions = instructions;
    }

    public int getAddressId() { return addressId; }
    public void setAddressId(int addressId) { this.addressId = addressId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getHouseNo() { return houseNo; }
    public void setHouseNo(String houseNo) { this.houseNo = houseNo; }

    public String getStreet() { return street; }
    public void setStreet(String street) { this.street = street; }

    public String getLandmark() { return landmark; }
    public void setLandmark(String landmark) { this.landmark = landmark; }

    public String getArea() { return area; }
    public void setArea(String area) { this.area = area; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }

    public String getFormattedAddress() {
        StringBuilder sb = new StringBuilder();
        if (houseNo != null && !houseNo.isEmpty()) sb.append(houseNo).append(", ");
        if (street != null && !street.isEmpty()) sb.append(street).append(", ");
        if (landmark != null && !landmark.isEmpty()) sb.append("Near ").append(landmark).append(", ");
        if (area != null && !area.isEmpty()) sb.append(area);
        return sb.toString();
    }
}

