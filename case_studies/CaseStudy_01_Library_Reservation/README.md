# CASE STUDY 1: Library Resource Reservation Portal

## 1. Project Overview
A web-based portal developed using JSP, Servlets, JDBC, and MySQL for reserving library books and journals.

## 2. Default Login Credentials
- **Librarian:** Username: `librarian` | Password: `admin123`
- **Member:** Member ID: `MEM101` | Password: `pass123`

## 3. Database Setup
1. Open MySQL Workbench / Command Line.
2. Execute the `database.sql` script to create `cs1_library_db` and sample seed data.

## 4. How to Run
- In Eclipse/IntelliJ: Import as Maven Project -> Run on Apache Tomcat 10.1.
- Open URL: `http://localhost:8080/LibraryResourceReservation/` (or your context path).

## 5. Lab Viva Questions & Answers
**Q1: How does the system prevent reservation of unavailable resources?**
*Answer:* In `LibraryDAO.java`, a validation query checks `status = 'AVAILABLE'` before inserting a reservation. If the status is 'RESERVED', the transaction is blocked.

**Q2: How is session security handled?**
*Answer:* The `AuthFilter.java` checks whether `session.getAttribute("role")` exists and redirects unauthorized users back to `index.jsp`.
