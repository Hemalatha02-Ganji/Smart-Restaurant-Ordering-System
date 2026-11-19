# CASE STUDY 7: Apartment Maintenance Request System

## 1. Project Overview
A maintenance complaint logging and tracking portal for apartment residents and facility managers.

## 2. Default Login Credentials
- **Manager:** Username: `manager` | Password: `admin123`
- **Resident:** Resident ID: `RES101` | Password: `pass123`

## 3. Database Setup
Execute `database.sql` to initialize `cs7_apartment_db`.

## 4. Lab Viva Questions & Answers
**Q1: How do residents track their requests?**
*Answer:* Requests are linked to the resident's ID through a foreign key. The query filters by `resident_id` so residents only see their own tickets and manager remarks.

**Q2: How does manager filtering work?**
*Answer:* The SQL query in `MaintenanceDAO.getAllRequests()` dynamically appends `AND category = ?`, `AND priority = ?`, and `AND status = ?` based on the filter parameters provided.
