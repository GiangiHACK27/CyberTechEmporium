<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myapp.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Navbar</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="css/navbar.css">
</head>
<body>
<div class="navbar" id="navbar">
    <a href="index.jsp"><i class="fa fa-home"></i> Home</a>
    <a href="products.jsp"><i class="fa fa-box-open"></i> Products</a>
    <a href="orders.jsp"><i class="fa fa-file-invoice-dollar"></i> Ordini</a>
    <a href="aboutUs.jsp"><i class="fa fa-info-circle"></i> About Us</a>
    <a href="contact.jsp"><i class="fa fa-envelope"></i> Contact</a>

    <!-- Pulsante Gestione Sito per admin -->
    <%
        // Ottieni l'oggetto User dalla sessione
        User user = (User) session.getAttribute("user");
        // Inizializza isAdmin a false di default
        boolean isAdmin = false;
        // Verifica se l'utente è admin
        if (user != null && "admin".equals(user.getRuolo())) {
            isAdmin = true;
        }

        if (isAdmin) {
    %>
    <a href="adminOptions.jsp" class="admin-button"><i class="fa fa-cogs"></i> Gestione Sito</a>
    <% } %>

    <div class="navbar-right" id="navbarRight">
        <% if (user != null) { %>
        <a href="logout.jsp"><i class="fa fa-sign-out-alt"></i> Logout</a>
        <a href="user.jsp"><i class="fa fa-user"></i> Account</a>
        <% } else { %>
        <a href="login.jsp"><i class="fa fa-user"></i> Login</a>
        <a href="register.jsp"><i class="fa fa-user-plus"></i> Register</a>
        <% } %>
    </div>
    <a href="cart.jsp"><i class="fa fa-shopping-cart"></i> Cart</a>
</div>

</body>
</html>
