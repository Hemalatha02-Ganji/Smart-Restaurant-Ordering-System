# CASE STUDY 10: Lost and Found Campus Portal

## 1. Project Overview
A campus community portal allowing students to report lost or found belongings, search matching listings, and mark resolved, with moderator moderation.

## 2. Default Login Credentials
- **Moderator:** Username: `moderator` | Password: `admin123`
- **Student:** Student ID: `24761A05S2` | Password: `pass123`

## 3. Database Setup
Execute `database.sql` to initialize `cs10_lostfound_db`.

## 4. Lab Viva Questions & Answers
**Q1: How are resolved or hidden reports filtered from search results?**
*Answer:* In `LostFoundDAO.searchOpenReports()`, the SQL query explicitly includes `WHERE r.status = 'Open'` so that resolved or moderator-hidden listings do not appear.
