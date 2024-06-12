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

<div class="search-container">
  <div class="search-dropdown">
    <input type="text" id="searchInput" placeholder="Search products...">
    <div class="category-dropdown">
      <span onclick="toggleCategoryDropdown()">Categories</span>
      <div id="categoryDropdownContent" class="dropdown-content">
        <!-- Popola le opzioni di categoria dinamicamente dal database -->
        <%
          try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT DISTINCT categoria FROM Prodotti");
            while (rs.next()) {
        %>
        <a href="#" onclick="filterProducts('<%= rs.getString("categoria") %>')"><%= rs.getString("categoria") %></a>
        <%
            }
            con.close();
          } catch (Exception e) {
            e.printStackTrace();
          }
        %>
      </div>
    </div>
  </div>
  <button onclick="searchProducts()">Search</button>
</div>

<div class="product-container">
  <%
    // Esegui la query per ottenere i prodotti dal database
    String keyword = request.getParameter("search");
    String category = request.getParameter("category");
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
      Statement stmt = con.createStatement();
      ResultSet rs;
      String query = "SELECT id, nome, fornitore, prezzo, quantità_disponibile, marca, categoria FROM Prodotti";
      if (keyword != null && !keyword.isEmpty()) {
        // Se è stata effettuata una ricerca, aggiungi il filtro della parola chiave alla query
        query += " WHERE nome LIKE '%" + keyword + "%'";
      }
      if (category != null && !category.isEmpty()) {
        // Se è stata selezionata una categoria, aggiungi il filtro della categoria alla query
        if (keyword != null && !keyword.isEmpty()) {
          query += " AND categoria = '" + category + "'";
        } else {
          query += " WHERE categoria = '" + category + "'";
        }
      }
      rs = stmt.executeQuery(query);

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
  function searchProducts() {
    var keyword = document.getElementById("searchInput").value; // Ottieni la parola chiave di ricerca
    // Invia una richiesta al server per eseguire la ricerca
    // Puoi farlo utilizzando AJAX o un semplice ricaricamento della pagina con i parametri della ricerca
    window.location.href = "products.jsp?search=" + keyword;
  }

  function filterProducts(category) {
    // Aggiungi la categoria selezionata come parametro alla richiesta dei prodotti
    window.location.href = "products.jsp?category=" + category;
  }

  function toggleCategoryDropdown() {
    document.getElementById("categoryDropdownContent").classList.toggle("show");
  }

  // Chiudi il dropdown se l'utente clicca fuori da esso
  window.onclick = function(event) {
    if (!event.target.matches('.category-dropdown span')) {
      var dropdowns = document.getElementsByClassName("dropdown-content");
      var i;
      for (i = 0; i < dropdowns.length; i++) {
        var openDropdown = dropdowns[i];
        if (openDropdown.classList.contains('show')) {
          openDropdown.classList.remove('show');
        }
      }
    }
  }

  function addToCart(productId) {
    alert("Product " + productId + " added to cart!");
    // Aggiungi qui il codice per gestire l'aggiunta del prodotto al carrello
  }
</script>

</body>
</html>
