# CASE STUDY 2: Clinic Appointment Scheduling System

## 1. Project Overview
A complete clinic scheduling web application allowing patients to book doctor appointments without slot conflicts and receptionists to confirm/cancel schedules.

## 2. Default Login Credentials
- **Receptionist:** Username: `receptionist` | Password: `admin123`
- **Patient:** Patient ID: `PAT101` | Password: `pass123`

## 3. Database Setup
Execute `database.sql` to initialize `cs2_clinic_db` and seed doctors.

## 4. Lab Viva Questions & Answers
**Q1: How is duplicate slot booking prevented for the same doctor?**
*Answer:* A database constraint `UNIQUE KEY (doctor_id, appointment_date, time_slot)` along with a pre-insert check in `ClinicDAO.bookAppointment()` guarantees that two patients cannot book the same doctor at the same time.

**Q2: How does the receptionist filter records?**
*Answer:* In `receptionist_dashboard.jsp`, the date input passes `filterDate` as an HTTP parameter to `ClinicDAO.getAppointmentsByDate()` to render appointments for that specific day.
