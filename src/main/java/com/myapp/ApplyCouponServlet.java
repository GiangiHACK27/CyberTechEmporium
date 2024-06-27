package com.myapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList; // Import necessario per utilizzare ArrayList
import java.util.List;

@WebServlet("/applyCoupon")
public class ApplyCouponServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String couponCode = request.getParameter("couponCode");

        // Connessione al database per verificare il codice sconto
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT percentuale_sconto FROM codici_sconto WHERE codice = ? AND attivo = 1")) {

            stmt.setString(1, couponCode);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                BigDecimal discountPercent = rs.getBigDecimal("percentuale_sconto");

                HttpSession session = request.getSession();
                List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

                BigDecimal total = BigDecimal.ZERO;
                for (CartItem item : cart) {
                    BigDecimal discountedPrice = item.getPrice().multiply(BigDecimal.ONE.subtract(discountPercent.divide(BigDecimal.valueOf(100))));
                    item.setPrice(discountedPrice);
                    total = total.add(discountedPrice.multiply(BigDecimal.valueOf(item.getQuantity())));
                }

                // Arrotonda il totale a due cifre decimali
                total = total.setScale(2, RoundingMode.HALF_UP);

                // Aggiorna il carrello nella sessione
                session.setAttribute("cart", cart);

                // Prepara la risposta JSON
                String jsonResponse = "{\"success\": true, \"total\":\"" + total + "\"}";

                // Invia la risposta JSON
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(jsonResponse);
            } else {
                // Codice sconto non valido
                String jsonResponse = "{\"success\": false, \"message\":\"Codice sconto non valido.\"}";
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(jsonResponse);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            // Gestione dell'errore
            String jsonResponse = "{\"success\": false, \"message\":\"Errore durante l'applicazione del codice sconto.\"}";
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonResponse);
        }
    }
}


