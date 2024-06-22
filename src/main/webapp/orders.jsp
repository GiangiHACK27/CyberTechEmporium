<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>I tuoi Ordini</title>
    <link rel="stylesheet" href="css/orders.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<h1 style="text-align: center">I tuoi Ordini</h1>

<%
    session = request.getSession(false);
    if (session == null || session.getAttribute("userId") == null) {
%>
<div class="login-message">
    <p>Effettua il login per vedere i tuoi ordini.</p>
    <a href="login.jsp">Accedi</a>
</div>
<% } else { %>
<table>
    <thead>
    <tr>
        <th>ID Ordine</th>
        <th>Data</th>
        <th>Prezzo Totale</th>
        <th>Dettagli</th>
    </tr>
    </thead>
    <tbody>
    <%@ page import="java.sql.*, java.time.*, java.math.*" %>
    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String jdbcUrl = "jdbc:mysql://localhost:3306/ecommerce";
            String username = "root";
            String password = "root";
            Connection conn = DriverManager.getConnection(jdbcUrl, username, password);

            int userId = (int) session.getAttribute("userId");

            PreparedStatement ps = conn.prepareStatement("SELECT * FROM ordini WHERE id_utente = ?");
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            boolean foundOrders = false;
            while (rs.next()) {
                foundOrders = true;
                int orderId = rs.getInt("id");
                LocalDate date = rs.getDate("data").toLocalDate();
                BigDecimal totalPrice = rs.getBigDecimal("prezzo_totale");
    %>
    <tr>
        <td><%= orderId %></td>
        <td><%= date %></td>
        <td><%= totalPrice %></td>
        <td><a href="orderDetails.jsp?orderId=<%= orderId %>">Visualizza Dettagli</a></td>
    </tr>
    <%
        }
        conn.close();

        if (!foundOrders) {
    %>
    <tr>
        <td colspan="4" class="no-orders">Nessun ordine trovato.</td>
    </tr>
    <%
            }
        } catch (Exception e) {
            out.println(e);
        }
    %>
    </tbody>
</table>
<% } %>

</body>
</html>
