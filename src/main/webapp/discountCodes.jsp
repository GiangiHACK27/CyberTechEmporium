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
    <title>Codici Sconto</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="css/discountCodes.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="admin-options">
    <h1>Gestione Codici Sconto</h1>
    <a href="addDiscount.jsp"><i class="fa fa-plus"></i> Aggiungi Codice Sconto</a>
    <!-- Altri link per gestire i codici sconto -->
</div>

<div class="discount-codes">
    <h2>Elenco Codici Sconto</h2>
    <table>
        <thead>
        <tr>
            <th>Codice</th>
            <th>Descrizione</th>
            <th>Percentuale Sconto</th>
            <th>Data Scadenza</th>
            <th>Stato</th>
            <th>Azioni</th>
        </tr>
        </thead>
        <tbody>
        <%
            // Dichiarazione delle variabili
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                // Connessione al database
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");

                // Query per selezionare i codici sconto
                String query = "SELECT * FROM codici_sconto";
                stmt = conn.prepareStatement(query);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String codice = rs.getString("codice");
                    String descrizione = rs.getString("descrizione");
                    double percentualeSconto = rs.getDouble("percentuale_sconto");
                    Date dataScadenza = rs.getDate("data_scadenza");
                    boolean attivo = rs.getBoolean("attivo");

                    // Formattazione della data per visualizzazione
                    String dataScadenzaFormatted = (dataScadenza != null) ? new SimpleDateFormat("dd/MM/yyyy").format(dataScadenza) : "N/D";

                    // Determinazione dello stato del codice sconto
                    String stato = attivo ? "Attivo" : "Non Attivo";

                    // Costruzione della riga della tabella
                    out.println("<tr>");
                    out.println("<td>" + codice + "</td>");
                    out.println("<td>" + descrizione + "</td>");
                    out.println("<td>" + percentualeSconto + "%</td>");
                    out.println("<td>" + dataScadenzaFormatted + "</td>");
                    out.println("<td>" + stato + "</td>");
                    out.println("<td>");
                    out.println("<a href='editDiscount.jsp?id=" + id + "'><i class='fa fa-edit'></i> Modifica</a>");
                    out.println("<a href='deleteDiscount.jsp?id=" + id + "'><i class='fa fa-trash'></i> Elimina</a>");
                    out.println("</td>");
                    out.println("</tr>");
                }
            } catch (ClassNotFoundException | SQLException e) {
                out.println("Errore durante l'accesso al database: " + e.getMessage());
            } finally {
                // Chiusura delle risorse
                try { if (rs != null) rs.close(); } catch (SQLException e) { /* Ignora */ }
                try { if (stmt != null) stmt.close(); } catch (SQLException e) { /* Ignora */ }
                try { if (conn != null) conn.close(); } catch (SQLException e) { /* Ignora */ }
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
