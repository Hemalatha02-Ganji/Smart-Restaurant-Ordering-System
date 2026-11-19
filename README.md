# SMART RESTAURANT ORDERING & BILLING SYSTEM

Enterprise Multi-Restaurant Food Ordering, Table Reservation, and Automatic Billing Web Platform.

Developed for **Full Stack Development 2 (FSD-2)** College Project.

---

## 1. Mandatory Technology Stack

- **Frontend:** HTML5, CSS3, JavaScript (ES6+), Bootstrap 5.3.3, Bootstrap Icons
- **Backend:** Java 21, Jakarta Servlets 6.0, JSP 3.1, JSTL 3.0, JDBC
- **Server:** Apache Tomcat 10.1
- **Build Tool:** Apache Maven 3.9+
- **Database:** MySQL 8.0
- **IDE:** IntelliJ IDEA / Eclipse
- **Architecture:** MVC (Model-View-Controller) Architecture, DAO Pattern, Service Layer
- **Security:** BCrypt Password Hashing (`org.mindrot:jbcrypt`), SQL Injection prevention using `PreparedStatement`, Session-based Role Authorization.
- **Reporting:** OpenPDF (`com.github.librepdf:openpdf`) for automated digital PDF invoice generation.

---

## 2. Key Features & Business Workflows

### A. Frictionless Customer Access (Zero Login / Registration)
- Customers access the platform immediately without email registration or password accounts.
- Prompts for **Customer Name** and **Customer Area** (e.g., *Bhavani* in *Mylavaram*).
- Stored cleanly in `HttpSession`. Customers can change their area at any time from the top navigation bar.

### B. Area-Based Dynamic Restaurant Discovery
- Serves restaurants filtered by the customer's selected area via case-insensitive MySQL lookups.
- Initial Partner Restaurants:
  1. **Spice Garden** (Area: *Mylavaram*, Cuisine: *South Indian*)
  2. **Royal Biryani House** (Area: *Vijayawada*, Cuisine: *Biryani & Mughlai*)
  3. **Food Junction** (Area: *Gannavaram*, Cuisine: *Fast Food & Shakes*)
  4. **Green Leaf Restaurant** (Area: *Mylavaram*, Cuisine: *Pure Vegetarian*)
- Attractive empty state displayed when no restaurants are in an area.

### C. Independent Food Menus & Categories
- 6 Standard Categories: **Starters, Main Course, Biryani, Fast Food, Desserts, Beverages**.
- 40+ pre-seeded delicious dishes across the four partner kitchens.
- Veg / Non-Veg badges, price, description, images, search bar, category filters, and live stock availability toggle.

### D. Shopping Cart & Server-Side Price Security
- In-session cart with quantity controls and real-time calculation.
- **Multi-Restaurant Order Rule:** Strictly prevents mixing items from different restaurants in the same cart. If attempted, displays a confirmation modal to clear the previous cart or cancel.
- **Server-Side Price Validation:** Every item's availability and unit price is verified against MySQL when creating the order. Submitted browser totals are never trusted.
- Automatic breakdown: `Subtotal + 5% GST + Delivery Charges = Grand Total`.

### E. Order Types & Table Reservation
1. **Home Delivery:** Collects house number, street, landmark, mobile number, and delivery instructions. Adds delivery fee.
2. **Dine-In:** Selects dining table and kitchen instructions. Delivery charge is waived (Rs. 0).
3. **Table Reservation System:**
   - Multi-capacity tables (Table 1 to 5: capacities 2, 4, 4, 6, 8 guests).
   - Real-time availability checked against MySQL database.
   - Database transactions with `SELECT ... FOR UPDATE` concurrency locks to prevent double-bookings.
   - Cancelled / Rejected reservations automatically free the slot.

### F. Strict Cash on Delivery (COD) Only
- No online payment gateways or card forms per specification.
- Payment Method: `CASH_ON_DELIVERY`
- Initial Payment Status: `PENDING`
- Restaurant Admin updates status to `PAID` upon collecting physical cash.

### G. Automatic Billing & Digital Invoice
- Automatic invoice record inserted in `invoices` table.
- Web digital tax invoice view with `window.print()` support.
- One-click **Download PDF Invoice** generated via Java OpenPDF library.

### H. Customer Order Tracking
- Track status using **Order ID** (e.g., `ORD-20261030-XXXX`) and **Mobile Number** validation.
- Visual step-tracker: `PLACED` -> `ACCEPTED` -> `PREPARING` -> `READY` -> `OUT_FOR_DELIVERY` -> `DELIVERED` (or `COMPLETED`).

### I. Restaurant Admin Dashboard
- Assigned to a specific restaurant.
- Real-time statistics: Total orders, pending orders, today's orders, revenue.
- Menu Management: Add/edit/delete food items, toggle in-stock/out-of-stock.
- Order Management: Accept, reject, advance cooking/delivery status, collect COD cash.
- Table & Reservation Management: Manage seating plans, approve or reject reservations.
- View & print invoices.

### J. Super Admin Master Dashboard
- Platform-wide statistics: total restaurants, orders, unique customers, reservations, platform revenue.
- Register, edit, and deactivate partner restaurants.
- Add service areas and configure delivery fees per restaurant.
- Manage and assign restaurant administrator logins.
- Audit all platform orders and table bookings.

