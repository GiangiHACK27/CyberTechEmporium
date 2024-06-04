<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Navbar</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #121212;
            color: #fff;
        }

        .navbar {
            background-color: #1f1f1f;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            padding: 10px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar a {
            color: #ffffff;
            text-decoration: none;
            margin: 0 10px;
            position: relative;
            padding: 14px 20px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .navbar a:hover {
            background-color: #0073e6;
            color: #fff;
        }

        .navbar-right {
            display: flex;
            align-items: center;
        }

        .navbar-right a {
            color: #fff;
            text-decoration: none;
            margin: 0 10px;
            position: relative;
            padding: 14px 20px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .navbar-right a:hover {
            background-color: #0073e6;
            color: #fff;
        }

        .navbar a i,
        .navbar-right a i {
            margin-right: 5px;
            transition: transform 0.3s ease;
        }

        .navbar a:hover i,
        .navbar-right a:hover i {
            transform: rotate(360deg);
        }
    </style>
</head>
<body>
<div class="navbar">
    <a href="home.jsp"><i class="fa fa-home"></i> Home</a>
    <a href="products.jsp"><i class="fa fa-box-open"></i> Products</a>
    <a href="about.jsp"><i class="fa fa-info-circle"></i> About Us</a>
    <a href="contact.jsp"><i class="fa fa-envelope"></i> Contact</a>
    <div class="navbar-right">
        <!-- Link per il login/registrazione o l'accesso all'account -->
        <a href="login.jsp"><i class="fa fa-user"></i> Login</a>
        <a href="register.jsp"><i class="fa fa-user-plus"></i> Register</a>
        <!-- Oppure, se l'utente è già loggato, mostra l'accesso all'account -->
        <!-- <a href="#"><i class="fa fa-user-circle"></i> Account</a> -->
        <a href="cart.jsp"><i class="fa fa-shopping-cart"></i> Cart</a>
    </div>
</div>
</body>
</html>
