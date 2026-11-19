package com.restaurant.model;

public class RestaurantTable {
    private int tableId;
    private int restaurantId;
    private String tableNumber;
    private int capacity;
    private boolean isActive;

    // Helper fields
    private boolean isReserved;
    private String restaurantName;

    public RestaurantTable() {}

    public RestaurantTable(int tableId, int restaurantId, String tableNumber, int capacity, boolean isActive) {
        this.tableId = tableId;
        this.restaurantId = restaurantId;
        this.tableNumber = tableNumber;
        this.capacity = capacity;
        this.isActive = isActive;
    }

    public int getTableId() { return tableId; }
    public void setTableId(int tableId) { this.tableId = tableId; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public String getTableNumber() { return tableNumber; }
    public void setTableNumber(String tableNumber) { this.tableNumber = tableNumber; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public boolean isReserved() { return isReserved; }
    public void setReserved(boolean reserved) { isReserved = reserved; }

    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }
}

