<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visualizza Ordini</title>
    <link rel="stylesheet" href="css/viewOrders.css">
    <link rel="stylesheet" href="css/navbar.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="container">
    <h2>Visualizza Ordini</h2>
    <!-- Form di ricerca -->
    <form method="get" action="viewOrders.jsp">
        <input type="text" id="searchOrderId" name="searchOrderId" placeholder="Cerca per ID Ordine">
        <input type="text" id="searchCliente" name="searchCliente" placeholder="Cerca per Cliente (Username)">
        <input type="submit" value="Cerca">
    </form>

    <%
        String searchOrderId = request.getParameter("searchOrderId");
        String searchCliente = request.getParameter("searchCliente");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
            Statement stmt = con.createStatement();

            String query = "SELECT o.id, o.data, o.prezzo_totale, u.nickname FROM ordini o JOIN utenti u ON o.id_utente = u.id WHERE 1=1";
            if (searchOrderId != null && !searchOrderId.isEmpty()) {
                query += " AND o.id = " + Integer.parseInt(searchOrderId);
            }
            if (searchCliente != null && !searchCliente.isEmpty()) {
                query += " AND u.nickname LIKE '%" + searchCliente + "%'";
            }

            ResultSet rs = stmt.executeQuery(query);
    %>
    <table>
        <thead>
        <tr>
            <th>ID Ordine</th>
            <th>Data</th>
            <th>Prezzo Totale</th>
            <th>Cliente</th>
            <th>Dettagli</th>
        </tr>
        </thead>
        <tbody>
        <%
            boolean foundOrders = false;
            while (rs.next()) {
                foundOrders = true;
                int orderId = rs.getInt("id");
                LocalDate date = rs.getDate("data").toLocalDate();
                BigDecimal totalPrice = rs.getBigDecimal("prezzo_totale");
                String cliente = rs.getString("nickname");
        %>
        <tr>
            <td><%= orderId %></td>
            <td><%= date %></td>
            <td><%= totalPrice %></td>
            <td><%= cliente %></td>
            <td><a href="orderDetails.jsp?orderId=<%= orderId %>">Visualizza Dettagli</a></td>
        </tr>
        <%
            }
            if (!foundOrders) {
        %>
        <tr>
            <td colspan="5" class="no-orders">Nessun ordine trovato.</td>
        </tr>
        <%
            }
            con.close();
        %>
        </tbody>
    </table>
    <%
        } catch (Exception e) {
            out.println(e);
        }
    %>
</div>

</body>
</html>
