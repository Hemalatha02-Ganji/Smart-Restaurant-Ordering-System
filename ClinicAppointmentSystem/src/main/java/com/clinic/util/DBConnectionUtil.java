package com.clinic.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

/**
 * Enterprise Database Connection Utility for Clinic Appointment Scheduling System.
 * Implements connection management with robust fallback.
 * 
 * Developer: Hemalatha Ganji (Roll No: 24761A05S2)
 */
public class DBConnectionUtil {
    private static String url;
    private static String username;
    private static String password;
    private static String driver;

    static {
        try {
            Properties props = new Properties();
            InputStream is = DBConnectionUtil.class.getClassLoader().getResourceAsStream("db.properties");
            if (is != null) {
                props.load(is);
                driver = props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                url = props.getProperty("db.url", "jdbc:mysql://localhost:3306/clinic_appointment_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
                username = props.getProperty("db.username", "root");
                password = props.getProperty("db.password", "Hema@123");
            } else {
                driver = "com.mysql.cj.jdbc.Driver";
                url = "jdbc:mysql://localhost:3306/clinic_appointment_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                username = "root";
                password = "Hema@123";
            }
            Class.forName(driver);
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback values
            driver = "com.mysql.cj.jdbc.Driver";
            url = "jdbc:mysql://localhost:3306/clinic_appointment_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            username = "root";
            password = "Hema@123";
            try {
                Class.forName(driver);
            } catch (ClassNotFoundException ex) {
                ex.printStackTrace();
            }
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    public static void close(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { /* ignore */ }
        }
    }

    public static void close(Statement stmt) {
        if (stmt != null) {
            try { stmt.close(); } catch (SQLException e) { /* ignore */ }
        }
    }

    public static void close(ResultSet rs) {
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) { /* ignore */ }
        }
    }

    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        close(rs);
        close(stmt);
        close(conn);
    }
}
