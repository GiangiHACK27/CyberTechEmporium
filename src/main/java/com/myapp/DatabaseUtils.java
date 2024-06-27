package com.myapp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtils {
    public static Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/ecommerce";
        String user = "root";
        String password = "root";
        return DriverManager.getConnection(url, user, password);
    }
}
