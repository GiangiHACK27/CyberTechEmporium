<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Account</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f4f4f4;
    }
    .container {
      max-width: 600px;
      margin: 20px auto;
      background-color: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }
    h2 {
      color: #333;
    }
    form {
      margin-top: 20px;
    }
    label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
      color: #007bff; /* Cambio del colore del testo in azzurro elettrico */
      text-align: center; /* Centra il testo all'interno del label */
    }
    input[type="text"],
    input[type="email"],
    input[type="password"] {
      width: calc(100% - 22px); /* Sottrai il padding */
      padding: 10px;
      margin-bottom: 10px;
      border: 1px solid #ccc;
      border-radius: 5px;
    }
    input[type="submit"],
    .confirm-btn {
      background-color: #007bff;
      color: #fff;
      border: none;
      padding: 10px 20px;
      border-radius: 5px;
      cursor: pointer;
      margin-top: 10px;
      display: block;
      margin: 0 auto; /* Centra il bottone orizzontalmente */
    }
    input[type="submit"]:hover,
    .confirm-btn:hover {
      background-color: #0056b3;
    }
    .confirm-btn-container {
      display: none;
    }
  </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
  <%
    String username = (String) session.getAttribute("user");

    if (username == null) {
      response.sendRedirect("login.jsp");
      return;
    }

    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
      PreparedStatement ps = con.prepareStatement("SELECT * FROM utenti WHERE email = ?");
      ps.setString(1, username);
      ResultSet rs = ps.executeQuery();

      if (rs.next()) {
  %>
  <h2>Account Details</h2>
  <form id="updateForm" action="updateUser.jsp" method="post">
    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
    <label for="username">Username</label> <!-- Campo Username -->
    <input type="text" id="username" name="username" value="<%= rs.getString("nickname") %>"><br>
    <label for="email">Email</label> <!-- Campo Email -->
    <input type="email" id="email" name="email" value="<%= rs.getString("email") %>"><br>
    <label for="password">Nuova Password</label> <!-- Campo Nuova Password -->
    <input type="password" id="password" name="password" value=""><br>
    <label for="nome">Nome</label> <!-- Campo Nome -->
    <input type="text" id="nome" name="nome" value="<%= rs.getString("nome") %>"><br>
    <label for="cognome">Cognome</label> <!-- Campo Cognome -->
    <input type="text" id="cognome" name="cognome" value="<%= rs.getString("cognome") %>"><br>
    <input type="submit" value="Update" id="updateBtn">
    <div class="confirm-btn-container">
      <button class="confirm-btn">Conferma Modifiche</button>
    </div>
  </form>

  <div id="message" style="display:none;"></div>
  <%  }
    con.close();
  } catch (Exception e) {
    out.println(e);
  }
  %>
</div>
<script>
  document.getElementById("updateForm").addEventListener("submit", function(event) {
    event.preventDefault();
    document.querySelector('.confirm-btn-container').style.display = 'block';
  });

  document.querySelector('.confirm-btn').addEventListener('click', function() {
    document.getElementById('updateForm').submit();
  });
</script>
</body>
</html>
