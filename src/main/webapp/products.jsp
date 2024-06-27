<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*, java.math.BigDecimal" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Prodotti - CyberTech Emporium</title>
  <link rel="stylesheet" href="css/products-style.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="header">
  <h1>Prodotti</h1>
  <div class="search-container">
    <input type="text" id="searchInput" placeholder="Cerca prodotti...">
    <button onclick="searchProducts()">Cerca</button>
    <div class="category-dropdown">
      <span onclick="toggleCategoryDropdown()">Categorie</span>
      <div id="categoryDropdownContent" class="dropdown-content">
        <%
          Connection con = null;
          try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT DISTINCT categoria FROM Prodotti");
            while (rs.next()) {
        %>
        <a href="#" onclick="filterProducts('<%=rs.getString("categoria")%>')"><%=rs.getString("categoria")%></a>
        <%
            }
          } catch (Exception e) {
            e.printStackTrace();
          } finally {
            try {
              if (con != null) con.close();
            } catch (SQLException e) {
              e.printStackTrace();
            }
          }
        %>
      </div>
    </div>
    <div class="price-filter">
      <label for="minPrice">Prezzo minimo:</label>
      <input type="number" id="minPrice" value="0">
      <label for="maxPrice">Prezzo massimo:</label>
      <input type="number" id="maxPrice" value="1000">
      <button onclick="filterByPrice()">Filtra</button>
    </div>
    <div class="sort-by">
      <label for="sortBy">Ordina per:</label>
      <select id="sortBy" onchange="sortBy()">
        <option value="nome">Nome</option>
        <option value="prezzo">Prezzo</option>
        <option value="data_aggiunta">Data di aggiunta</option>
      </select>
    </div>
  </div>
</div>
<div class="container">
  <div class="product-grid">
    <%
      int recordsPerPage = 4;
      int currentPage = 1;
      if (request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
      }
      Connection conn = null;
      int totalPages = 0;
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
        Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        String query = "SELECT SQL_CALC_FOUND_ROWS id, nome, fornitore, prezzo, quantità_disponibile, marca, categoria FROM Prodotti";
        String whereClause = "";
        String keyword = request.getParameter("search");
        String category = request.getParameter("category");
        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");
        String sortBy = request.getParameter("sortBy");

        if (keyword != null && !keyword.isEmpty()) {
          whereClause += " WHERE nome LIKE '%" + keyword + "%'";
        }
        if (category != null && !category.isEmpty()) {
          whereClause += (whereClause.isEmpty() ? " WHERE" : " AND") + " categoria = '" + category + "'";
        }
        if (minPrice != null && !minPrice.isEmpty()) {
          whereClause += (whereClause.isEmpty() ? " WHERE" : " AND") + " prezzo >= " + minPrice;
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
          whereClause += (whereClause.isEmpty() ? " WHERE" : " AND") + " prezzo <= " + maxPrice;
        }
        query += whereClause;
        if (sortBy != null && !sortBy.isEmpty()) {
          query += " ORDER BY " + sortBy;
        }
        ResultSet rsCount = stmt.executeQuery("SELECT COUNT(*) FROM Prodotti" + whereClause);
        rsCount.next();
        int totalRecords = rsCount.getInt(1);
        totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        query += " LIMIT " + (currentPage - 1) * recordsPerPage + "," + recordsPerPage;
        ResultSet rs = stmt.executeQuery(query);
        while (rs.next()) {
    %>
    <div class="product-card">
      <img src="getImage?id=<%=rs.getInt("id")%>" alt="<%=rs.getString("nome")%>" class="product-image">
      <div class="product-info">
        <h3><%=rs.getString("nome")%></h3>
        <p>Brand: <%=rs.getString("marca")%></p>
        <p class="price">$<%=rs.getBigDecimal("prezzo")%></p>
        <p>Available: <%=rs.getInt("quantità_disponibile")%> units</p>
        <form id="cartForm_<%=rs.getInt("id")%>" onsubmit="addToCart(event, <%=rs.getInt("id")%>)">
          <input type="hidden" name="productId" value="<%=rs.getInt("id")%>">
          <input type="hidden" name="name" value="<%=rs.getString("nome")%>">
          <input type="hidden" name="description" value="<%=rs.getString("marca")%>">
          <input type="hidden" name="price" value="<%=rs.getBigDecimal("prezzo")%>">
          <input type="hidden" name="imageUrl" value="getImage?id=<%=rs.getInt("id")%>">
          <button type="submit" class="add-to-cart-btn" id="addBtn_<%=rs.getInt("id")%>">Aggiungi al carrello</button>
        </form>
      </div>
    </div>
    <%
        }
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        try {
          if (conn != null) conn.close();
        } catch (SQLException e) {
          e.printStackTrace();
        }
      }
    %>
  </div>
  <div class="pagination">
    <%
      String keywordParam = (request.getParameter("search") != null) ? request.getParameter("search") : "";
      String categoryParam = (request.getParameter("category") != null) ? request.getParameter("category") : "";
      String minPriceParam = (request.getParameter("minPrice") != null) ? request.getParameter("minPrice") : "";
      String maxPriceParam = (request.getParameter("maxPrice") != null) ? request.getParameter("maxPrice") : "";
      String sortByParam = (request.getParameter("sortBy") != null) ? request.getParameter("sortBy") : "";

      for (int i = 1; i <= totalPages; i++) {
    %>
    <a href="?page=<%=i%>&search=<%=keywordParam%>&category=<%=categoryParam%>&minPrice=<%=minPriceParam%>&maxPrice=<%=maxPriceParam%>&sortBy=<%=sortByParam%>" <%=i == currentPage ? "class='active'" : ""%>><%=i%></a>
    <% }
    %>
  </div>
</div>

<div class="footer">
  <p>&copy; 2024 CyberTech Emporium. All rights reserved.</p>
</div>

<script>
  function searchProducts() {
    var keyword = document.getElementById("searchInput").value;
    window.location.href = "?search=" + keyword;
  }

  function filterProducts(category) {
    window.location.href = "?category=" + category;
  }

  function filterByPrice() {
    var minPrice = document.getElementById("minPrice").value;
    var maxPrice = document.getElementById("maxPrice").value;
    window.location.href = "?minPrice=" + minPrice + "&maxPrice=" + maxPrice;
  }

  function sortBy() {
    var sortBy = document.getElementById("sortBy").value;
    window.location.href = "?sortBy=" + sortBy;
  }

  function addToCart(event, productId) {
    event.preventDefault();
    var form = document.getElementById("cartForm_" + productId);
    var formData = $(form).serialize();
    $.ajax({
      type: 'POST',
      url: 'addToCart',
      data: formData,
      success: function(response) {
        alert('Prodotto aggiunto al carrello!');
        updateCartCounter(); // Esempio: aggiorna il contatore nel navbar
      },
      error: function(xhr, status, error) {
        alert('Errore durante l\'aggiunta al carrello. Riprova più tardi.');
      }
    });
  }

  function toggleCategoryDropdown() {
    var dropdownContent = document.getElementById("categoryDropdownContent");
    dropdownContent.classList.toggle("show");
  }

  // Close the dropdown menu if the user clicks outside of it
  window.onclick = function(event) {
    if (!event.target.matches('.category-dropdown span')) {
      var dropdowns = document.getElementsByClassName("dropdown-content");
      for (var i = 0; i < dropdowns.length; i++) {
        var openDropdown = dropdowns[i];
        if (openDropdown.classList.contains('show')) {
          openDropdown.classList.remove('show');
        }
      }
    }
  }
</script>

</body>
</html>
