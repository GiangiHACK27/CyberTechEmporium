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

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp?error=empty_cart");
            return;
        }

        BigDecimal totalAmount = calculateTotal(cart);

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD)) {
            conn.setAutoCommit(false);

            try {
                if (updateUserCredit(user.getId(), totalAmount, conn)) {
                    Order newOrder = placeOrder(user.getId(), totalAmount, conn);
                    addOrderDetails(newOrder.getId(), cart, conn);
                    updateProductQuantities(cart, conn);

                    conn.commit();
                    session.removeAttribute("cart");
                    response.sendRedirect("orders.jsp?success=true");
                } else {
                    conn.rollback();
                    response.sendRedirect("cart.jsp?error=not_enough_credit");
                }
            } catch (SQLException e) {
                conn.rollback();
                throw new ServletException("Database error", e);
            }
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

    private boolean updateUserCredit(int userId, BigDecimal totalAmount, Connection conn) throws SQLException {
        String query = "SELECT credito FROM utenti WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal currentCredit = rs.getBigDecimal("credito");
                if (currentCredit.compareTo(totalAmount) >= 0) {
                    String updateCreditQuery = "UPDATE utenti SET credito = credito - ? WHERE id = ?";
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateCreditQuery)) {
                        updateStmt.setBigDecimal(1, totalAmount);
                        updateStmt.setInt(2, userId);
                        updateStmt.executeUpdate();
                    }
                    return true;
                }
            }
        }
        return false;
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

    private void addOrderDetails(int orderId, List<CartItem> cart, Connection conn) throws SQLException {
        String sql = "INSERT INTO dettagli_ordine (id_ordine, id_prodotto, quantità, prezzo_unitario) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (CartItem item : cart) {
                stmt.setInt(1, orderId);
                stmt.setInt(2, item.getProductId());
                stmt.setInt(3, item.getQuantity());
                stmt.setBigDecimal(4, item.getPrice());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    private void updateProductQuantities(List<CartItem> cart, Connection conn) throws SQLException {
        String sql = "UPDATE prodotti SET quantità_disponibile = quantità_disponibile - ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (CartItem item : cart) {
                stmt.setInt(1, item.getQuantity());
                stmt.setInt(2, item.getProductId());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }
}
