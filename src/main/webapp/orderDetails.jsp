<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dettagli Ordine</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/orderDetails.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<h1>Dettagli Ordine</h1>

<%
    int orderId = Integer.parseInt(request.getParameter("orderId"));
    session = request.getSession(false);
    if (session == null || session.getAttribute("userId") == null) {
%>
<div class="login-message">
    <p>Effettua il login per vedere i dettagli dell'ordine.</p>
    <a href="login.jsp">Accedi</a>
</div>
<% } else { %>
<table>
    <thead>
    <tr>
        <th>Prodotto</th>
        <th>Quantità</th>
        <th>Prezzo Unitario</th>
        <th>Subtotale</th>
    </tr>
    </thead>
    <tbody>
    <%@ page import="java.sql.*, java.math.*" %>
    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String jdbcUrl = "jdbc:mysql://localhost:3306/ecommerce";
            String username = "root";
            String password = "root";
            Connection conn = DriverManager.getConnection(jdbcUrl, username, password);

            PreparedStatement ps = conn.prepareStatement("SELECT p.nome, d.quantità, d.prezzo_unitario FROM dettagli_ordine d JOIN prodotti p ON d.id_prodotto = p.id WHERE d.id_ordine = ?");
            ps.setInt(1, orderId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String productName = rs.getString("nome");
                int quantity = rs.getInt("quantità");
                BigDecimal unitPrice = rs.getBigDecimal("prezzo_unitario");
                BigDecimal subtotal = unitPrice.multiply(new BigDecimal(quantity));
    %>
    <tr>
        <td><%= productName %></td>
        <td><%= quantity %></td>
        <td><%= unitPrice %></td>
        <td><%= subtotal %></td>
    </tr>
    <%
            }
            conn.close();
        } catch (Exception e) {
            out.println(e);
        }
    %>
    </tbody>
</table>
<% } %>

</body>
</html>
