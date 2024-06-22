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

@WebServlet("/editUser")
public class EditUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/ecommerce";
    private static final String JDBC_USERNAME = "root";
    private static final String JDBC_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("userId"));
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String nickname = request.getParameter("nickname");
        String ruolo = request.getParameter("ruolo");
        int credito = Integer.parseInt(request.getParameter("credito"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD);
            String sql = "UPDATE utenti SET nome=?, cognome=?, email=?, nickname=?, ruolo=?, credito=? WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, nome);
            stmt.setString(2, cognome);
            stmt.setString(3, email);
            stmt.setString(4, nickname);
            stmt.setString(5, ruolo);
            stmt.setInt(6, credito);
            stmt.setInt(7, userId);
            stmt.executeUpdate();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new ServletException("Errore nell'aggiornamento dell'utente", e);
        }

        response.sendRedirect("viewUsers.jsp");
    }
}

