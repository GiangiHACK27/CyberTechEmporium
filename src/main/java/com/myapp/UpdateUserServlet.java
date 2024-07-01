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
        // Carica il driver JDBC
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("Errore durante il caricamento del driver JDBC", e);
        }

        // Recupera i parametri dal form
        int userId = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String ruolo = request.getParameter("ruolo");

        // Costruisci la query SQL
        StringBuilder sql = new StringBuilder();
        sql.append("UPDATE utenti SET nickname=?, email=?, ");
        if (password != null && !password.isEmpty()) {
            sql.append("password=?, ");
        }
        sql.append("nome=?, cognome=?");
        if (ruolo != null && !ruolo.isEmpty()) {
            sql.append(", ruolo=?");
        }
        sql.append(" WHERE id=?");

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Imposta i parametri nella query
            int paramIndex = 1;
            stmt.setString(paramIndex++, username);
            stmt.setString(paramIndex++, email);
            if (password != null && !password.isEmpty()) {
                stmt.setString(paramIndex++, password);
            }
            stmt.setString(paramIndex++, nome);
            stmt.setString(paramIndex++, cognome);
            if (ruolo != null && !ruolo.isEmpty()) {
                stmt.setString(paramIndex++, ruolo);
            }
            stmt.setInt(paramIndex, userId);

            // Esegue l'aggiornamento
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException("Errore durante l'aggiornamento dei dati utente", e);
        }

        // Reindirizza l'utente alla pagina appropriata
        String referer = request.getHeader("referer");
        if (referer.contains("viewUsers.jsp")) {
            response.sendRedirect("viewUsers.jsp");
        } else {
            response.sendRedirect("user.jsp");
        }
    }
}
