package com.myapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/updateUser")
public class UpdateUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/ecommerce";
    private static final String JDBC_USERNAME = "root";
    private static final String JDBC_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Recupera i parametri dal form
        int userId = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String ruolo = request.getParameter("ruolo");

        String sql = "UPDATE utenti SET nickname=?, email=?, nome=?, cognome=?, ruolo=? WHERE id=?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Imposta i parametri nella query
            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, nome);
            stmt.setString(4, cognome);
            stmt.setString(5, ruolo);
            stmt.setInt(6, userId);

            // Esegue l'aggiornamento
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException("Errore durante l'aggiornamento dei dati utente", e);
        }

        // Reindirizza l'utente alla pagina viewUsers.jsp
        response.sendRedirect("viewUsers.jsp");
    }
}
