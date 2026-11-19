-- =======================================================
-- SMART RESTAURANT ORDERING & BILLING SYSTEM DATABASE
-- Database: smart_restaurant_db
-- Version: MySQL 8.0
-- =======================================================

DROP DATABASE IF EXISTS smart_restaurant_db;
CREATE DATABASE smart_restaurant_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smart_restaurant_db;

-- 1. RESTAURANTS TABLE
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    cuisine VARCHAR(100) NOT NULL,
    description TEXT,
    rating DECIMAL(2,1) DEFAULT 4.5,
    address VARCHAR(255) NOT NULL,
    primary_area VARCHAR(100) NOT NULL,
    opening_hours VARCHAR(100) DEFAULT '10:00 AM - 11:00 PM',
    is_active BOOLEAN DEFAULT TRUE,
    image_url VARCHAR(500),
    contact_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. ADMINS TABLE
CREATE TABLE admins (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role ENUM('SUPER_ADMIN', 'RESTAURANT_ADMIN') NOT NULL,
    restaurant_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_admins_restaurant FOREIGN KEY (restaurant_id) 
        REFERENCES restaurants(restaurant_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 3. SERVICE AREAS TABLE
CREATE TABLE service_areas (
    area_id INT PRIMARY KEY AUTO_INCREMENT,
    area_name VARCHAR(100) NOT NULL UNIQUE,
    pincode VARCHAR(10),
    is_active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- 4. RESTAURANT SERVICE AREAS (MANY-TO-MANY MAPPING)
CREATE TABLE restaurant_service_areas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    area_id INT NOT NULL,
    delivery_charge DECIMAL(10,2) DEFAULT 40.00,
    estimated_time VARCHAR(50) DEFAULT '30-45 mins',
    CONSTRAINT fk_rsa_restaurant FOREIGN KEY (restaurant_id) 
        REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    CONSTRAINT fk_rsa_area FOREIGN KEY (area_id) 
        REFERENCES service_areas(area_id) ON DELETE CASCADE,
    UNIQUE KEY uk_restaurant_area (restaurant_id, area_id)
) ENGINE=InnoDB;

-- 5. CATEGORIES TABLE
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    display_order INT DEFAULT 1,
    icon_class VARCHAR(50) DEFAULT 'bi-egg-fried'
) ENGINE=InnoDB;

-- 6. MENU ITEMS TABLE
CREATE TABLE menu_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    category_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    food_type ENUM('VEG', 'NON_VEG') NOT NULL DEFAULT 'VEG',
    is_available BOOLEAN DEFAULT TRUE,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_menu_restaurant FOREIGN KEY (restaurant_id) 
        REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    CONSTRAINT fk_menu_category FOREIGN KEY (category_id) 
        REFERENCES categories(category_id) ON DELETE CASCADE,
    INDEX idx_restaurant_category (restaurant_id, category_id)
) ENGINE=InnoDB;

-- 7. RESTAURANT TABLES TABLE
CREATE TABLE restaurant_tables (
    table_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    table_number VARCHAR(20) NOT NULL,
    capacity INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_tables_restaurant FOREIGN KEY (restaurant_id) 
        REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    UNIQUE KEY uk_table_per_restaurant (restaurant_id, table_number)
) ENGINE=InnoDB;

-- 8. ORDERS TABLE
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_code VARCHAR(50) NOT NULL UNIQUE,
    restaurant_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_mobile VARCHAR(20) NOT NULL,
    customer_area VARCHAR(100) NOT NULL,
    order_type ENUM('HOME_DELIVERY', 'DINE_IN') NOT NULL,
    order_status ENUM('PLACED', 'ACCEPTED', 'PREPARING', 'READY', 'OUT_FOR_DELIVERY', 'DELIVERED', 'COMPLETED', 'CANCELLED') DEFAULT 'PLACED',
    subtotal DECIMAL(10,2) NOT NULL,
    gst_amount DECIMAL(10,2) NOT NULL,
    delivery_charge DECIMAL(10,2) DEFAULT 0.00,
    grand_total DECIMAL(10,2) NOT NULL,
    special_notes VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_restaurant FOREIGN KEY (restaurant_id) 
        REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    INDEX idx_order_tracking (order_code, customer_mobile)
) ENGINE=InnoDB;

