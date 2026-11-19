CREATE DATABASE IF NOT EXISTS cs11_lab_db;
USE cs11_lab_db;

CREATE TABLE IF NOT EXISTS staff (
    staff_id VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('Lab Assistant', 'Supervisor') NOT NULL
);

CREATE TABLE IF NOT EXISTS equipment (
    equipment_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    total_qty INT NOT NULL,
    available_qty INT NOT NULL
);

CREATE TABLE IF NOT EXISTS issues (
    issue_id INT AUTO_INCREMENT PRIMARY KEY,
    student_roll VARCHAR(50) NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    equipment_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE DEFAULT NULL,
    condition_on_return ENUM('Good', 'Damaged') DEFAULT NULL,
    status ENUM('Issued', 'Returned', 'Overdue') DEFAULT 'Issued',
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE CASCADE
);

INSERT INTO staff (staff_id, password, full_name, role) VALUES 
('lab_asst', 'admin123', 'Mr. K. Srinivas', 'Lab Assistant'),
('supervisor', 'admin123', 'Dr. V. Prasad (Lab Incharge)', 'Supervisor')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO equipment (name, category, total_qty, available_qty) VALUES
('Digital Storage Oscilloscope 100MHz', 'Electronics', 15, 15),
('Function Generator 20MHz', 'Electronics', 20, 20),
('Raspberry Pi 4 Model B Kits', 'Embedded Systems', 25, 25),
('Digital Multimeter Fluke 101', 'Instruments', 30, 30);
