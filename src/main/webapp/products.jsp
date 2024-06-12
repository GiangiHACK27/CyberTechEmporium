<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Products - CyberTech Emporium</title>
  <link rel="stylesheet" href="style.css"> <!-- Includi il file CSS generale -->
  <link rel="stylesheet" href="products-style.css"> <!-- Includi il nuovo file CSS per i prodotti -->
</head>
<body>
<%@ include file="navbar.jsp" %> <!-- Include la barra di navigazione -->

<div class="header">
  <h1>Our Products</h1>
</div>

<div class="product-container">
  <%
    // Esegui la query per ottenere i prodotti dal database
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
      Statement stmt = con.createStatement();
      ResultSet rs = stmt.executeQuery("SELECT id, nome, fornitore, prezzo, quantità_disponibile, marca, categoria FROM Prodotti");

      while (rs.next()) {
  %>
  <div class="product">
    <img src="getImage?id=<%= rs.getInt("id") %>" alt="<%= rs.getString("nome") %>">
    <h3><%= rs.getString("nome") %></h3>
    <p>Brand: <%= rs.getString("marca") %></p>
    <p class="price">$<%= rs.getBigDecimal("prezzo") %></p>
    <p>Available: <%= rs.getInt("quantità_disponibile") %> units</p>
    <button class="add-to-cart" onclick="addToCart(<%= rs.getInt("id") %>)">Add to Cart</button>
  </div>
  <%
      }
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
  %>
</div>

<footer class="footer">
  <p>&copy; 2024 CyberTech Emporium. All rights reserved.</p>
</footer>

<script>
  function addToCart(productId) {
    alert("Product " + productId + " added to cart!");
    // Aggiungi qui il codice per gestire l'aggiunta del prodotto al carrello
  }
</script>

</body>
</html>
