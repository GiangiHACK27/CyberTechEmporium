<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, java.sql.*, com.myapp.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ricarica Credito</title>
    <link rel="stylesheet" href="css/recargestyle.css">
</head>
<body>
<%
    // Verifica se l'utente è loggato
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Recupera l'importo dalla richiesta
    int amount = Integer.parseInt(request.getParameter("amount"));

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");

        // Esegui l'aggiornamento del credito dell'utente
        PreparedStatement ps = con.prepareStatement("UPDATE utenti SET credito = credito + ? WHERE id = ?");
        ps.setInt(1, amount);
        ps.setInt(2, user.getId());
        int updatedRows = ps.executeUpdate();

        if (updatedRows > 0) {
            // Aggiorna il credito dell'utente dopo la ricarica
            user.setCredito(user.getCredito() + amount);
%>
<div class="container">
    <h2>Credito Ricaricato con Successo</h2>
    <div class="success-message">
        <p>Il tuo nuovo saldo è: <span class="balance"><%= user.getCredito() %> Euro</span></p>
    </div>
</div>
<%
} else {
%>
<div class="container">
    <h2>Errore durante la Ricarica del Credito</h2>
    <div class="error-message">
        <p>Si è verificato un problema durante l'aggiornamento del credito. Riprova più tardi.</p>
    </div>
</div>
<%
        }
        con.close();
    } catch (Exception e) {
        out.println(e);
    }
%>
</body>
</html>
