package com.restaurant.service;

import com.restaurant.dao.AdminDAO;
import com.restaurant.model.Admin;

import java.util.List;

public class AdminService {

    private final AdminDAO adminDAO = new AdminDAO();

    public Admin authenticate(String username, String plainPassword) {
        if (username == null || plainPassword == null) {
            return null;
        }
        return adminDAO.authenticate(username.trim(), plainPassword);
    }

    public Admin getById(int adminId) {
        return adminDAO.getById(adminId);
    }

    public List<Admin> getAllAdmins() {
        return adminDAO.getAll();
    }

    public boolean createAdmin(Admin admin) {
        return adminDAO.create(admin);
    }

    public boolean updateAdmin(Admin admin) {
        return adminDAO.update(admin);
    }

    public boolean deleteAdmin(int adminId) {
        return adminDAO.delete(adminId);
    }
}

