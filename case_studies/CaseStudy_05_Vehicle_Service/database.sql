CREATE DATABASE IF NOT EXISTS cs5_vehicle_db;
USE cs5_vehicle_db;

CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS service_advisors (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    reg_number VARCHAR(50) NOT NULL UNIQUE,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    mfg_year INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS service_bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    vehicle_id INT NOT NULL,
    service_type VARCHAR(100) NOT NULL,
    preferred_date DATE NOT NULL,
    time_slot VARCHAR(30) NOT NULL,
    status ENUM('Pending', 'Accepted', 'In Service', 'Completed', 'Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_slot (vehicle_id, preferred_date, time_slot),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE
);

INSERT INTO service_advisors (username, password, full_name) VALUES 
('advisor', 'admin123', 'Senior Service Advisor')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO customers (customer_id, customer_name, email, phone, password) VALUES
('CUST101', 'Hemalatha Ganji', 'hema@gmail.com', '9848098480', 'pass123')
ON DUPLICATE KEY UPDATE customer_name=VALUES(customer_name);

INSERT INTO vehicles (customer_id, reg_number, make, model, mfg_year) VALUES
('CUST101', 'AP16-AB-1234', 'Hyundai', 'i20 Asta', 2022);
