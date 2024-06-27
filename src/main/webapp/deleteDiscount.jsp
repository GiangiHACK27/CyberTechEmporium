<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");

        // Ottieni l'ID del codice sconto da eliminare dalla richiesta
        int id = Integer.parseInt(request.getParameter("id"));

        // Query per eliminare il codice sconto
        String query = "DELETE FROM codici_sconto WHERE id = ?";
        stmt = conn.prepareStatement(query);
        stmt.setInt(1, id);
        int rowsDeleted = stmt.executeUpdate();

        if (rowsDeleted > 0) {
            response.sendRedirect("discountCodes.jsp"); // Redirect alla lista codici sconto dopo l'eliminazione
        } else {
            out.println("Non è stato possibile eliminare il codice sconto.");
        }

    } catch (ClassNotFoundException | SQLException e) {
        out.println("Errore durante l'accesso al database: " + e.getMessage());
    } finally {
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { /* Ignora */ }
        try { if (conn != null) conn.close(); } catch (SQLException e) { /* Ignora */ }
    }
%>
