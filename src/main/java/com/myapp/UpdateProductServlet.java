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

        String action = request.getParameter("action");
        int id = Integer.parseInt(request.getParameter("id"));

        if ("delete".equals(action)) {
            deleteProduct(id, response);
        } else {
            updateProduct(request, response, id);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {

        String nome = request.getParameter("nome");
        String fornitore = request.getParameter("fornitore");
        BigDecimal prezzo = new BigDecimal(request.getParameter("prezzo"));
        int quantita = Integer.parseInt(request.getParameter("quantita"));
        String marca = request.getParameter("marca");
        String categoria = request.getParameter("categoria");
        Part immaginePart = request.getPart("immagine");
        InputStream immagineStream = null;
        boolean isNewImageUploaded = immaginePart != null && immaginePart.getSize() > 0;

        if (isNewImageUploaded) {
            immagineStream = immaginePart.getInputStream();
        }

        String sql = "UPDATE prodotti SET nome = ?, fornitore = ?, prezzo = ?, quantità_disponibile = ?, marca = ?, categoria = ?"
                + (isNewImageUploaded ? ", immagine = ?" : "") + " WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nome);
            stmt.setString(2, fornitore);
            stmt.setBigDecimal(3, prezzo);
            stmt.setInt(4, quantita);
            stmt.setString(5, marca);
            stmt.setString(6, categoria);

            if (isNewImageUploaded) {
                stmt.setBlob(7, immagineStream);
                stmt.setInt(8, id);
            } else {
                stmt.setInt(7, id);
            }

            stmt.executeUpdate();

            response.sendRedirect("editProduct.jsp");

        } catch (SQLException e) {
            throw new ServletException("Errore nell'aggiornamento del prodotto", e);
        }
    }

    private void deleteProduct(int id, HttpServletResponse response)
            throws ServletException, IOException {

        String deleteDetailsQuery = "DELETE FROM dettagli_ordine WHERE id_prodotto = ?";
        String deleteProductQuery = "DELETE FROM prodotti WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement psDeleteDetails = conn.prepareStatement(deleteDetailsQuery);
             PreparedStatement psDeleteProduct = conn.prepareStatement(deleteProductQuery)) {

            // Elimina i dettagli dell'ordine associati al prodotto
            psDeleteDetails.setInt(1, id);
            psDeleteDetails.executeUpdate();

            // Elimina il prodotto stesso
            psDeleteProduct.setInt(1, id);
            int rowsDeletedProduct = psDeleteProduct.executeUpdate();

            if (rowsDeletedProduct > 0) {
                response.sendRedirect("editProduct.jsp");
            } else {
                throw new ServletException("Errore nell'eliminazione del prodotto.");
            }

        } catch (SQLException e) {
            throw new ServletException("Errore nell'eliminazione del prodotto", e);
        }
    }
}
