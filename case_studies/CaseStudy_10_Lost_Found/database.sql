CREATE DATABASE IF NOT EXISTS cs10_lostfound_db;
USE cs10_lostfound_db;

CREATE TABLE IF NOT EXISTS students (
    student_id VARCHAR(50) PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS moderators (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS item_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(50) NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    category ENUM('Electronics', 'Books/ID', 'Accessories', 'Documents', 'Others') NOT NULL,
    location VARCHAR(100) NOT NULL,
    item_date DATE NOT NULL,
    report_type ENUM('Lost', 'Found') NOT NULL,
    status ENUM('Open', 'Resolved', 'Hidden') DEFAULT 'Open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

INSERT INTO moderators (username, password, full_name) VALUES 
('moderator', 'admin123', 'Campus Security Moderator')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO students (student_id, student_name, email, phone, password) VALUES
('24761A05S2', 'Hemalatha Ganji', 'hema@gmail.com', '9848098480', 'pass123')
ON DUPLICATE KEY UPDATE student_name=VALUES(student_name);

INSERT INTO item_reports (student_id, item_name, description, category, location, item_date, report_type, status) VALUES
('24761A05S2', 'Scientific Calculator Casio fx-991EX', 'Black color with roll no sticker in back', 'Electronics', 'Central Library 1st Floor', '2026-11-10', 'Lost', 'Open'),
('24761A05S2', 'College ID Card', 'CSE Department 3rd Year ID card found on bench', 'Books/ID', 'Main Canteen', '2026-11-11', 'Found', 'Open');
