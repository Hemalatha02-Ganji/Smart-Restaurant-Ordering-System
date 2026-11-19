CREATE DATABASE IF NOT EXISTS cs8_exam_db;
USE cs8_exam_db;

CREATE TABLE IF NOT EXISTS candidates (
    candidate_id VARCHAR(50) PRIMARY KEY,
    candidate_name VARCHAR(100) NOT NULL,
    roll_number VARCHAR(50) NOT NULL UNIQUE,
    programme VARCHAR(50) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS exam_officers (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS examinations (
    exam_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_code VARCHAR(20) NOT NULL UNIQUE,
    subject_name VARCHAR(100) NOT NULL,
    exam_date DATE NOT NULL,
    session ENUM('FN (09:30 AM - 12:30 PM)', 'AN (02:00 PM - 05:00 PM)') NOT NULL,
    registration_deadline DATE NOT NULL,
    is_closed BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS exam_registrations (
    reg_id INT AUTO_INCREMENT PRIMARY KEY,
    candidate_id VARCHAR(50) NOT NULL,
    exam_id INT NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Registered', 'Hall Ticket Generated') DEFAULT 'Registered',
    UNIQUE KEY uq_cand_exam (candidate_id, exam_id),
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id) ON DELETE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES examinations(exam_id) ON DELETE CASCADE
);

INSERT INTO exam_officers (username, password, full_name) VALUES 
('officer', 'admin123', 'Controller of Examinations')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO examinations (subject_code, subject_name, exam_date, session, registration_deadline, is_closed) VALUES
('20CS501', 'Full Stack Development - II', '2026-12-20', 'FN (09:30 AM - 12:30 PM)', '2026-12-10', FALSE),
('20CS502', 'Compiler Design', '2026-12-22', 'AN (02:00 PM - 05:00 PM)', '2026-12-10', FALSE),
('20CS503', 'Machine Learning', '2026-12-24', 'FN (09:30 AM - 12:30 PM)', '2026-12-10', FALSE);

INSERT INTO candidates (candidate_id, candidate_name, roll_number, programme, semester, email, password) VALUES
('CAND101', 'Hemalatha Ganji', '24761A05S2', 'B.Tech CSE', 'V Semester', 'hema@gmail.com', 'pass123')
ON DUPLICATE KEY UPDATE candidate_name=VALUES(candidate_name);
