package com.myapp;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/ecommerce";
    private static final String JDBC_USERNAME = "root";
    private static final String JDBC_PASSWORD = "root";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = user.getId();

        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM ordini WHERE id_utente = ?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int orderId = rs.getInt("id");
                LocalDate date = rs.getDate("data").toLocalDate();
                BigDecimal totalPrice = rs.getBigDecimal("prezzo_totale");

                Order order = new Order(orderId, userId, date, totalPrice);
                orders.add(order);
            }

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("orders.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Errore nel recupero degli ordini", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementa solo se necessario gestire qualche operazione POST
    }
}
