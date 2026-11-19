-- =====================================================================
-- CLINIC APPOINTMENT SCHEDULING SYSTEM (FSD-II PROJECT)
-- Database Name: clinic_appointment_db
-- Compatibility: MySQL 8.0+
-- Developer: Hemalatha Ganji (Roll No: 24761A05S2)
-- College: Lakireddy Bali Reddy College of Engineering (Autonomous)
-- =====================================================================

DROP DATABASE IF EXISTS clinic_appointment_db;
CREATE DATABASE clinic_appointment_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE clinic_appointment_db;

-- -----------------------------------------------------
-- Table: patients
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS patients (
    patient_id VARCHAR(50) PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    blood_group VARCHAR(10) DEFAULT 'O+',
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table: doctors
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    qualification VARCHAR(100) NOT NULL,
    experience_years INT DEFAULT 5,
    room_number VARCHAR(20) NOT NULL,
    consultation_fee DECIMAL(10,2) DEFAULT 300.00,
    available_days VARCHAR(100) DEFAULT 'Mon - Sat',
    available_hours VARCHAR(100) DEFAULT '09:00 AM - 05:00 PM',
    status ENUM('AVAILABLE', 'ON_LEAVE') DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table: receptionists
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS receptionists (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table: appointments
-- Note: UNIQUE KEY uq_doctor_slot guarantees no two patients
-- can book the same doctor at the same date and time slot!
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_token VARCHAR(30) UNIQUE NOT NULL,
    patient_id VARCHAR(50) NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    time_slot VARCHAR(40) NOT NULL,
    reason TEXT NOT NULL,
    status ENUM('Pending', 'Confirmed', 'Cancelled', 'Completed') DEFAULT 'Pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_apt_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    CONSTRAINT fk_apt_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    CONSTRAINT uq_doctor_slot UNIQUE (doctor_id, appointment_date, time_slot)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table: appointment_audit_log (Enterprise Audit Trail)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS appointment_audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    action VARCHAR(50) NOT NULL,
    performed_by VARCHAR(50) NOT NULL,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    remarks TEXT,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- INITIAL SAMPLE DATA SEEDING
-- =====================================================

-- 1. Insert Doctors
INSERT INTO doctors (doctor_name, specialization, qualification, experience_years, room_number, consultation_fee, available_days, available_hours, status) VALUES
('Dr. Arvind Swamy', 'Cardiology', 'MBBS, MD, DM (Cardio)', 14, 'Room 101', 500.00, 'Mon, Wed, Fri', '09:00 AM - 01:00 PM', 'AVAILABLE'),
('Dr. Sneha Reddy', 'Pediatrics', 'MBBS, MD (Pediatrics)', 9, 'Room 102', 400.00, 'Mon - Sat', '10:00 AM - 03:00 PM', 'AVAILABLE'),
('Dr. Rajesh Varma', 'General Medicine', 'MBBS, MD (Internal Medicine)', 16, 'Room 103', 300.00, 'Mon - Sat', '09:00 AM - 05:00 PM', 'AVAILABLE'),
('Dr. Meenakshi Sundaram', 'Dermatology', 'MBBS, MD (DVL)', 8, 'Room 104', 450.00, 'Tue, Thu, Sat', '02:00 PM - 06:00 PM', 'AVAILABLE'),
('Dr. Vikramaditya Rao', 'Orthopedics', 'MBBS, MS (Ortho), M.Ch', 12, 'Room 105', 500.00, 'Mon, Wed, Fri', '01:00 PM - 05:00 PM', 'AVAILABLE'),
('Dr. Ananya Sharma', 'Gynecology & Obstetrics', 'MBBS, MS (OBG)', 11, 'Room 106', 450.00, 'Mon - Sat', '09:30 AM - 02:30 PM', 'AVAILABLE');

-- 2. Insert Receptionists (Password: admin123)
INSERT INTO receptionists (username, password, full_name, email, phone) VALUES
('receptionist', 'admin123', 'Chief Receptionist Desk', 'reception@citycareclinic.com', '9876543210'),
('hema_reception', 'admin123', 'Hemalatha Ganji (Front Desk)', 'hema.desk@citycareclinic.com', '9848022338');

-- 3. Insert Patients (Password: pass123)
INSERT INTO patients (patient_id, patient_name, dob, gender, phone, email, password, blood_group, address) VALUES
('PAT101', 'Bhavani Krishna', '1998-05-14', 'Female', '9876543211', 'bhavani@example.com', 'pass123', 'B+', 'Main Road, Mylavaram, NTR Dist'),
('PAT102', 'Ramesh Kumar', '1992-11-20', 'Male', '9876543212', 'ramesh@example.com', 'pass123', 'O+', 'Ring Road, Vijayawada'),
('24761A05S2', 'Hemalatha Ganji', '2004-08-15', 'Female', '9440123456', 'hemalatha@lbrce.ac.in', 'pass123', 'A+', 'College Road, Mylavaram');

-- 4. Insert Initial Realistic Appointments
INSERT INTO appointments (appointment_token, patient_id, doctor_id, appointment_date, time_slot, reason, status, notes) VALUES
('APT-2026-1001', 'PAT101', 1, CURDATE(), '09:30 AM - 10:00 AM', 'Routine cardiac health checkup and chest tightness review', 'Confirmed', 'Patient asked to bring previous ECG report'),
('APT-2026-1002', 'PAT102', 3, CURDATE(), '10:30 AM - 11:00 AM', 'Viral fever and mild sore throat for 3 days', 'Pending', 'Waiting for receptionist token assignment'),
('APT-2026-1003', '24761A05S2', 4, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '02:30 PM - 03:00 PM', 'Skin allergy consultation and allergy patch test', 'Pending', 'Initial consultation'),
('APT-2026-1004', 'PAT101', 2, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '11:00 AM - 11:30 AM', 'Pediatric seasonal vaccination and growth assessment', 'Confirmed', 'Confirmed by front desk');

-- Done!
