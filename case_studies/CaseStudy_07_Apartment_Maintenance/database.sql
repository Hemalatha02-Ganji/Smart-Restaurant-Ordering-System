CREATE DATABASE IF NOT EXISTS cs7_apartment_db;
USE cs7_apartment_db;

CREATE TABLE IF NOT EXISTS residents (
    resident_id VARCHAR(50) PRIMARY KEY,
    resident_name VARCHAR(100) NOT NULL,
    apartment_number VARCHAR(20) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS managers (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS maintenance_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    resident_id VARCHAR(50) NOT NULL,
    category ENUM('Plumbing', 'Electrical', 'Carpentry', 'General', 'HVAC') NOT NULL,
    description TEXT NOT NULL,
    priority ENUM('Low', 'Medium', 'High') DEFAULT 'Medium',
    status ENUM('Pending', 'In Progress', 'Resolved', 'Rejected') DEFAULT 'Pending',
    manager_remarks TEXT,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (resident_id) REFERENCES residents(resident_id) ON DELETE CASCADE
);

INSERT INTO managers (username, password, full_name) VALUES 
('manager', 'admin123', 'Property Maintenance Supervisor')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO residents (resident_id, resident_name, apartment_number, phone, email, password) VALUES
('RES101', 'Hemalatha Ganji', 'Flat 402, Block B', '9848098480', 'hema@gmail.com', 'pass123')
ON DUPLICATE KEY UPDATE resident_name=VALUES(resident_name);

INSERT INTO maintenance_requests (resident_id, category, description, priority, status) VALUES
('RES101', 'Plumbing', 'Kitchen sink leakage under counter', 'High', 'Pending');
