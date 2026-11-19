CREATE DATABASE IF NOT EXISTS cs3_hostel_db;
USE cs3_hostel_db;

CREATE TABLE IF NOT EXISTS applicants (
    roll_number VARCHAR(50) PRIMARY KEY,
    application_number VARCHAR(50) NOT NULL UNIQUE,
    student_name VARCHAR(100) NOT NULL,
    year VARCHAR(10) NOT NULL,
    branch VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    preferred_hostel VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS wardens (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    hostel_block VARCHAR(50) NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    capacity INT NOT NULL,
    current_occupancy INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    roll_number VARCHAR(50) NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    allocated_room_id INT DEFAULT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_app_year (roll_number, academic_year),
    FOREIGN KEY (roll_number) REFERENCES applicants(roll_number) ON DELETE CASCADE,
    FOREIGN KEY (allocated_room_id) REFERENCES rooms(room_id) ON DELETE SET NULL
);

INSERT INTO wardens (username, password, full_name) VALUES 
('warden', 'admin123', 'Chief Hostel Warden')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO rooms (hostel_block, room_number, capacity, current_occupancy) VALUES
('Block A (Boys)', 'A-101', 3, 0),
('Block A (Boys)', 'A-102', 3, 0),
('Block B (Girls)', 'B-201', 2, 0),
('Block B (Girls)', 'B-202', 2, 0);

INSERT INTO applicants (roll_number, application_number, student_name, year, branch, phone, preferred_hostel, password) VALUES
('24761A05S2', 'APP-2026-001', 'Hemalatha Ganji', 'III Year', 'CSE', '9848098480', 'Block B (Girls)', 'pass123')
ON DUPLICATE KEY UPDATE student_name=VALUES(student_name);
