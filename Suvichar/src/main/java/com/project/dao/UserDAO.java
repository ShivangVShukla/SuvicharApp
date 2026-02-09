package com.project.dao;

import java.sql.*;
import com.project.model.User;

public class UserDAO {
    private String url = "jdbc:mysql://localhost:3306/quote_db";
    private String user = "root";
    private String pass = "admin";

    // Centralized driver loading to ensure consistency
    private void loadDriver() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver not found: " + e.getMessage());
        }
    }

    public boolean registerUser(User userObj) throws SQLException {
        loadDriver();
        String sql = "INSERT INTO users (first_name, last_name, email, password) VALUES (?, ?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userObj.getFirstName());
            ps.setString(2, userObj.getLastName());
            ps.setString(3, userObj.getEmail());
            ps.setString(4, userObj.getPassword());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean validateUser(String email, String password) throws SQLException {
        loadDriver();
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        loadDriver(); // Crucial: Driver must be loaded here too!
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("email"),
                        rs.getString("password")
                    );
                }
            }
        }
        return null;
    }
}