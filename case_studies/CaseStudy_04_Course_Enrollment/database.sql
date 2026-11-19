CREATE DATABASE IF NOT EXISTS cs4_course_db;
USE cs4_course_db;

CREATE TABLE IF NOT EXISTS learners (
    learner_id VARCHAR(50) PRIMARY KEY,
    learner_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    qualification VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS coordinators (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    fee DECIMAL(10,2) NOT NULL,
    total_seats INT NOT NULL,
    available_seats INT NOT NULL
);

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    learner_id VARCHAR(50) NOT NULL,
    course_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('CONFIRMED', 'CANCELLED') DEFAULT 'CONFIRMED',
    UNIQUE KEY uq_learner_course (learner_id, course_id),
    FOREIGN KEY (learner_id) REFERENCES learners(learner_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

INSERT INTO coordinators (username, password, full_name) VALUES 
('coordinator', 'admin123', 'Academic Course Coordinator')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO courses (title, duration, fee, total_seats, available_seats) VALUES
('Full Stack Web Development with Java', '12 Weeks', 2500.00, 40, 40),
('Data Science & Machine Learning with Python', '10 Weeks', 3000.00, 35, 35),
('Cloud Computing & DevOps on AWS', '8 Weeks', 2800.00, 30, 30),
('Cybersecurity & Ethical Hacking', '6 Weeks', 2200.00, 25, 25);

INSERT INTO learners (learner_id, learner_name, email, phone, qualification, password) VALUES
('LRN101', 'Hemalatha Ganji', 'hema@gmail.com', '9848098480', 'B.Tech CSE', 'pass123')
ON DUPLICATE KEY UPDATE learner_name=VALUES(learner_name);
