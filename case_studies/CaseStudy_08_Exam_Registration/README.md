# CASE STUDY 8: Online Examination Registration Portal

## 1. Project Overview
An online examination registration system allowing students to register for scheduled semester subjects before deadlines and examination officers to manage schedules.

## 2. Default Login Credentials
- **Exam Officer:** Username: `officer` | Password: `admin123`
- **Candidate:** Roll Number: `24761A05S2` | Password: `pass123`

## 3. Database Setup
Execute `database.sql` to initialize `cs8_exam_db`.

## 4. Lab Viva Questions & Answers
**Q1: How is registration restricted to deadline only?**
*Answer:* In `ExamDAO.registerForExam()`, the current date is verified against `registration_deadline`. If `deadline.before(new Date())` or `is_closed == true`, registration is denied.

**Q2: How are duplicate registrations prevented?**
*Answer:* A database constraint `UNIQUE KEY uq_cand_exam (candidate_id, exam_id)` ensures a candidate cannot register for the same subject twice.
