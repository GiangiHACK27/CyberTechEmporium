<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myapp.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRuolo().equals("admin")) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestione Sito</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="css/adminOptions.css">
    <link rel="stylesheet" href="css/navbar.css">
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

<div class="admin-options">
    <h1>Gestione Sito</h1>
    <a href="addProduct.jsp"><i class="fa fa-plus"></i> Aggiungi un Prodotto</a>
    <a href="viewUsers.jsp"><i class="fa fa-users"></i> Visualizza Utenti</a>
    <a href="viewOrders.jsp"><i class="fa fa-list-alt"></i> Visualizza Ordini</a>
    <a href="editProduct.jsp"><i class="fa fa-edit"></i> Modifica Prodotto</a>
    <a href="discountCodes.jsp"><i class="fa fa-percentage"></i> Codici Sconto</a>
    <a href="siteStats.jsp"><i class="fa fa-chart-line"></i> Statistiche Sito</a>
    <a href="magazzino.jsp"><i class="fa fa-warehouse"></i> Magazzino</a>
</div>

</body>
</html>
