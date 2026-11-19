# CASE STUDY 3: Hostel Room Allocation Portal

## 1. Project Overview
An automated hostel room allocation web portal allowing students to submit housing applications and wardens to assign available rooms within physical room capacity limits.

## 2. Default Login Credentials
- **Warden:** Username: `warden` | Password: `admin123`
- **Applicant:** Roll Number: `24761A05S2` | Password: `pass123`

## 3. Database Setup
Execute `database.sql` to initialize `cs3_hostel_db` and seed rooms.

## 4. Lab Viva Questions & Answers
**Q1: How are duplicate applications prevented for the same academic year?**
*Answer:* A composite unique constraint `UNIQUE KEY (roll_number, academic_year)` at the database level and a check in `HostelDAO` ensures a student cannot apply more than once per year.

**Q2: How is room capacity checked during allocation?**
*Answer:* During `allocateRoom()`, a transaction with row locking (`SELECT capacity, current_occupancy FROM rooms WHERE room_id = ? FOR UPDATE`) verifies that `current_occupancy < capacity`. If valid, it increments occupancy by 1 and approves the application.
