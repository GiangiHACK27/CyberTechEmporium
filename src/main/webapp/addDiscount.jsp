<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aggiungi Codice Sconto</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="css/addDiscount.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="admin-options">
    <h1>Aggiungi Codice Sconto</h1>
    <a href="discountCodes.jsp"><i class="fa fa-arrow-left"></i> Torna all'elenco</a>
</div>

<div class="discount-form">
    <form action="saveDiscount.jsp" method="post">
        <div class="form-group">
            <label for="codice">Codice:</label>
            <input type="text" id="codice" name="codice" required>
        </div>
        <div class="form-group">
            <label for="descrizione">Descrizione:</label>
            <textarea id="descrizione" name="descrizione"></textarea>
        </div>
        <div class="form-group">
            <label for="percentualeSconto">Percentuale Sconto:</label>
            <input type="number" id="percentualeSconto" name="percentualeSconto" min="0" max="100" step="0.01" required>
        </div>
        <div class="form-group">
            <label for="dataScadenza">Data Scadenza:</label>
            <input type="date" id="dataScadenza" name="dataScadenza">
        </div>
        <div class="form-group">
            <label for="attivo">Attivo:</label>
            <input type="checkbox" id="attivo" name="attivo" checked>
        </div>
        <button type="submit">Salva Codice Sconto</button>
    </form>
</div>

</body>
</html>
