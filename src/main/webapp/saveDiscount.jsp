<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.Date" %>

<%
    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        // Connessione al database
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");

        // Preparazione della query per l'inserimento
        String query = "INSERT INTO codici_sconto (codice, descrizione, percentuale_sconto, data_scadenza, attivo) VALUES (?, ?, ?, ?, ?)";
        stmt = conn.prepareStatement(query);

        // Recupero dei dati dal form
        String codice = request.getParameter("codice");
        String descrizione = request.getParameter("descrizione");
        double percentualeSconto = Double.parseDouble(request.getParameter("percentualeSconto"));
        String dataScadenzaStr = request.getParameter("dataScadenza");
        Date dataScadenza = null;
        if (dataScadenzaStr != null && !dataScadenzaStr.isEmpty()) {
            dataScadenza = new SimpleDateFormat("yyyy-MM-dd").parse(dataScadenzaStr);
        }
        boolean attivo = request.getParameter("attivo") != null;

        // Impostazione dei parametri della query
        stmt.setString(1, codice);
        stmt.setString(2, descrizione);
        stmt.setDouble(3, percentualeSconto);
        if (dataScadenza != null) {
            stmt.setDate(4, new java.sql.Date(dataScadenza.getTime()));
        } else {
            stmt.setNull(4, Types.DATE);
        }
        stmt.setBoolean(5, attivo);

        // Esecuzione della query di inserimento
        int rowsInserted = stmt.executeUpdate();

        // Controllo se l'inserimento è avvenuto con successo
        if (rowsInserted > 0) {
            out.println("<h2>Codice Sconto aggiunto con successo!</h2>");
        } else {
            out.println("<h2>Errore durante l'aggiunta del Codice Sconto</h2>");
        }

    } catch (ClassNotFoundException | SQLException | ParseException e) {
        out.println("<h2>Errore durante l'accesso al database: " + e.getMessage() + "</h2>");
    } finally {
        // Chiusura delle risorse
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { /* Ignora */ }
        try { if (conn != null) conn.close(); } catch (SQLException e) { /* Ignora */ }
    }
%>
