<%@ page import="java.sql.*, com.myapp.CartItem, java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Prodotti - CyberTech Emporium</title>
  <link rel="stylesheet" href="css/products-style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
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
          } catch (ClassNotFoundException | SQLException e) {
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
        String query = "SELECT SQL_CALC_FOUND_ROWS id, nome, fornitore, prezzo, quantità_disponibile, marca, categoria FROM Prodotti";
        String whereClause = "";
        String keyword = request.getParameter("search");
        String category = request.getParameter("category");
        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");
        String sortBy = request.getParameter("sortBy");

        if (keyword != null && !keyword.isEmpty()) {
          whereClause += " WHERE nome LIKE ?";
        }
        if (category != null && !category.isEmpty()) {
          whereClause += (whereClause.isEmpty() ? " WHERE" : " AND") + " categoria = ?";
        }
        if (minPrice != null && !minPrice.isEmpty()) {
          whereClause += (whereClause.isEmpty() ? " WHERE" : " AND") + " prezzo >= ?";
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
          whereClause += (whereClause.isEmpty() ? " WHERE" : " AND") + " prezzo <= ?";
        }

        PreparedStatement pstmtCount = conn.prepareStatement("SELECT COUNT(*) FROM Prodotti" + whereClause);
        PreparedStatement pstmtQuery = conn.prepareStatement(query + whereClause);

        int paramIndex = 1;
        if (keyword != null && !keyword.isEmpty()) {
          pstmtQuery.setString(paramIndex, "%" + keyword + "%");
          pstmtCount.setString(paramIndex++, "%" + keyword + "%");
        }
        if (category != null && !category.isEmpty()) {
          pstmtQuery.setString(paramIndex, category);
          pstmtCount.setString(paramIndex++, category);
        }
        if (minPrice != null && !minPrice.isEmpty()) {
          pstmtQuery.setBigDecimal(paramIndex, new BigDecimal(minPrice));
          pstmtCount.setBigDecimal(paramIndex++, new BigDecimal(minPrice));
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
          pstmtQuery.setBigDecimal(paramIndex, new BigDecimal(maxPrice));
          pstmtCount.setBigDecimal(paramIndex++, new BigDecimal(maxPrice));
        }

        ResultSet rsCount = pstmtCount.executeQuery();
        rsCount.next();
        int totalRecords = rsCount.getInt(1);
        totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        pstmtQuery.setMaxRows(recordsPerPage);
        pstmtQuery.setFetchSize(recordsPerPage * (currentPage - 1));
        ResultSet rs = pstmtQuery.executeQuery();
        while (rs.next()) {
          // Verifica se il prodotto è nel carrello
          boolean inCart = false;
          List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
          if (cart != null) {
            for (CartItem item : cart) {
              if (item.getProductId() == rs.getInt("id")) {
                inCart = true;
                break;
              }
            }
          }
          // Verifica disponibilità del prodotto
          int availability = rs.getInt("quantità_disponibile");
          boolean available = availability > 0;
    %>
    <div class="product-card">
      <img src="getImage?id=<%=rs.getInt("id")%>" alt="<%=rs.getString("nome")%>" class="product-image">
      <div class="product-info">
        <h3><%=rs.getString("nome")%></h3>
        <p>Brand: <%=rs.getString("marca")%></p>
        <p class="price">$<%=rs.getBigDecimal("prezzo")%></p>
        <p>
          <% if (available) { %>
          Available: <%=rs.getInt("quantità_disponibile")%> units
          <% } else { %>
          <span style="color: red;">Non disponibile</span>
          <% } %>
        </p>
      </div>
      <div class="card-footer">
        <div id="cartActions_<%=rs.getInt("id")%>" class="cart-actions">
          <% if (inCart) { %>
          <span onclick="updateCartQuantity(<%=rs.getInt("id")%>, 'minus')" class="quantity-action"><i class="fas fa-minus-circle"></i></span>
          <input id="quantity_<%=rs.getInt("id")%>" type="text" value="1" readonly>
          <span onclick="updateCartQuantity(<%=rs.getInt("id")%>, 'plus')" class="quantity-action"><i class="fas fa-plus-circle"></i></span>
          <span onclick="removeFromCart(<%=rs.getInt("id")%>)" class="remove-from-cart"><i class="fas fa-trash-alt"></i></span>
          <% } else if (available) { %>
          <form id="cartForm_<%=rs.getInt("id")%>" onsubmit="addToCart(event, <%=rs.getInt("id")%>)">
            <input type="hidden" name="productId" value="<%=rs.getInt("id")%>">
            <input type="hidden" name="productName" value="<%=rs.getString("nome")%>">
            <input type="hidden" name="productPrice" value="<%=rs.getBigDecimal("prezzo")%>">
            <button id="addBtn_<%=rs.getInt("id")%>" type="submit" class="add-to-cart-btn">Aggiungi al carrello</button>
          </form>
          <% } %>
        </div>
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
      for (int i = 1; i <= totalPages; i++) {
    %>
    <a href="products.jsp?page=<%=i%>" class="<%= i == currentPage ? "active" : "" %>"><%=i%></a>
    <%
      }
    %>
  </div>
</div>
<script>
  function addToCart(event, productId) {
    event.preventDefault();
    var form = $("#cartForm_" + productId);
    $.ajax({
      type: "POST",
      url: "AddToCartServlet",
      data: form.serialize(),
      success: function(response) {
        $("#cartActions_" + productId).html(response);
      },
      error: function(error) {
        console.log("Errore durante l'aggiunta al carrello: " + error);
      }
    });
  }

  function updateCartQuantity(productId, action) {
    $.ajax({
      type: "POST",
      url: "UpdateCartServlet",
      data: { productId: productId, action: action },
      success: function(response) {
        $("#cartActions_" + productId).html(response);
      },
      error: function(error) {
        console.log("Errore durante l'aggiornamento della quantità: " + error);
      }
    });
  }

  function removeFromCart(productId) {
    $.ajax({
      type: "POST",
      url: "RemoveFromCartServlet",
      data: { productId: productId },
      success: function(response) {
        $("#cartActions_" + productId).html(response);
      },
      error: function(error) {
        console.log("Errore durante la rimozione dal carrello: " + error);
      }
    });
  }

  function searchProducts() {
    var keyword = $("#searchInput").val();
    window.location.href = "products.jsp?search=" + encodeURIComponent(keyword);
  }

  function filterProducts(category) {
    window.location.href = "products.jsp?category=" + encodeURIComponent(category);
  }

  function filterByPrice() {
    var minPrice = $("#minPrice").val();
    var maxPrice = $("#maxPrice").val();
    window.location.href = "products.jsp?minPrice=" + minPrice + "&maxPrice=" + maxPrice;
  }

  function sortBy() {
    var sortBy = $("#sortBy").val();
    window.location.href = "products.jsp?sortBy=" + sortBy;
  }

  function toggleCategoryDropdown() {
    $("#categoryDropdownContent").toggle();
  }
</script>
</body>
</html>
