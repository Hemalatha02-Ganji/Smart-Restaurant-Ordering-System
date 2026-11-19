# CASE STUDY 6: Event Registration and Attendance Portal

## 1. Project Overview
A campus event management and real-time attendance tracking system allowing participants to register before deadlines and organizers to mark Present/Absent statuses.

## 2. Default Login Credentials
- **Organizer:** Username: `organizer` | Password: `admin123`
- **Participant:** Participant ID: `PART101` | Password: `pass123`

## 3. Database Setup
Execute `database.sql` to initialize `cs6_event_db`.

## 4. Lab Viva Questions & Answers
**Q1: How does the system validate registration deadlines and capacities?**
*Answer:* In `EventDAO.registerForEvent()`, a database transaction with `FOR UPDATE` locking compares `deadline.before(new Date(now))` and checks `registered_count < capacity`. If valid, it increments count and creates the ticket.

**Q2: How are attendance analytics computed?**
*Answer:* The method `getAttendanceStats()` runs `GROUP BY attendance_status` on `event_registrations` to calculate total registered, present, and absent counts.