-- 9. ORDER ITEMS TABLE
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    item_name VARCHAR(150) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_oi_order FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_oi_item FOREIGN KEY (item_id) 
        REFERENCES menu_items(item_id)
) ENGINE=InnoDB;

-- 10. ADDRESSES TABLE (FOR HOME DELIVERY)
CREATE TABLE addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL UNIQUE,
    house_no VARCHAR(100) NOT NULL,
    street VARCHAR(150) NOT NULL,
    landmark VARCHAR(150),
    area VARCHAR(100) NOT NULL,
    mobile VARCHAR(20) NOT NULL,
    instructions VARCHAR(255),
    CONSTRAINT fk_address_order FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 11. PAYMENTS TABLE (COD ONLY)
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(30) DEFAULT 'CASH_ON_DELIVERY' NOT NULL,
    payment_status ENUM('PENDING', 'PAID') DEFAULT 'PENDING' NOT NULL,
    paid_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_order FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 12. RESERVATIONS TABLE (TABLE BOOKINGS)
CREATE TABLE reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    table_id INT NOT NULL,
    order_id INT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_mobile VARCHAR(20) NOT NULL,
    reservation_date DATE NOT NULL,
    time_slot VARCHAR(50) NOT NULL,
    guest_count INT NOT NULL,
    special_requests VARCHAR(255),
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_res_restaurant FOREIGN KEY (restaurant_id) 
        REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    CONSTRAINT fk_res_table FOREIGN KEY (table_id) 
        REFERENCES restaurant_tables(table_id) ON DELETE CASCADE,
    CONSTRAINT fk_res_order FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE SET NULL,
    INDEX idx_res_lookup (restaurant_id, reservation_date, time_slot, status)
) ENGINE=InnoDB;

