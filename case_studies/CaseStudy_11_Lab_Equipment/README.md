# CASE STUDY 11: Laboratory Equipment Issue Register

## 1. Project Overview
A laboratory inventory management register enabling lab assistants to issue equipment against available quantities and record returns with condition audits.

## 2. Default Login Credentials
- **Lab Assistant:** Staff ID: `lab_asst` | Password: `admin123`
- **Supervisor:** Staff ID: `supervisor` | Password: `admin123`

## 3. Database Setup
Execute `database.sql` to initialize `cs11_lab_db`.

## 4. Lab Viva Questions & Answers
**Q1: How is equipment quantity updated on issue and return?**
*Answer:* In `LabDAO.issueEquipment()`, an atomic transaction verifies `available_qty > 0`, issues the item, and decrements `available_qty`. On return in `LabDAO.recordReturn()`, if `condition == 'Good'`, `available_qty` is incremented.

**Q2: How are overdue items identified?**
*Answer:* Overdue reports query `WHERE status = 'Issued' AND due_date < CURRENT_DATE()`.
