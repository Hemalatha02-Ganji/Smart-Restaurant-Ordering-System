# CASE STUDY 12: Internship Application Tracker

## 1. Project Overview
A campus recruitment and internship tracking portal allowing students to discover and apply for company openings before deadlines and placement coordinators to manage recruitment pipelines.

## 2. Default Login Credentials
- **Coordinator:** Username: `coordinator` | Password: `admin123`
- **Student:** Roll Number: `24761A05S2` | Password: `pass123`

## 3. Database Setup
Execute `database.sql` to initialize `cs12_internship_db`.

## 4. Lab Viva Questions & Answers
**Q1: How are duplicate applications prevented?**
*Answer:* A database constraint `UNIQUE KEY uq_intern_roll (internship_id, roll_number)` guarantees that a candidate cannot apply for the same internship opening more than once.

**Q2: How does the system restrict expired applications?**
*Answer:* In `InternshipDAO.applyForInternship()`, `last_date.before(new java.util.Date())` is verified before inserting into `applications`.