-- 13. INVOICES TABLE
CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_number VARCHAR(50) NOT NULL UNIQUE,
    order_id INT NOT NULL UNIQUE,
    restaurant_name VARCHAR(100) NOT NULL,
    restaurant_address VARCHAR(255) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_mobile VARCHAR(20) NOT NULL,
    order_type VARCHAR(30) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    gst_amount DECIMAL(10,2) NOT NULL,
    delivery_charge DECIMAL(10,2) DEFAULT 0.00,
    grand_total DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(30) DEFAULT 'CASH_ON_DELIVERY',
    payment_status VARCHAR(20) DEFAULT 'PENDING',
    invoice_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_invoice_order FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 14. REVIEWS TABLE
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_restaurant FOREIGN KEY (restaurant_id) 
        REFERENCES restaurants(restaurant_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =======================================================
-- INITIAL SAMPLE DATA SEEDING
-- =======================================================

-- 1. Insert Initial Restaurants
INSERT INTO restaurants (restaurant_id, name, cuisine, description, rating, address, primary_area, opening_hours, is_active, image_url, contact_number) VALUES
(1, 'Spice Garden', 'South Indian', 'Authentic South Indian delicacies, traditional Andhra thalis, crispy dosas, and aromatic Chettinad specialties prepared with heritage recipes.', 4.8, 'Main Road, Near Bus Stand, Mylavaram', 'Mylavaram', '07:00 AM - 10:30 PM', 1, 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?auto=format&fit=crop&w=800&q=80', '+91 98765 43210'),
(2, 'Royal Biryani House', 'Biryani', 'Famous for authentic dum biryanis, royal Mughlai gravies, tender kebabs, and rich Zafrani desserts slow-cooked over charcoal embers.', 4.9, 'MG Road, Governorpet, Vijayawada', 'Vijayawada', '11:00 AM - 11:30 PM', 1, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=800&q=80', '+91 98480 12345'),
(3, 'Food Junction', 'Fast Food', 'Popular youth hangout serving sizzling gourmet burgers, loaded artisan pizzas, crispy appetizers, and chilled handcrafted shakes.', 4.6, 'Airport Road, Near Highway Junction, Gannavaram', 'Gannavaram', '11:00 AM - 11:00 PM', 1, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=800&q=80', '+91 94401 56789'),
(4, 'Green Leaf Restaurant', 'Vegetarian', 'Pure vegetarian paradise offering wholesome satvik North & South Indian meals, rich paneer curries, tandoori rotis, and fresh garden salads.', 4.7, 'College Road, Opp. LBRCE, Mylavaram', 'Mylavaram', '07:30 AM - 10:00 PM', 1, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80', '+91 99890 98765');

-- 2. Insert Admins
-- Password for all is: admin123 (BCrypt hashed with salt)
INSERT INTO admins (admin_id, username, password, full_name, email, role, restaurant_id) VALUES
(1, 'superadmin', '$2a$10$hPJgOiLrvVCquzjBx37e1OQdx4vJIaR/wwKhidOcKoTlZnA9eeXhW', 'Platform Super Admin', 'superadmin@smartrestaurant.com', 'SUPER_ADMIN', NULL),
(2, 'admin_spice', '$2a$10$hPJgOiLrvVCquzjBx37e1OQdx4vJIaR/wwKhidOcKoTlZnA9eeXhW', 'Spice Garden Manager', 'spice@smartrestaurant.com', 'RESTAURANT_ADMIN', 1),
(3, 'admin_royal', '$2a$10$hPJgOiLrvVCquzjBx37e1OQdx4vJIaR/wwKhidOcKoTlZnA9eeXhW', 'Royal Biryani Manager', 'royal@smartrestaurant.com', 'RESTAURANT_ADMIN', 2),
(4, 'admin_food', '$2a$10$hPJgOiLrvVCquzjBx37e1OQdx4vJIaR/wwKhidOcKoTlZnA9eeXhW', 'Food Junction Manager', 'food@smartrestaurant.com', 'RESTAURANT_ADMIN', 3),
(5, 'admin_green', '$2a$10$hPJgOiLrvVCquzjBx37e1OQdx4vJIaR/wwKhidOcKoTlZnA9eeXhW', 'Green Leaf Manager', 'green@smartrestaurant.com', 'RESTAURANT_ADMIN', 4);

-- 3. Insert Service Areas
INSERT INTO service_areas (area_id, area_name, pincode, is_active) VALUES
(1, 'Mylavaram', '521230', 1),
(2, 'Vijayawada', '520001', 1),
(3, 'Gannavaram', '521101', 1),
(4, 'Ibrahimpatnam', '521456', 1);

-- 4. Insert Restaurant Service Areas (Which restaurant serves which area)
INSERT INTO restaurant_service_areas (restaurant_id, area_id, delivery_charge, estimated_time) VALUES
(1, 1, 30.00, '25-35 mins'), -- Spice Garden serves Mylavaram
(1, 4, 50.00, '40-50 mins'), -- Spice Garden serves Ibrahimpatnam
(2, 2, 40.00, '30-45 mins'), -- Royal Biryani House serves Vijayawada
(3, 3, 35.00, '20-35 mins'), -- Food Junction serves Gannavaram
(4, 1, 30.00, '20-30 mins'), -- Green Leaf serves Mylavaram
(4, 4, 45.00, '35-45 mins'); -- Green Leaf serves Ibrahimpatnam

-- 5. Insert Categories
INSERT INTO categories (category_id, category_name, display_order, icon_class) VALUES
(1, 'Starters', 1, 'bi-fire'),
(2, 'Main Course', 2, 'bi-egg-fried'),
(3, 'Biryani', 3, 'bi-bowl'),
(4, 'Fast Food', 4, 'bi-pie-chart'),
(5, 'Desserts', 5, 'bi-cup-straw'),
(6, 'Beverages', 6, 'bi-cup-hot');

-- 6. Insert Restaurant Tables
-- Restaurant 1: Spice Garden
INSERT INTO restaurant_tables (restaurant_id, table_number, capacity, is_active) VALUES
(1, 'Table 1', 2, 1),
(1, 'Table 2', 4, 1),
(1, 'Table 3', 4, 1),
(1, 'Table 4', 6, 1),
(1, 'Table 5', 8, 1);

-- Restaurant 2: Royal Biryani House
INSERT INTO restaurant_tables (restaurant_id, table_number, capacity, is_active) VALUES
(2, 'Royal Table 1', 2, 1),
(2, 'Royal Table 2', 4, 1),
(2, 'Royal Table 3', 4, 1),
(2, 'Royal Table 4', 6, 1),
(2, 'Royal Table 5', 8, 1);

-- Restaurant 3: Food Junction
INSERT INTO restaurant_tables (restaurant_id, table_number, capacity, is_active) VALUES
(3, 'FJ Table 1', 2, 1),
(3, 'FJ Table 2', 4, 1),
(3, 'FJ Table 3', 4, 1),
(3, 'FJ Table 4', 6, 1),
(3, 'FJ Table 5', 8, 1);

-- Restaurant 4: Green Leaf Restaurant
INSERT INTO restaurant_tables (restaurant_id, table_number, capacity, is_active) VALUES
(4, 'Green Table 1', 2, 1),
(4, 'Green Table 2', 4, 1),
(4, 'Green Table 3', 4, 1),
(4, 'Green Table 4', 6, 1),
(4, 'Green Table 5', 8, 1);

-- 7. Insert Menu Items (At least 8-10 items per restaurant)
-- RESTAURANT 1: Spice Garden (South Indian)
INSERT INTO menu_items (restaurant_id, category_id, name, description, price, food_type, is_available, image_url) VALUES
(1, 1, 'Andhra Chilli Chicken', 'Spicy dry boneless chicken tossed with hot green chillies, curry leaves, and Andhra spice blend.', 260.00, 'NON_VEG', 1, 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?auto=format&fit=crop&w=600&q=80'),
(1, 1, 'Crispy Gobi 65', 'Deep-fried battered cauliflower florets tossed in zesty garlic yogurt and curry leaf temper.', 180.00, 'VEG', 1, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80'),
(1, 2, 'Guntur Chicken Curry', 'Tender country chicken simmered in a fiery gravy crafted with roasted Guntur red chillies.', 290.00, 'NON_VEG', 1, 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=600&q=80'),
(1, 2, 'Paneer Butter Masala', 'Fresh cottage cheese cubes folded in a rich tomato, butter, and cashew cream gravy.', 240.00, 'VEG', 1, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80'),
(1, 3, 'Rayalaseema Chicken Dum Biryani', 'Fragrant aged basmati rice cooked with succulent marinated chicken and authentic Seema spices.', 310.00, 'NON_VEG', 1, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80'),
(1, 3, 'South Indian Veg Dum Biryani', 'Fresh garden vegetables and basmati layered with brown onions, mint, and pure ghee.', 220.00, 'VEG', 1, 'https://images.unsplash.com/photo-1642821373181-696a54913e9a?auto=format&fit=crop&w=600&q=80'),
(1, 4, 'Crispy Masala Dosa', 'Golden fermented rice-lentil crepe smeared with red chutney and stuffed with spiced potato masala.', 110.00, 'VEG', 1, 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=600&q=80'),
(1, 5, 'Double Ka Meetha', 'Traditional Hyderabadi fried bread pudding soaked in saffron-cardamom milk syrup with fried dry fruits.', 130.00, 'VEG', 1, 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=600&q=80'),
(1, 6, 'Filter Coffee', 'Decoction brewed authentic South Indian degree filter coffee served foaming hot.', 45.00, 'VEG', 1, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80'),
(1, 6, 'Spiced Buttermilk (Majjiga)', 'Fresh churned cooling yogurt drink flavored with ginger, green chillies, curry leaves, and asafoetida.', 50.00, 'VEG', 1, 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?auto=format&fit=crop&w=600&q=80');

-- RESTAURANT 2: Royal Biryani House (Biryani & Mughlai)
INSERT INTO menu_items (restaurant_id, category_id, name, description, price, food_type, is_available, image_url) VALUES
(2, 1, 'Chicken Seekh Kebab', 'Minced spiced chicken skewers char-grilled in a clay tandoor oven, served with mint dip.', 299.00, 'NON_VEG', 1, 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?auto=format&fit=crop&w=600&q=80'),
(2, 1, 'Paneer Tikka Angara', 'Cottage cheese chunks marinated in hung curd, Kashmiri chilli, and mustard oil, grilled over coal.', 240.00, 'VEG', 1, 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?auto=format&fit=crop&w=600&q=80'),
(2, 2, 'Mughlai Mutton Rogan Josh', 'Kashmiri delicacy of tender braised mutton cuts cooked in an aromatic fennel and ratan jot gravy.', 390.00, 'NON_VEG', 1, 'https://images.unsplash.com/photo-1545247181-516773cae754?auto=format&fit=crop&w=600&q=80'),
(2, 2, 'Butter Chicken Delhi Style', 'Tandoori chicken pieces simmered in silky velvety makhani gravy enriched with fresh cream.', 320.00, 'NON_VEG', 1, 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=600&q=80'),
(2, 3, 'Nizami Mutton Dum Biryani', 'The crown jewel: premium long grain rice with succulent spiced mutton, saffron, and fried onions.', 380.00, 'NON_VEG', 1, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80'),
(2, 3, 'Hyderabadi Chicken Dum Biryani', 'World-famous slow-cooked pot biryani layered with chicken, fresh mint, ghee, and roasted cashews.', 299.00, 'NON_VEG', 1, 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?auto=format&fit=crop&w=600&q=80'),
(2, 3, 'Shahi Paneer Dum Biryani', 'Marinated soft paneer cubes layered with aromatic basmati rice, saffron milk, and fried onions.', 260.00, 'VEG', 1, 'https://images.unsplash.com/photo-1642821373181-696a54913e9a?auto=format&fit=crop&w=600&q=80'),
(2, 5, 'Shahi Gulab Jamun with Rabdi', 'Mawa dumplings soaked in rose sugar syrup served atop creamy thickened rabdi.', 140.00, 'VEG', 1, 'https://images.unsplash.com/photo-1541832676-9b763b0239ab?auto=format&fit=crop&w=600&q=80'),
(2, 5, 'Zafrani Firni', 'Slow-cooked ground rice pudding flavored with saffron, cardamom, and silver leaf.', 120.00, 'VEG', 1, 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=600&q=80'),
(2, 6, 'Royal Kesar Badam Milk', 'Rich milk boiled with crushed almonds, saffron strands, and crushed pistachios, served chilled.', 90.00, 'VEG', 1, 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?auto=format&fit=crop&w=600&q=80');

-- RESTAURANT 3: Food Junction (Fast Food)
INSERT INTO menu_items (restaurant_id, category_id, name, description, price, food_type, is_available, image_url) VALUES
(3, 1, 'Loaded Cheese Fries', 'Crispy golden French fries topped with hot cheddar cheese sauce, jalapeños, and seasoning.', 160.00, 'VEG', 1, 'https://images.unsplash.com/photo-1585109649139-366815a0d713?auto=format&fit=crop&w=600&q=80'),
(3, 1, 'Peri Peri Chicken Wings', 'Crispy fried chicken wings tossed in fiery African birds eye peri peri sauce.', 230.00, 'NON_VEG', 1, 'https://images.unsplash.com/photo-1527477396000-e27163b481c2?auto=format&fit=crop&w=600&q=80'),
(3, 4, 'Double Cheese Crunch Burger', 'Crispy spiced vegetable patty topped with double cheese slice, chipotle mayo, and pickled onions.', 180.00, 'VEG', 1, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80'),
(3, 4, 'Crispy Zinger Chicken Burger', 'Crispy fried boneless chicken breast fillet with iceberg lettuce and creamy garlic mayo on sesame bun.', 220.00, 'NON_VEG', 1, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80'),
(3, 4, 'Spicy Barbecue Chicken Pizza', 'Hand-stretched 10-inch thin crust topped with smoky BBQ chicken chunks, capsicum, and mozzarella.', 340.00, 'NON_VEG', 1, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80'),
(3, 4, 'Farmhouse Veggie Delight Pizza', 'Thin crust pizza loaded with bell peppers, sweet corn, mushrooms, olives, and extra mozzarella.', 290.00, 'VEG', 1, 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=600&q=80'),
(3, 4, 'Creamy White Sauce Pasta', 'Penne pasta tossed in a velvety garlic Parmesan cream sauce with herbs and sautéed veggies.', 210.00, 'VEG', 1, 'https://images.unsplash.com/photo-1621996346565-e3d5d6281744?auto=format&fit=crop&w=600&q=80'),
(3, 5, 'Sizzling Chocolate Brownie', 'Warm walnut chocolate fudge brownie topped with a scoop of vanilla bean gelato and warm chocolate ganache.', 160.00, 'VEG', 1, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=600&q=80'),
(3, 6, 'Belgian Chocolate Thickshake', 'Decadent chocolate milkshake made with real Belgian cocoa and dairy ice cream.', 140.00, 'VEG', 1, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=600&q=80'),
(3, 6, 'Virgin Mojito', 'Sparkling cooler with muddled fresh garden mint leaves, tangy lime juice, and crushed ice.', 99.00, 'VEG', 1, 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=600&q=80');

-- RESTAURANT 4: Green Leaf Restaurant (Pure Vegetarian)
INSERT INTO menu_items (restaurant_id, category_id, name, description, price, food_type, is_available, image_url) VALUES
(4, 1, 'Hara Bhara Kebab', 'Pan-seared spinach, green peas, and potato patties scented with spices and topped with cashew.', 190.00, 'VEG', 1, 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=600&q=80'),
(4, 1, 'Crispy Babycorn Manchurian', 'Golden baby corn batons tossed in a tangy ginger, garlic, and scallion Indo-Chinese glaze.', 210.00, 'VEG', 1, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80'),
(4, 2, 'Kaju Paneer Curry', 'Cashew nuts and fresh malai paneer simmered in an indulgent mild onion-cashew gravy.', 280.00, 'VEG', 1, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80'),
(4, 2, 'Dal Makhani Gold', 'Black lentils slow cooked overnight on low charcoal heat finished with unsalted butter and fresh cream.', 220.00, 'VEG', 1, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80'),
(4, 2, 'Palak Paneer', 'Blanched fresh spinach puree cooked with garlic, cumin, and soft cottage cheese chunks.', 240.00, 'VEG', 1, 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=600&q=80'),
(4, 3, 'Royal Vegetable Dum Biryani', 'Farm-fresh carrots, beans, peas, and potatoes layered with fragrant basmati and whole spices.', 230.00, 'VEG', 1, 'https://images.unsplash.com/photo-1642821373181-696a54913e9a?auto=format&fit=crop&w=600&q=80'),
(4, 4, 'Ghee Roast Plain Dosa', 'Super crispy golden South Indian rice crepe cooked in golden A2 cow ghee with fresh chutneys.', 90.00, 'VEG', 1, 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=600&q=80'),
(4, 5, 'Rasmalai with Saffron Milk', 'Spongy cottage cheese patties immersed in chilled clotted saffron cream milk garnished with pistachios.', 130.00, 'VEG', 1, 'https://images.unsplash.com/photo-1541832676-9b763b0239ab?auto=format&fit=crop&w=600&q=80'),
(4, 5, 'Matka Kulfi', 'Traditional slow-reduced frozen milk dessert flavored with cardamom, almonds, and pistachios in a clay pot.', 100.00, 'VEG', 1, 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=600&q=80'),
(4, 6, 'Sweet Mango Lassi', 'Velvety blend of fresh Alphonso mango pulp, thick curd, and green cardamom.', 85.00, 'VEG', 1, 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?auto=format&fit=crop&w=600&q=80');

-- 8. Seed Sample Customer Reviews
INSERT INTO reviews (restaurant_id, customer_name, rating, comment) VALUES
(1, 'Bhavani K.', 5, 'Best South Indian food in Mylavaram! The Andhra Chilli Chicken and Biryani are sensational.'),
(1, 'Ramesh Babu', 5, 'Very authentic taste and quick delivery. Filter coffee is also amazing.'),
(2, 'Suresh V.', 5, 'The Dum Biryani at Royal Biryani House Vijayawada has unbeatable aroma and tender meat.'),
(2, 'Divya P.', 4, 'Great Mughlai cuisine! Loved the kebabs and Shahi Firni.'),
(3, 'Kiran Kumar', 5, 'Amazing burgers and loaded fries in Gannavaram! Perfect place for quick bites.'),
(4, 'Anusha M.', 5, 'Pure vegetarian perfection near LBRCE campus. Palak paneer and Dal Makhani are top-notch.');

-- 9. Seed Sample Orders, Order Items, Address, Payment, Invoice & Reservation
-- Order 1: Delivered Home Delivery order
INSERT INTO orders (order_id, order_code, restaurant_id, customer_name, customer_mobile, customer_area, order_type, order_status, subtotal, gst_amount, delivery_charge, grand_total, special_notes, created_at)
VALUES (1, 'ORD-20261028-1001', 1, 'Bhavani', '9876543210', 'Mylavaram', 'HOME_DELIVERY', 'DELIVERED', 570.00, 28.50, 30.00, 628.50, 'Please do not ring the bell, call on mobile.', '2026-10-28 12:30:00');

INSERT INTO order_items (order_id, item_id, item_name, unit_price, quantity, subtotal) VALUES
(1, 1, 'Andhra Chilli Chicken', 260.00, 1, 260.00),
(1, 5, 'Rayalaseema Chicken Dum Biryani', 310.00, 1, 310.00);

INSERT INTO addresses (order_id, house_no, street, landmark, area, mobile, instructions) VALUES
(1, 'Plot 42, Green Avenue', 'Temple Road', 'Near Rama Temple', 'Mylavaram', '9876543210', 'Leave at door');

INSERT INTO payments (order_id, amount, payment_method, payment_status, paid_at, created_at) VALUES
(1, 628.50, 'CASH_ON_DELIVERY', 'PAID', '2026-10-28 13:15:00', '2026-10-28 12:30:00');

INSERT INTO invoices (invoice_number, order_id, restaurant_name, restaurant_address, customer_name, customer_mobile, order_type, subtotal, gst_amount, delivery_charge, grand_total, payment_method, payment_status, invoice_date) VALUES
('INV-20261028-1001', 1, 'Spice Garden', 'Main Road, Near Bus Stand, Mylavaram', 'Bhavani', '9876543210', 'HOME_DELIVERY', 570.00, 28.50, 30.00, 628.50, 'CASH_ON_DELIVERY', 'PAID', '2026-10-28 12:31:00');

-- Order 2: Active Placed Order for Dine-In
INSERT INTO orders (order_id, order_code, restaurant_id, customer_name, customer_mobile, customer_area, order_type, order_status, subtotal, gst_amount, delivery_charge, grand_total, special_notes, created_at)
VALUES (2, 'ORD-20261030-2002', 2, 'Karthik Rao', '9848123456', 'Vijayawada', 'DINE_IN', 'ACCEPTED', 679.00, 33.95, 0.00, 712.95, 'Table reserved for evening dinner', CURRENT_TIMESTAMP);

INSERT INTO order_items (order_id, item_id, item_name, unit_price, quantity, subtotal) VALUES
(2, 15, 'Nizami Mutton Dum Biryani', 380.00, 1, 380.00),
(2, 11, 'Chicken Seekh Kebab', 299.00, 1, 299.00);

INSERT INTO payments (order_id, amount, payment_method, payment_status, paid_at, created_at) VALUES
(2, 712.95, 'CASH_ON_DELIVERY', 'PENDING', NULL, CURRENT_TIMESTAMP);

INSERT INTO invoices (invoice_number, order_id, restaurant_name, restaurant_address, customer_name, customer_mobile, order_type, subtotal, gst_amount, delivery_charge, grand_total, payment_method, payment_status, invoice_date) VALUES
('INV-20261030-2002', 2, 'Royal Biryani House', 'MG Road, Governorpet, Vijayawada', 'Karthik Rao', '9848123456', 'DINE_IN', 679.00, 33.95, 0.00, 712.95, 'CASH_ON_DELIVERY', 'PENDING', CURRENT_TIMESTAMP);

-- Sample Table Reservation
INSERT INTO reservations (reservation_id, restaurant_id, table_id, order_id, customer_name, customer_mobile, reservation_date, time_slot, guest_count, special_requests, status, created_at) VALUES
(1, 2, 7, 2, 'Karthik Rao', '9848123456', CURDATE(), '07:30 PM - 09:00 PM', 4, 'Window side preferred for family dinner', 'APPROVED', CURRENT_TIMESTAMP);
