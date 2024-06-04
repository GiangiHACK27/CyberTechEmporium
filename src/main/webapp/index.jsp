<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CyberTech Emporium</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        <%@include file="style.css"%> <!-- Includiamo il file CSS -->
        .carousel img {
            width: 100%;
            height: auto;
        }

        .carousel-inner {
            position: relative;
            width: 100%;
            overflow: hidden;
        }

        .carousel-item {
            display: none;
            position: absolute;
            width: 100%;
            transition: opacity 0.5s ease-in-out;
        }

        .carousel-item.active {
            display: block;
            position: relative;
            opacity: 1;
        }

        .carousel-item img {
            display: block;
            width: 100%;
        }

        .carousel-control-prev, .carousel-control-next {
            position: absolute;
            top: 50%;
            width: auto;
            padding: 10px;
            transform: translateY(-50%);
            background-color: rgba(0,0,0,0.5);
            border-radius: 50%;
            cursor: pointer;
        }

        .carousel-control-prev {
            left: 10px;
        }

        .carousel-control-next {
            right: 10px;
        }

        .carousel-control-prev:hover, .carousel-control-next:hover {
            background-color: #0073e6;
        }

        .brands img {
            max-width: 200px;
            margin: 10px;
            filter: grayscale(100%);
            transition: filter 0.3s ease;
        }

        .brands img:hover {
            filter: grayscale(0%);
        }
    </style>
</head>
<body>
<%@include file="navbar.jsp"%> <!-- Includiamo la barra di navigazione -->
<div class="header">
    <h1>Welcome to CyberTech Emporium</h1>
</div>

<div class="carousel">
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="https://via.placeholder.com/1200x400?text=Tech+Product+1" alt="Tech Product 1">
        </div>
        <div class="carousel-item">
            <img src="https://via.placeholder.com/1200x400?text=Tech+Product+2" alt="Tech Product 2">
        </div>
        <div class="carousel-item">
            <img src="https://via.placeholder.com/1200x400?text=Tech+Product+3" alt="Tech Product 3">
        </div>
    </div>
    <a class="carousel-control-prev" onclick="prevSlide()">&#10094;</a>
    <a class="carousel-control-next" onclick="nextSlide()">&#10095;</a>
</div>

<div class="section">
    <h2>Featured Products</h2>
    <div class="products">
        <%@ page import="java.sql.*" %>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce","root","root");
                Statement stmt=con.createStatement();
                ResultSet rs=stmt.executeQuery("SELECT * FROM Prodotti");
                while(rs.next()) {
        %>
        <div class="product">
            <img src="<%= rs.getString("immagine") %>" alt="<%= rs.getString("nome") %>">
            <h3><%= rs.getString("nome") %></h3>
            <p>$<%= rs.getString("prezzo") %></p>
        </div>
        <%
                }
                con.close();
            } catch(Exception e) {
                out.println(e);
            }
        %>
    </div>
</div>

<div class="section">
    <h2>Special Offers</h2>
    <div class="products">
        <%-- Codice per mostrare offerte speciali --%>
        <%-- Esempio di implementazione: --%>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce","root","root");
                Statement stmt=con.createStatement();
                ResultSet rs=stmt.executeQuery("SELECT * FROM OfferteSpeciali");
                while(rs.next()) {
        %>
        <div class="product">
            <img src="<%= rs.getString("immagine") %>" alt="<%= rs.getString("nome") %>">
            <h3><%= rs.getString("nome") %></h3>
            <p>$<%= rs.getString("prezzo") %></p>
        </div>
        <%
                }
                con.close();
            } catch(Exception e) {
                out.println(e);
            }
        %>
    </div>
</div>

<div class="brands">
    <h2>Our Brands</h2>
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Microsoft_logo.svg/1200px-Microsoft_logo.svg.png" alt="Microsoft">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Apple-logo.png/640px-Apple-logo.png" alt="Apple">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Intel-logo.svg/1024px-Intel-logo.svg.png" alt="Intel">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/AMD_Logo.svg/1280px-AMD_Logo.svg.png" alt="AMD">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Google_Logo.svg/512px-Google_Logo.svg.png" alt="Google">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Logo-HP-2022.svg/1280px-Logo-HP-2022.svg.png" alt="HP">
</div>

<div class="footer">
    <p>&copy; 2024 CyberTech Emporium. All rights reserved.</p>
</div>

<script>
    let slideIndex = 0;
    const slides = document.getElementsByClassName("carousel-item");

    function showSlide(n) {
        for (let i = 0; i < slides.length; i++) {
            slides[i].style.display = "none";
            slides[i].classList.remove("active");
        }
        slides[n].style.display = "block";
        slides[n].classList.add("active");
    }

    function nextSlide() {
        slideIndex = (slideIndex +         1) % slides.length;
        showSlide(slideIndex);
    }

    function prevSlide() {
        slideIndex = (slideIndex - 1 + slides.length) % slides.length;
        showSlide(slideIndex);
    }

    showSlide(slideIndex);
    setInterval(nextSlide, 5000);
</script>
</body>
</html>
