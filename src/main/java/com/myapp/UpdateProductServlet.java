package com.myapp;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/updateProduct")
@MultipartConfig
public class UpdateProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/ecommerce";
    private static final String JDBC_USERNAME = "root";
    private static final String JDBC_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String nome = request.getParameter("nome");
        String fornitore = request.getParameter("fornitore");
        BigDecimal prezzo = new BigDecimal(request.getParameter("prezzo"));
        int quantita = Integer.parseInt(request.getParameter("quantita"));
        String marca = request.getParameter("marca");
        String categoria = request.getParameter("categoria");
        Part immaginePart = request.getPart("immagine");
        InputStream immagineStream = null;

        if (immaginePart != null && immaginePart.getSize() > 0) {
            immagineStream = immaginePart.getInputStream();
        }

        String sql = "UPDATE prodotti SET nome = ?, fornitore = ?, prezzo = ?, quantità_disponibile = ?, marca = ?, categoria = ?, immagine = ? WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nome);
            stmt.setString(2, fornitore);
            stmt.setBigDecimal(3, prezzo);
            stmt.setInt(4, quantita);
            stmt.setString(5, marca);
            stmt.setString(6, categoria);

            if (immagineStream != null) {
                stmt.setBlob(7, immagineStream);
            } else {
                stmt.setNull(7, java.sql.Types.BLOB);
            }

            stmt.setInt(8, id);
            stmt.executeUpdate();

            response.sendRedirect("products.jsp");

        } catch (SQLException e) {
            throw new ServletException("Errore nell'aggiornamento del prodotto", e);
        }
    }
}
