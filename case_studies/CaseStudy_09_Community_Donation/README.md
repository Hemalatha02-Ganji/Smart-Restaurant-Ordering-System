# CASE STUDY 9: Community Donation Tracking Portal

## 1. Project Overview
A transparent community fundraising and donation portal allowing donors to log contribution references and coordinators to verify entries and aggregate funds.

## 2. Default Login Credentials
- **Coordinator:** Username: `coordinator` | Password: `admin123`
- **Donor:** Donor ID: `DONOR101` | Password: `pass123`

## 3. Database Setup
Execute `database.sql` to initialize `cs9_donation_db`.

## 4. Lab Viva Questions & Answers
**Q1: How are campaign totals updated reliably?**
*Answer:* In `DonationDAO.updateDonationStatus()`, an atomic database transaction updates the donation status to `Verified` and executes `UPDATE campaigns SET verified_total = verified_total + ? WHERE campaign_id = ?` to guarantee unverified donations never inflate campaign totals.
