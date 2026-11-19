CREATE DATABASE IF NOT EXISTS cs6_event_db;
USE cs6_event_db;

CREATE TABLE IF NOT EXISTS participants (
    participant_id VARCHAR(50) PRIMARY KEY,
    participant_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    institution VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS organizers (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    venue VARCHAR(100) NOT NULL,
    event_date DATE NOT NULL,
    deadline DATE NOT NULL,
    capacity INT NOT NULL,
    registered_count INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS event_registrations (
    reg_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    participant_id VARCHAR(50) NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    attendance_status ENUM('Pending', 'Present', 'Absent') DEFAULT 'Pending',
    UNIQUE KEY uq_event_part (event_id, participant_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (participant_id) REFERENCES participants(participant_id) ON DELETE CASCADE
);

INSERT INTO organizers (username, password, full_name) VALUES 
('organizer', 'admin123', 'Faculty Event Convener')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name);

INSERT INTO events (title, category, venue, event_date, deadline, capacity, registered_count) VALUES
('National Level Hackathon 2026', 'Technical', 'Main Auditorium', '2026-12-15', '2026-12-10', 100, 0),
('AI & Deep Learning Hands-on Workshop', 'Workshop', 'Lab 3 & 4', '2026-12-05', '2026-12-01', 50, 0),
('Inter-College Debate Championship', 'Cultural', 'Seminar Hall B', '2026-11-28', '2026-11-25', 40, 0);

INSERT INTO participants (participant_id, participant_name, email, phone, institution, password) VALUES
('PART101', 'Hemalatha Ganji', 'hema@gmail.com', '9848098480', 'LBRCE Autonomous', 'pass123')
ON DUPLICATE KEY UPDATE participant_name=VALUES(participant_name);
