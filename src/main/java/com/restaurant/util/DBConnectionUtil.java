package com.restaurant.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Thread-safe Database Connection Utility for MySQL 8.0.
 * Supports configurable connection properties from db.properties
 * with fallback to Environment Variables (DB_URL, DB_USER, DB_PASSWORD).
 */
public class DBConnectionUtil {

    private static String url;
    private static String user;
    private static String password;
    private static String driver;

    static {
        try {
            Properties props = new Properties();
            InputStream is = DBConnectionUtil.class.getClassLoader().getResourceAsStream("db.properties");
            if (is != null) {
                props.load(is);
                is.close();
            }

            // Driver class
            driver = props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
            Class.forName(driver);

            // Read properties with environment variable fallbacks
            url = System.getenv("DB_URL");
            if (url == null || url.trim().isEmpty()) {
                url = props.getProperty("db.url", "jdbc:mysql://localhost:3306/smart_restaurant_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8");
            }

            user = System.getenv("DB_USER");
            if (user == null || user.trim().isEmpty()) {
                user = props.getProperty("db.user", "root");
            }

            password = System.getenv("DB_PASSWORD");
            if (password == null) {
                password = props.getProperty("db.password", "Hema@123");
            }

            System.out.println("[DBConnectionUtil] Initialized MySQL Connection with URL: " + url + " as user: " + user);
        } catch (Exception e) {
            System.err.println("[DBConnectionUtil] Initialization error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Obtains a new database connection.
     * @return Connection
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Safely closes AutoCloseable resources (Connection, Statement, ResultSet).
     */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable res : resources) {
            if (res != null) {
                try {
                    res.close();
                } catch (Exception ignored) {
                }
            }
        }
    }
}

