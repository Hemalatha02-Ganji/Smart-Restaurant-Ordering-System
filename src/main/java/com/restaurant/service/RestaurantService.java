package com.restaurant.service;

import com.restaurant.dao.RestaurantDAO;
import com.restaurant.dao.ServiceAreaDAO;
import com.restaurant.model.Restaurant;
import com.restaurant.model.ServiceArea;

import java.math.BigDecimal;
import java.util.List;

public class RestaurantService {

    private final RestaurantDAO restaurantDAO = new RestaurantDAO();
    private final ServiceAreaDAO serviceAreaDAO = new ServiceAreaDAO();

    public List<Restaurant> getRestaurantsByArea(String areaName) {
        if (areaName == null || areaName.trim().isEmpty()) {
            return restaurantDAO.getAll(true);
        }
        return restaurantDAO.getRestaurantsByArea(areaName.trim());
    }

    public List<Restaurant> getAllRestaurants(boolean onlyActive) {
        return restaurantDAO.getAll(onlyActive);
    }

    public Restaurant getRestaurantById(int restaurantId) {
        return restaurantDAO.getById(restaurantId);
    }

    public boolean createRestaurant(Restaurant r) {
        return restaurantDAO.create(r);
    }

    public boolean updateRestaurant(Restaurant r) {
        return restaurantDAO.update(r);
    }

    public boolean toggleRestaurantStatus(int restaurantId, boolean isActive) {
        return restaurantDAO.toggleActive(restaurantId, isActive);
    }

    public boolean deleteRestaurant(int restaurantId) {
        return restaurantDAO.delete(restaurantId);
    }

    public List<ServiceArea> getAllAreas(boolean onlyActive) {
        return serviceAreaDAO.getAllAreas(onlyActive);
    }

    public ServiceArea getAreaByName(String name) {
        return serviceAreaDAO.getByName(name);
    }

    public boolean createArea(ServiceArea area) {
        return serviceAreaDAO.create(area);
    }

    public boolean assignAreaToRestaurant(int restaurantId, int areaId, BigDecimal fee, String time) {
        return serviceAreaDAO.assignAreaToRestaurant(restaurantId, areaId, fee, time);
    }

    public boolean removeAreaFromRestaurant(int restaurantId, int areaId) {
        return serviceAreaDAO.removeAreaFromRestaurant(restaurantId, areaId);
    }
}

