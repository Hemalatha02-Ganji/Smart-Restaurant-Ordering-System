# CASE STUDY 4: Online Course Enrollment System

## 1. Project Overview
A full-stack web portal for browsing course catalogues, enrolling in courses with live seat decrements, and managing enrollments.

## 2. Default Login Credentials
- **Coordinator:** Username: `coordinator` | Password: `admin123`
- **Learner:** Learner ID: `LRN101` | Password: `pass123`

## 3. Database Setup
Execute `database.sql` to initialize `cs4_course_db` and seed courses.

## 4. Lab Viva Questions & Answers
**Q1: How does the system update available seat counts?**
*Answer:* In `CourseDAO.enrollCourse()`, a transaction with row locking (`SELECT available_seats FROM courses WHERE course_id = ? FOR UPDATE`) checks if `available_seats > 0`. If true, it inserts the enrollment and executes `UPDATE courses SET available_seats = available_seats - 1 WHERE course_id = ?`.

**Q2: How is duplicate enrollment prevented?**
*Answer:* A database composite unique key `UNIQUE KEY uq_learner_course (learner_id, course_id)` prevents the same learner from enrolling in the same course multiple times.
