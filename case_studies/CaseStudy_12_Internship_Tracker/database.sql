CREATE DATABASE IF NOT EXISTS cs12_internship_db;
USE cs12_internship_db;

CREATE TABLE IF NOT EXISTS students (
    roll_number VARCHAR(50) PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    branch VARCHAR(50) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS coordinators (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS internships (
    internship_id INT AUTO_INCREMENT PRIMARY KEY,
    organisation VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL,
    eligibility VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    stipend VARCHAR(50) NOT NULL,
    last_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS applications (
    app_id INT AUTO_INCREMENT PRIMARY KEY,
    internship_id INT NOT NULL,
    roll_number VARCHAR(50) NOT NULL,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Applied', 'Shortlisted', 'Rejected', 'Selected') DEFAULT 'Applied',
    coordinator_remarks TEXT,
    UNIQUE KEY uq_intern_roll (internship_id, roll_number),
    FOREIGN KEY (internship_id) REFERENCES internships(internship_id) ON DELETE CASCADE,
    FOREIGN KEY (roll_number) REFERENCES students(roll_number) ON DELETE CASCADE
);

INSERT INTO coordinators (username, password, full_name) VALUES 
('coordinator', 'admin123', 'Head - Training & Placement Cell')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO internships (organisation, role, eligibility, location, stipend, last_date) VALUES
('Infosys Springboard', 'Java Full Stack Developer Intern', 'B.Tech CSE/IT, CGPA > 7.0', 'Hyderabad', 'Rs. 25,000 / month', '2026-12-15'),
('TCS Research & Innovation', 'AI / ML Research Intern', 'B.Tech All Branches', 'Bangalore', 'Rs. 30,000 / month', '2026-12-20'),
('Cognizant Technology', 'Cloud Solutions Trainee', 'B.Tech CSE/ECE', 'Chennai', 'Rs. 20,000 / month', '2026-11-30');

INSERT INTO students (roll_number, student_name, branch, semester, email, phone, password) VALUES
('24761A05S2', 'Hemalatha Ganji', 'CSE', 'V Semester', 'hema@gmail.com', '9848098480', 'pass123')
ON DUPLICATE KEY UPDATE student_name=VALUES(student_name);
