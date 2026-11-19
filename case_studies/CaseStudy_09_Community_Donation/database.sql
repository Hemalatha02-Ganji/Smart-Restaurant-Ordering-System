CREATE DATABASE IF NOT EXISTS cs9_donation_db;
USE cs9_donation_db;

CREATE TABLE IF NOT EXISTS donors (
    donor_id VARCHAR(50) PRIMARY KEY,
    donor_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS coordinators (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS campaigns (
    campaign_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    purpose TEXT NOT NULL,
    target_amount DECIMAL(12,2) NOT NULL,
    verified_total DECIMAL(12,2) DEFAULT 0.00
);

CREATE TABLE IF NOT EXISTS donations (
    donation_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id VARCHAR(50) NOT NULL,
    campaign_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    reference_number VARCHAR(100) NOT NULL UNIQUE,
    status ENUM('Pending Verification', 'Verified', 'Rejected') DEFAULT 'Pending Verification',
    donated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id) ON DELETE CASCADE,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id) ON DELETE CASCADE
);

INSERT INTO coordinators (username, password, full_name) VALUES 
('coordinator', 'admin123', 'NGO Community Coordinator')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO campaigns (title, purpose, target_amount, verified_total) VALUES
('Rural School Digital Library Fund', 'Providing tablets and books to government school students', 150000.00, 0.00),
('Flood Relief Community Support', 'Distributing emergency food rations and medical supplies', 200000.00, 0.00),
('Clean Drinking Water Project', 'Installing solar RO water filtration units in villages', 100000.00, 0.00);

INSERT INTO donors (donor_id, donor_name, email, phone, password) VALUES
('DONOR101', 'Hemalatha Ganji', 'hema@gmail.com', '9848098480', 'pass123')
ON DUPLICATE KEY UPDATE donor_name=VALUES(donor_name);
