<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifica Codice Sconto</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="css/addDiscount.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="admin-options">
    <h1>Modifica Codice Sconto</h1>
    <a href="discountCodes.jsp"><i class="fa fa-arrow-left"></i> Torna all'elenco</a>
</div>

<div class="discount-form">
    <%
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");

            // Ottieni l'ID del codice sconto da modificare dalla richiesta
            int id = Integer.parseInt(request.getParameter("id"));

            // Query per selezionare il codice sconto specifico
            String query = "SELECT * FROM codici_sconto WHERE id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String codice = rs.getString("codice");
                String descrizione = rs.getString("descrizione");
                double percentualeSconto = rs.getDouble("percentuale_sconto");
                Date dataScadenza = rs.getDate("data_scadenza");
                boolean attivo = rs.getBoolean("attivo");

                // Formattazione della data per il campo input di tipo date
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                String dataScadenzaFormatted = (dataScadenza != null) ? dateFormat.format(dataScadenza) : "";

    %>
    <form action="updateDiscount.jsp" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <div class="form-group">
            <label for="codice">Codice:</label>
            <input type="text" id="codice" name="codice" value="<%= codice %>" required>
        </div>
        <div class="form-group">
            <label for="descrizione">Descrizione:</label>
            <textarea id="descrizione" name="descrizione"><%= descrizione %></textarea>
        </div>
        <div class="form-group">
            <label for="percentualeSconto">Percentuale Sconto:</label>
            <input type="number" id="percentualeSconto" name="percentualeSconto" min="0" max="100" step="0.01" value="<%= percentualeSconto %>" required>
        </div>
        <div class="form-group">
            <label for="dataScadenza">Data Scadenza:</label>
            <input type="date" id="dataScadenza" name="dataScadenza" value="<%= dataScadenzaFormatted %>">
        </div>
        <div class="form-group">
            <label for="attivo">Attivo:</label>
            <input type="checkbox" id="attivo" name="attivo" <%= (attivo) ? "checked" : "" %>>
        </div>
        <button type="submit">Salva Modifiche</button>
    </form>
    <%
            } else {
                out.println("Codice sconto non trovato.");
            }
        } catch (ClassNotFoundException | SQLException e) {
            out.println("Errore durante l'accesso al database: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { /* Ignora */ }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { /* Ignora */ }
            try { if (conn != null) conn.close(); } catch (SQLException e) { /* Ignora */ }
        }
    %>
</div>

</body>
</html>
