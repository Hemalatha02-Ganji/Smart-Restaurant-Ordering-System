# CASE STUDY 5: Vehicle Service Booking System

## 1. Project Overview
A web-based vehicle maintenance portal allowing customers to register vehicles and book service slots, while service advisors monitor queues and update statuses.

## 2. Default Login Credentials
- **Advisor:** Username: `advisor` | Password: `admin123`
- **Customer:** Customer ID: `CUST101` | Password: `pass123`

## 3. Database Setup
Execute `database.sql` to initialize `cs5_vehicle_db`.

## 4. Lab Viva Questions & Answers
**Q1: How are duplicate slot bookings prevented?**
*Answer:* A database constraint `UNIQUE KEY uq_slot (vehicle_id, preferred_date, time_slot)` and a pre-booking check in `VehicleDAO` prevents booking the same vehicle on the same date and slot.

**Q2: How are vehicles associated with customers?**
*Answer:* Each vehicle has a `customer_id` foreign key referencing the logged-in customer's primary key.
