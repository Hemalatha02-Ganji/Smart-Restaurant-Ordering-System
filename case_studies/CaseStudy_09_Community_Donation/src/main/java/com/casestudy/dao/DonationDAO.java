package com.casestudy.dao;

import com.casestudy.util.DBUtil;
import java.sql.*;
import java.util.*;

public class DonationDAO {

    public boolean registerDonor(String id, String name, String email, String phone, String pass) throws SQLException {
        String sql = "INSERT INTO donors (donor_id, donor_name, email, phone, password) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, pass);
            return ps.executeUpdate() > 0;
        }
    }

    public Map<String, String> loginDonor(String idOrEmail, String pass) throws SQLException {
        String sql = "SELECT * FROM donors WHERE (donor_id = ? OR email = ?) AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, idOrEmail);
            ps.setString(2, idOrEmail);
            ps.setString(3, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("donorId", rs.getString("donor_id"));
                    map.put("donorName", rs.getString("donor_name"));
                    return map;
                }
            }
        }
        return null;
    }

    public boolean loginCoordinator(String user, String pass) throws SQLException {
        String sql = "SELECT * FROM coordinators WHERE username = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Map<String, Object>> getActiveCampaigns() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM campaigns";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("campaignId", rs.getInt("campaign_id"));
                map.put("title", rs.getString("title"));
                map.put("purpose", rs.getString("purpose"));
                map.put("targetAmount", rs.getDouble("target_amount"));
                map.put("verifiedTotal", rs.getDouble("verified_total"));
                list.add(map);
            }
        }
        return list;
    }

    public boolean recordDonation(String donorId, int campaignId, double amount, String refNo) throws SQLException {
        String sql = "INSERT INTO donations (donor_id, campaign_id, amount, reference_number, status) VALUES (?, ?, ?, ?, 'Pending Verification')";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, donorId);
            ps.setInt(2, campaignId);
            ps.setDouble(3, amount);
            ps.setString(4, refNo);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Map<String, Object>> getDonorHistory(String donorId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT d.*, c.title FROM donations d JOIN campaigns c ON d.campaign_id = c.campaign_id WHERE d.donor_id = ? ORDER BY d.donated_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, donorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("donationId", rs.getInt("donation_id"));
                    map.put("campaign", rs.getString("title"));
                    map.put("amount", rs.getDouble("amount"));
                    map.put("refNo", rs.getString("reference_number"));
                    map.put("status", rs.getString("status"));
                    map.put("date", rs.getTimestamp("donated_at"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public List<Map<String, Object>> getAllDonations(Integer campaignId, String status) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT d.*, c.title, dn.donor_name, dn.phone FROM donations d " +
                     "JOIN campaigns c ON d.campaign_id = c.campaign_id " +
                     "JOIN donors dn ON d.donor_id = dn.donor_id WHERE 1=1 ";
        if (campaignId != null && campaignId > 0) sql += " AND d.campaign_id = ? ";
        if (status != null && !status.trim().isEmpty()) sql += " AND d.status = ? ";
        sql += " ORDER BY d.donated_at DESC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int idx = 1;
            if (campaignId != null && campaignId > 0) ps.setInt(idx++, campaignId);
            if (status != null && !status.trim().isEmpty()) ps.setString(idx++, status.trim());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("donationId", rs.getInt("donation_id"));
                    map.put("donor", rs.getString("donor_name") + " (" + rs.getString("phone") + ")");
                    map.put("campaign", rs.getString("title"));
                    map.put("campaignId", rs.getInt("campaign_id"));
                    map.put("amount", rs.getDouble("amount"));
                    map.put("refNo", rs.getString("reference_number"));
                    map.put("status", rs.getString("status"));
                    map.put("date", rs.getTimestamp("donated_at"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public boolean updateDonationStatus(int donationId, String status) throws SQLException {
        String getDonationSql = "SELECT campaign_id, amount, status FROM donations WHERE donation_id = ? FOR UPDATE";
        String updateDonationSql = "UPDATE donations SET status = ? WHERE donation_id = ?";
        String updateCampaignSql = "UPDATE campaigns SET verified_total = verified_total + ? WHERE campaign_id = ?";

        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);
            try {
                int campId = 0;
                double amt = 0.0;
                String oldStatus = "";
                try (PreparedStatement ps = con.prepareStatement(getDonationSql)) {
                    ps.setInt(1, donationId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            campId = rs.getInt("campaign_id");
                            amt = rs.getDouble("amount");
                            oldStatus = rs.getString("status");
                        }
                    }
                }

                try (PreparedStatement ps = con.prepareStatement(updateDonationSql)) {
                    ps.setString(1, status);
                    ps.setInt(2, donationId);
                    ps.executeUpdate();
                }

                if ("Verified".equalsIgnoreCase(status) && !"Verified".equalsIgnoreCase(oldStatus)) {
                    try (PreparedStatement ps = con.prepareStatement(updateCampaignSql)) {
                        ps.setDouble(1, amt);
                        ps.setInt(2, campId);
                        ps.executeUpdate();
                    }
                }

                con.commit();
                return true;
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }
}
