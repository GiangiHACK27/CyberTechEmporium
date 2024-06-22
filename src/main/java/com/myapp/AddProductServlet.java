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

@WebServlet("/addProduct")
@MultipartConfig(maxFileSize = 16177215) // 16MB
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/ecommerce";
    private static final String JDBC_USERNAME = "root";
    private static final String JDBC_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nome = request.getParameter("nome");
        String fornitore = request.getParameter("fornitore");
        BigDecimal prezzo = new BigDecimal(request.getParameter("prezzo"));
        int quantità_disponibile = Integer.parseInt(request.getParameter("quantità_disponibile"));
        String marca = request.getParameter("marca");
        String categoria = request.getParameter("categoria");

        InputStream inputStream = null;
        Part filePart = request.getPart("immagine");
        if (filePart != null) {
            inputStream = filePart.getInputStream();
        }

        String sql = "INSERT INTO prodotti (nome, fornitore, prezzo, quantità_disponibile, marca, immagine, categoria) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Assicurarsi che il driver sia caricato
            try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
                 PreparedStatement statement = conn.prepareStatement(sql)) {

                statement.setString(1, nome);
                statement.setString(2, fornitore);
                statement.setBigDecimal(3, prezzo);
                statement.setInt(4, quantità_disponibile);
                statement.setString(5, marca);

                if (inputStream != null) {
                    statement.setBlob(6, inputStream);
                }

                statement.setString(7, categoria);

                int row = statement.executeUpdate();
                if (row > 0) {
                    response.sendRedirect("adminOptions.jsp?message=Prodotto aggiunto con successo");
                } else {
                    response.sendRedirect("addProduct.jsp?error=Errore durante l'inserimento del prodotto");
                }
            }
        } catch (ClassNotFoundException ex) {
            throw new ServletException("Driver JDBC non trovato", ex);
        } catch (SQLException ex) {
            throw new ServletException("Errore nel salvataggio del prodotto", ex);
        }
    }
}
