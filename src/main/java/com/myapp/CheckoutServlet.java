package com.myapp;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/ecommerce";
    private static final String JDBC_USERNAME = "root";
    private static final String JDBC_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        BigDecimal totalAmount = calculateTotal(cart);

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD)) {
            Order newOrder = placeOrder(user.getId(), totalAmount, conn);

            session.removeAttribute("cart");

            response.sendRedirect("orders.jsp?success=true");
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private BigDecimal calculateTotal(List<CartItem> cart) {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart) {
            BigDecimal price = item.getPrice();
            BigDecimal quantity = new BigDecimal(item.getQuantity());
            total = total.add(price.multiply(quantity));
        }
        return total;
    }

    private Order placeOrder(int userId, BigDecimal totalAmount, Connection conn) throws SQLException {
        String sql = "INSERT INTO ordini (id_utente, data, prezzo_totale) VALUES (?, ?, ?)";
        LocalDate currentDate = LocalDate.now();

        try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, userId);
            stmt.setDate(2, java.sql.Date.valueOf(currentDate));
            stmt.setBigDecimal(3, totalAmount);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int orderId = generatedKeys.getInt(1);
                    return new Order(orderId, userId, currentDate, totalAmount);
                } else {
                    throw new SQLException("Failed to retrieve generated order ID");
                }
            } else {
                throw new SQLException("Failed to place order, no rows affected");
            }
        }
    }
}