---

## 3. Database Setup Instructions (MySQL 8.0)

1. Open MySQL Command Line Client or MySQL Workbench.
2. The complete schema and initial seed data are in `database/smart_restaurant_db.sql`.
3. Execute the SQL script:
```sql
SOURCE c:/Users/user/Desktop/fsdproject/database/smart_restaurant_db.sql;
```
Or run from PowerShell:
```powershell
Get-Content "database\smart_restaurant_db.sql" | & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p
```
4. Verify database creation:
```sql
USE smart_restaurant_db;
SHOW TABLES;
```
All 14 tables will be created:
`admins`, `restaurants`, `service_areas`, `restaurant_service_areas`, `categories`, `menu_items`, `orders`, `order_items`, `addresses`, `payments`, `restaurant_tables`, `reservations`, `invoices`, `reviews`.

---

## 4. Configuration (Configurable DB Credentials)

Database settings are configured in `src/main/resources/db.properties`:
```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/smart_restaurant_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
db.user=root
db.password=Hema@123
```
*Tip:* You can also override credentials via environment variables without changing code:
- `DB_URL`
- `DB_USER`
- `DB_PASSWORD`

---

## 5. Building the Deployable WAR File (Maven)

Open terminal / PowerShell in the project directory:
```powershell
mvn clean package
```
This produces `target/SmartRestaurantSystem.war`.

---

## 6. Apache Tomcat 10.1 Deployment Instructions

1. Copy the generated `SmartRestaurantSystem.war` into Tomcat's `webapps` folder:
```powershell
Copy-Item "target\SmartRestaurantSystem.war" -Destination "C:\Program Files\Apache Software Foundation\Tomcat 10.1_Tomcat10S2\webapps\" -Force
```
2. Apache Tomcat will automatically detect, unpack, and deploy the application.
3. Access the web application:
   - Local Machine: `http://localhost:8085/SmartRestaurantSystem/` (or port `8080` if default connector is used)
   - Storefront Homepage: `http://localhost:8085/SmartRestaurantSystem/home`
   - Staff / Admin Login: `http://localhost:8085/SmartRestaurantSystem/admin/login`

---

## 7. Local Area Network (LAN) & Mobile Access

To access the restaurant ordering portal from an Android mobile phone, iPhone, or tablet on the same Wi-Fi:

1. Identify your computer's local IP address (e.g., `10.27.28.52`).
2. Open Windows Firewall and ensure port `8085` (or `8080`) allows inbound TCP traffic:
```powershell
New-NetFirewallRule -DisplayName "Tomcat Smart Restaurant" -Direction Inbound -LocalPort 8085,8080 -Protocol TCP -Action Allow
```
3. Open any mobile browser on the same Wi-Fi network and navigate to:
```
http://10.27.28.52:8085/SmartRestaurantSystem/
```
The responsive Bootstrap 5 interface automatically adapts for mobile screens!

---

## 8. Demo Accounts & Credentials

| Role | Username | Password | Access Scope |
| :--- | :--- | :--- | :--- |
| **Super Admin** | `superadmin` | `admin123` | Platform-Wide (All Restaurants & Settings) |
| **Spice Garden Admin** | `admin_spice` | `admin123` | Spice Garden (Mylavaram) Operations |
| **Royal Biryani Admin** | `admin_royal` | `admin123` | Royal Biryani House (Vijayawada) Operations |
| **Food Junction Admin** | `admin_food` | `admin123` | Food Junction (Gannavaram) Operations |
| **Green Leaf Admin** | `admin_green` | `admin123` | Green Leaf Restaurant (Mylavaram) Operations |
| **Customer** | *No login needed* | *No password* | Enter Name & Area (e.g. Bhavani, Mylavaram) |

---

## 9. Testing Checklist & Verification Results

- [x] **Customer Access:** Opened homepage without credentials; saved name and area in session.
- [x] **Area Filtering:** Verified Mylavaram displays Spice Garden & Green Leaf; Vijayawada displays Royal Biryani House; Gannavaram displays Food Junction.
- [x] **Menu & Cart:** Added items, adjusted quantities, verified server-side price calculation.
- [x] **Multi-Restaurant Restriction:** Attempting to add an item from a different restaurant triggered the confirmation modal.
- [x] **COD Home Delivery Order:** Placed order; verified unique order code `ORD-YYYYMMDD-XXXX` and address insertion.
- [x] **Dine-In Order:** Placed dine-in order with table number and waived delivery charge.
- [x] **Table Reservation:** Reserved table with concurrency lock; verified double-booking prevention.
- [x] **Digital Invoices & PDF:** Generated digital invoice in MySQL; tested OpenPDF PDF download.
- [x] **Order Tracking:** Tracked order using Order Code and Mobile Number validation.
- [x] **Admin Dashboard:** Tested login with BCrypt authentication, added menu items, updated order status, marked COD payment as PAID.
- [x] **Super Admin Dashboard:** Managed restaurants, service area mappings, and administrator assignments.
- [x] **LAN Access:** Verified successful access via local IP `http://10.27.28.52:8085/SmartRestaurantSystem/`.

