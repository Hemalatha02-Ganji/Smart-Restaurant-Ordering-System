# CLINIC APPOINTMENT SCHEDULING SYSTEM (CASE STUDY 2)

**Full Stack Development - II (FSD-II) / Skill Oriented Course Web Application**  
**Student Name:** Hemalatha Ganji  
**Regd. No:** 24761A05S2  
**Department:** Computer Science and Engineering  
**College:** Lakireddy Bali Reddy College of Engineering (Autonomous), Mylavaram  

---

## 1. Project Overview & Capabilities

The **Clinic Appointment Scheduling System** is an enterprise-grade medical outpatient consultation and scheduling portal built using **Java 21**, **Jakarta Servlets 6.0**, **Jakarta Server Pages (JSP 3.1)**, **JDBC**, and **MySQL 8.0**, running on **Apache Tomcat 10.1**.

### Core Actors & Roles:
1. **Patient:**
   - Account Registration with full demographics (`patient_id`, `name`, `dob`, `gender`, `phone`, `email`, `password`, `blood_group`, `address`).
   - Authentication via either Patient ID or Email + Password.
   - Doctor directory discovery with specializations, qualifications, consulting hours, and OPD fees.
   - Real-time slot booking with live date selection and time slot pills.
   - **Concurrency & Double-Booking Protection:** Prevents reserving the same doctor for the same date and time slot.
   - Status tracking (`Pending` $\rightarrow$ `Confirmed` $\rightarrow$ `Completed` / `Cancelled`).
   - Digital Medical Token / Appointment Slip generation with print support.
   - Patient-initiated cancellation for pending bookings.
2. **Receptionist (Front Desk):**
   - Staff login and access control protection.
   - Real-time KPI metrics (Total Bookings, Today's Consultations, Pending Verifications, Confirmed Schedules, Cancelled).
   - Date, Doctor, and Status filtering of all clinical schedules.
   - Instant confirmation or cancellation of patient appointments with database audit logging.
   - Consultation completion check-in.

---

## 2. Technology Stack

- **Backend:** Java 21 LTS, Jakarta Servlets 6.0, JDBC
- **Frontend / Templating:** JSP 3.1, JSTL 3.0, HTML5, CSS3, JavaScript (ES6+), Bootstrap 5.3.3, Bootstrap Icons 1.11.3
- **Database:** MySQL 8.0+ (InnoDB Engine with composite UNIQUE constraints & Foreign Keys)
- **Application Server:** Apache Tomcat 10.1.x
- **Build Tool:** Apache Maven
- **IDE Support:** IntelliJ IDEA Ultimate / Community, Eclipse IDE for Enterprise Java

---

## 3. Database Setup Instructions

1. Start your local **MySQL Server** on port `3306`.
2. Open **MySQL Workbench** or command-line client:
   ```bash
   mysql -u root -p
   ```
3. Execute the provided script located at `database/clinic_appointment_db.sql`:
   ```sql
   source /path/to/ClinicAppointmentSystem/database/clinic_appointment_db.sql;
   ```
   *Or copy and paste the contents into MySQL Workbench and run.*
4. The script initializes the `clinic_appointment_db` database, creates all relational tables, sets up constraints, and seeds specialists, receptionists, and initial appointments.

---

## 4. Default Login Credentials

| Role | Username / Identifier | Password | Access Details |
| :--- | :--- | :--- | :--- |
| **Receptionist Desk** | `receptionist` | `admin123` | Chief Front Desk Console |
| **Receptionist Desk** | `hema_reception` | `admin123` | Front Desk Assistant |
| **Patient Account** | `PAT101` / `bhavani@example.com` | `pass123` | Bhavani Krishna |
| **Patient Account** | `PAT102` / `ramesh@example.com` | `pass123` | Ramesh Kumar |
| **Student Patient** | `24761A05S2` / `hemalatha@lbrce.ac.in` | `pass123` | Hemalatha Ganji |

---

## 5. Step-by-Step Execution Guide in IntelliJ IDEA

1. **Open Project:**
   - Launch **IntelliJ IDEA**.
   - Select `File -> Open...` and choose the `ClinicAppointmentSystem` folder.
   - Open as a **Maven Project**. IntelliJ will automatically resolve Jakarta dependencies.

2. **Configure Tomcat 10.1:**
   - Click `Run -> Edit Configurations...`.
   - Click `+ (Add New Configuration)` and select `Tomcat Server -> Local`.
   - In the **Server** tab:
     - Set Tomcat Home to your Apache Tomcat 10.1 directory.
     - HTTP Port: `8080` (or `8085`).
   - In the **Deployment** tab:
     - Click `+ -> Artifact -> ClinicAppointmentSystem:war exploded`.
     - Set Application context to `/ClinicAppointmentSystem` (or `/`).
   - Click **Apply** and **OK**.

3. **Verify Database Configuration:**
   - Check `src/main/resources/db.properties`.
   - Ensure `db.username` and `db.password` match your local MySQL server (default `root` / `Hema@123`).

4. **Run Application:**
   - Click the green **Run / Debug** button.
   - Tomcat will deploy the application and launch your browser at:
     `http://localhost:8080/ClinicAppointmentSystem/`

---

## 6. Lab Examination Viva Questions & Answers

**Q1: How does the system prevent two patients from booking the same doctor at the same time?**  
*Answer:* The system implements a two-tier concurrency defense:
1. **Application / DAO Tier:** In `AppointmentDAO.bookAppointment()`, an atomic database transaction runs a pessimistic verification (`SELECT COUNT(*) ... FOR UPDATE`) checking for existing non-cancelled bookings for that doctor, date, and slot. If found, the transaction is rolled back.
2. **Database Tier:** The `appointments` table enforces a composite unique key: `CONSTRAINT uq_doctor_slot UNIQUE (doctor_id, appointment_date, time_slot)`, guaranteeing mathematical impossibility of duplicate slot entries.

**Q2: How does the Front Desk filter appointments by date?**  
*Answer:* The receptionist dashboard submits an HTTP GET request containing `filterDate`. `ReceptionistDashboardServlet` forwards this to `AppointmentDAO.getAppointmentsByFilter(date, doctorId, status)`, which dynamically constructs a parameterized SQL query binding the selected date to display only matching schedules.

**Q3: How are unauthorized users prevented from accessing patient or receptionist pages?**  
*Answer:* Two Jakarta servlet filters (`PatientAuthFilter` and `ReceptionistAuthFilter`) intercept protected URL patterns (`/patientHome`, `/receptionistDashboard`, etc.). If the active `HttpSession` is null or lacks the required role attribute, the user is redirected to the corresponding login page with an unauthorized notification banner.
