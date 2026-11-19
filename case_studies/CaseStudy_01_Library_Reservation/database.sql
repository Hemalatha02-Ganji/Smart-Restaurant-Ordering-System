CREATE DATABASE IF NOT EXISTS cs1_library_db;
USE cs1_library_db;

CREATE TABLE IF NOT EXISTS members (
    member_id VARCHAR(50) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    department VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS librarians (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS resources (
    resource_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    status ENUM('AVAILABLE', 'RESERVED') DEFAULT 'AVAILABLE'
);

CREATE TABLE IF NOT EXISTS reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id VARCHAR(50) NOT NULL,
    resource_id INT NOT NULL,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (resource_id) REFERENCES resources(resource_id) ON DELETE CASCADE
);

INSERT INTO librarians (username, password, full_name) VALUES 
('librarian', 'admin123', 'Chief Librarian')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO resources (title, author, category, status) VALUES
('Introduction to Java Programming', 'Daniel Liang', 'Computer Science', 'AVAILABLE'),
('Database System Concepts', 'Silberschatz', 'Computer Science', 'AVAILABLE'),
('Operating System Concepts', 'Galvin', 'Computer Science', 'AVAILABLE'),
('Engineering Mathematics', 'B.S. Grewal', 'Mathematics', 'AVAILABLE'),
('Digital Logic and Computer Design', 'M. Morris Mano', 'Electronics', 'AVAILABLE'),
('Clean Code', 'Robert C. Martin', 'Software Engineering', 'AVAILABLE');

INSERT INTO members (member_id, full_name, email, phone, department, password) VALUES
('MEM101', 'Tarun Mainampudi', 'tarun@college.edu', '9876543210', 'CSE', 'pass123')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);
