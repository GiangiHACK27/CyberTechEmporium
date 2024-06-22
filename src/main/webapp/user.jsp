<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, java.sql.*, com.myapp.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Account</title>
  <link rel="stylesheet" href="css/navbar.css">
  <link rel="stylesheet" href="css/user.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
  <%
    // Ottieni l'oggetto User dalla sessione
    user = (User) session.getAttribute("user");

    // Verifica se l'utente è loggato
    if (user == null) {
      response.sendRedirect("login.jsp");
      return;
    }

    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
      PreparedStatement ps = con.prepareStatement("SELECT * FROM utenti WHERE email = ?");
      ps.setString(1, user.getEmail()); // Usa getEmail() per ottenere l'email dell'utente
      ResultSet rs = ps.executeQuery();

      if (rs.next()) {
  %>
  <h2>Account Details</h2>
  <form id="updateForm" action="updateUser" method="post">
    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
    <label for="username">Username</label>
    <input type="text" id="username" name="username" value="<%= rs.getString("nickname") %>"><br>
    <label for="email">Email</label>
    <input type="email" id="email" name="email" value="<%= rs.getString("email") %>"><br>
    <label for="password">Nuova Password</label>
    <input type="password" id="password" name="password" value=""><br>
    <label for="nome">Nome</label>
    <input type="text" id="nome" name="nome" value="<%= rs.getString("nome") %>"><br>
    <label for="cognome">Cognome</label>
    <input type="text" id="cognome" name="cognome" value="<%= rs.getString("cognome") %>"><br>
    <input type="submit" value="Update" id="updateBtn">
    <div class="confirm-btn-container">
      <button type="button" class="confirm-btn">Conferma Modifiche</button>
    </div>
  </form>

  <!-- Form per la ricarica del credito -->
  <div class="credit-recharge">
    <h2>Ricarica Credito</h2>
    <form id="rechargeForm" action="rechargeCredit.jsp" method="post">
      <label for="amount">Importo da Ricaricare</label>
      <input type="number" id="amount" name="amount" min="1" step="1" required>
      <input type="submit" value="Ricarica">
    </form>
  </div>

  <div id="message" style="display:none;"></div>
  <%
      }
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
