# FSD-II LAB: MODEL CASE STUDIES (ALL 12 PROJECTS)

This directory contains complete, independent, working full-stack Java web applications for all **12 Model Case Studies** from the Lab Internal & External Examination question paper.

---

## 📦 Zip Files Directory Map

Location: `c:\Users\user\Desktop\fsdproject\case_studies\`

| S.No | Case Study Title | Individual ZIP File | Database Name | Default Credentials |
| :---: | :--- | :--- | :--- | :--- |
| **01** | **Library Resource Reservation Portal** | `CaseStudy_01_Library_Reservation.zip` | `cs1_library_db` | Librarian: `librarian` / `admin123`<br>Member: `MEM101` / `pass123` |
| **02** | **Clinic Appointment Scheduling System** | `CaseStudy_02_Clinic_Appointment.zip` | `cs2_clinic_db` | Receptionist: `receptionist` / `admin123`<br>Patient: `PAT101` / `pass123` |
| **03** | **Hostel Room Allocation Portal** | `CaseStudy_03_Hostel_Allocation.zip` | `cs3_hostel_db` | Warden: `warden` / `admin123`<br>Applicant: `24761A05S2` / `pass123` |
| **04** | **Online Course Enrollment System** | `CaseStudy_04_Course_Enrollment.zip` | `cs4_course_db` | Coordinator: `coordinator` / `admin123`<br>Learner: `LRN101` / `pass123` |
| **05** | **Vehicle Service Booking System** | `CaseStudy_05_Vehicle_Service.zip` | `cs5_vehicle_db` | Advisor: `advisor` / `admin123`<br>Customer: `CUST101` / `pass123` |
| **06** | **Event Registration and Attendance Portal** | `CaseStudy_06_Event_Registration.zip` | `cs6_event_db` | Organizer: `organizer` / `admin123`<br>Participant: `PART101` / `pass123` |
| **07** | **Apartment Maintenance Request System** | `CaseStudy_07_Apartment_Maintenance.zip`| `cs7_apartment_db` | Manager: `manager` / `admin123`<br>Resident: `RES101` / `pass123` |
| **08** | **Online Examination Registration Portal** | `CaseStudy_08_Exam_Registration.zip` | `cs8_exam_db` | Officer: `officer` / `admin123`<br>Candidate: `24761A05S2` / `pass123` |
| **09** | **Community Donation Tracking Portal** | `CaseStudy_09_Community_Donation.zip` | `cs9_donation_db` | Coordinator: `coordinator` / `admin123`<br>Donor: `DONOR101` / `pass123` |
| **10** | **Lost and Found Campus Portal** | `CaseStudy_10_Lost_Found.zip` | `cs10_lostfound_db` | Moderator: `moderator` / `admin123`<br>Student: `24761A05S2` / `pass123` |
| **11** | **Laboratory Equipment Issue Register** | `CaseStudy_11_Lab_Equipment.zip` | `cs11_lab_db` | Assistant: `lab_asst` / `admin123`<br>Supervisor: `supervisor` / `admin123` |
| **12** | **Internship Application Tracker** | `CaseStudy_12_Internship_Tracker.zip` | `cs12_internship_db` | Coordinator: `coordinator` / `admin123`<br>Student: `24761A05S2` / `pass123` |
| **ALL**| **Complete Master Archive Bundle** | `ALL_12_CASE_STUDIES.zip` | *All 12 DBs* | *All above credentials* |

---

## 🚀 How to Run Any Case Study in Eclipse / IntelliJ

1. **Extract the ZIP file** of your assigned case study.
2. **Import Database:**
   - Open MySQL Workbench / Command Line.
   - Run the included `database.sql` script (creates database and seed records).
3. **Import Project:**
   - In **IntelliJ**: `File -> Open -> Select extracted folder -> Open as Maven Project`.
   - In **Eclipse**: `File -> Import -> Existing Maven Projects -> Select folder`.
4. **Deploy to Apache Tomcat 10.1:**
   - Add the artifact or run on server.
   - Open browser at `http://localhost:8080/<ProjectName>/` or `http://localhost:8085/<ProjectName>/`.
5. **Login and Test:**
   - Use the pre-seeded credentials from the table above to test both User and Admin workflows!

---

## 🎓 Lab Viva Questions & Answers Summary

1. **How is SQL Injection prevented?**
   - *Answer:* All database interactions strictly use parameterized `java.sql.PreparedStatement` queries. Input variables are bound using `setString()`, `setInt()`, etc., preventing user input from altering query structure.
2. **How does session access control work?**
   - *Answer:* Jakarta `AuthFilter` intercepts protected URLs. If `session.getAttribute("role")` is missing or mismatched, it redirects to the login page. On logout, `session.invalidate()` destroys the active session cookie.
3. **How are duplicate submissions prevented?**
   - *Answer:* Composite unique constraints (`UNIQUE KEY`) at the database level and pre-insert query validations in the DAO layer prevent duplicate entries (e.g. duplicate slot bookings, duplicate exam registrations, or duplicate hostel applications).
4. **How are real-time capacity and inventory limits enforced?**
   - *Answer:* Database transactions with row-level locking (`SELECT ... FOR UPDATE`) check remaining capacity/quantity before inserting. If available, quantity is decremented atomically; if out of stock, the transaction rolls back.
