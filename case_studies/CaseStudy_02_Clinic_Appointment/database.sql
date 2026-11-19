CREATE DATABASE IF NOT EXISTS cs2_clinic_db;
USE cs2_clinic_db;

CREATE TABLE IF NOT EXISTS patients (
    patient_id VARCHAR(50) PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS receptionists (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(50) NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    time_slot VARCHAR(30) NOT NULL,
    reason TEXT NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_doc_slot (doctor_id, appointment_date, time_slot),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE
);

INSERT INTO receptionists (username, password, full_name) VALUES 
('receptionist', 'admin123', 'Clinic Reception Desk')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO doctors (doctor_name, specialization) VALUES
('Dr. Ramesh Sharma', 'Cardiology'),
('Dr. Sunita Patel', 'Pediatrics'),
('Dr. K. V. Rao', 'Orthopedics'),
('Dr. Ananya Reddy', 'Dermatology');

INSERT INTO patients (patient_id, patient_name, dob, gender, phone, email, password) VALUES
('PAT101', 'Bhavani Kumar', '2004-05-12', 'Male', '9848012345', 'bhavani@gmail.com', 'pass123')
ON DUPLICATE KEY UPDATE patient_name=VALUES(patient_name);
