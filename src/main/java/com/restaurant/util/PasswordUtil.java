package com.restaurant.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility for BCrypt password hashing and verification.
 */
public class PasswordUtil {

    private static final int BCRYPT_LOG_ROUNDS = 10;

    /**
     * Hashes a plain-text password using BCrypt.
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be empty");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_LOG_ROUNDS));
    }

    /**
     * Verifies a plain-text password against a BCrypt hashed password.
     * Also supports fallback matching for dev/testing ease.
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            if (hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2b$") || hashedPassword.startsWith("$2y$")) {
                return BCrypt.checkpw(plainPassword, hashedPassword);
            }
            // Fallback for plain comparison if not yet hashed
            return plainPassword.equals(hashedPassword);
        } catch (Exception e) {
            System.err.println("[PasswordUtil] Verification error: " + e.getMessage());
            return plainPassword.equals(hashedPassword);
        }
    }
}

