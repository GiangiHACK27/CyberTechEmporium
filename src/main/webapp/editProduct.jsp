<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Modifica Prodotti</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <link rel="stylesheet" href="css/editProduct.css">
</head>
<body>
<div class="navbar" id="navbar">
  <a href="index.jsp"><i class="fa fa-home"></i> Home</a>
  <a href="products.jsp"><i class="fa fa-box-open"></i> Products</a>
  <a href="orders.jsp"><i class="fa fa-file-invoice-dollar"></i> Ordini</a>
  <a href="about.jsp"><i class="fa fa-info-circle"></i> About Us</a>
  <a href="contact.jsp"><i class="fa fa-envelope"></i> Contact</a>

  <div class="navbar-right" id="navbarRight">
    <a href="logout.jsp"><i class="fa fa-sign-out-alt"></i> Logout</a>
    <a href="user.jsp"><i class="fa fa-user"></i> Account</a>
  </div>
  <a href="cart.jsp"><i class="fa fa-shopping-cart"></i> Cart</a>
</div>

<div class="container">
  <div class="admin-options">
    <h1>Modifica Prodotti</h1>
    <div class="product-list">
      <table class="table">
        <thead>
        <tr>
          <th>ID</th>
          <th>Nome</th>
          <th>Fornitore</th>
          <th>Prezzo</th>
          <th>Quantità Disponibile</th>
          <th>Marca</th>
          <th>Categoria</th>
          <th>Immagine</th>
          <th>Modifica</th>
        </tr>
        </thead>
        <tbody>
        <%
          Connection conn = null;
          PreparedStatement ps = null;
          ResultSet rs = null;
          try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");

            String query = "SELECT * FROM prodotti";
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
        %>
        <tr>
          <td><%= rs.getInt("id") %></td>
          <td><%= rs.getString("nome") %></td>
          <td><%= rs.getString("fornitore") %></td>
          <td><%= rs.getBigDecimal("prezzo") %></td>
          <td><%= rs.getInt("quantità_disponibile") %></td>
          <td><%= rs.getString("marca") %></td>
          <td><%= rs.getString("categoria") %></td>
          <td>
            <%
              byte[] imgData = rs.getBytes("immagine");
              if (imgData != null && imgData.length > 0) {
                String base64Image = java.util.Base64.getEncoder().encodeToString(imgData);
                out.println("<img src='data:image/jpeg;base64," + base64Image + "' width='100'/>");
              }
            %>
          </td>
          <td><a href="editProductForm.jsp?id=<%= rs.getInt("id") %>" class="btn-edit">Modifica</a></td>
        </tr>
        <%
            }
          } catch (Exception e) {
            e.printStackTrace();
          } finally {
            try {
              if (rs != null) rs.close();
              if (ps != null) ps.close();
              if (conn != null) conn.close();
            } catch (SQLException e) {
              e.printStackTrace();
            }
          }
        %>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>
