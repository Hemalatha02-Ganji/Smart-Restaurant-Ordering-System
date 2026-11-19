package com.restaurant.service;

import com.restaurant.dao.ReservationDAO;
import com.restaurant.dao.TableDAO;
import com.restaurant.model.Reservation;
import com.restaurant.model.RestaurantTable;

import java.sql.Date;
import java.util.List;

public class ReservationService {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final TableDAO tableDAO = new TableDAO();

    public List<RestaurantTable> getAvailableTables(int restaurantId, Date date, String timeSlot, int guestCount) {
        return tableDAO.getAvailableTables(restaurantId, date, timeSlot, guestCount);
    }

    public List<RestaurantTable> getTablesByRestaurant(int restaurantId) {
        return tableDAO.getTablesByRestaurant(restaurantId);
    }

    public boolean createTable(RestaurantTable table) {
        return tableDAO.create(table);
    }

    public boolean updateTable(RestaurantTable table) {
        return tableDAO.update(table);
    }

    public boolean deleteTable(int tableId, int restaurantId) {
        return tableDAO.delete(tableId, restaurantId);
    }

    public boolean bookTable(Reservation res) {
        if (res.getGuestCount() <= 0) {
            throw new IllegalArgumentException("Guest count must be at least 1");
        }
        if (res.getCustomerName() == null || res.getCustomerName().trim().isEmpty()) {
            throw new IllegalArgumentException("Customer name is required");
        }
        if (res.getCustomerMobile() == null || res.getCustomerMobile().trim().isEmpty()) {
            throw new IllegalArgumentException("Customer mobile number is required");
        }
        return reservationDAO.createReservation(res);
    }

    public List<Reservation> getReservationsByRestaurant(int restaurantId) {
        return reservationDAO.getByRestaurant(restaurantId);
    }

    public List<Reservation> getAllReservations() {
        return reservationDAO.getAll();
    }

    public Reservation getReservationById(int reservationId) {
        return reservationDAO.getById(reservationId);
    }

    public boolean updateReservationStatus(int reservationId, String status) {
        return reservationDAO.updateStatus(reservationId, status);
    }
}

