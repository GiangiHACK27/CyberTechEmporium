<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CyberTech Emporium</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="navbar.jsp" %> <!-- Includiamo la barra di navigazione -->
<div class="header">
    <h1>Welcome to CyberTech Emporium</h1>
</div>

<div class="carousel">
    <div class="carousel-inner">
        <%@ page import="java.sql.*" %>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT id, nome FROM Prodotti LIMIT 3");
                boolean first = true;
                while (rs.next()) {
                    String activeClass = first ? "active" : "";
                    first = false;
        %>
        <div class="carousel-item <%= activeClass %>">
            <img src="getImage?id=<%= rs.getInt("id") %>" alt="<%= rs.getString("nome") %>">
        </div>
        <%
                }
                con.close();
            } catch (Exception e) {
                out.println(e);
            }
        %>
    </div>
    <a class="carousel-control-prev" onclick="prevSlide()">&#10094;</a>
    <a class="carousel-control-next" onclick="nextSlide()">&#10095;</a>
</div>

<div class="section">
    <h2>Featured Products</h2>
    <div class="products">
        <%
            int count = 0;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT id, nome, prezzo FROM Prodotti LIMIT 4");
                while (rs.next()) {
                    if (count >= 4) break;
        %>
        <div class="product">
            <img src="getImage?id=<%= rs.getInt("id") %>" alt="<%= rs.getString("nome") %>">
            <h3><%= rs.getString("nome") %></h3>
            <p>$<%= rs.getString("prezzo") %></p>
        </div>
        <%
                    count++;
                }
                con.close();
            } catch (Exception e) {
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
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT id, nome, prezzo, categoria\n" +
                        "FROM (\n" +
                        "    SELECT id, nome, prezzo, categoria, ROW_NUMBER() OVER (PARTITION BY categoria ORDER BY prezzo) AS `rank`\n" +
                        "    FROM prodotti\n" +
                        ") AS ranked\n" +
                        "WHERE `rank` = 1");
                while (rs.next()) {
        %>
        <div class="product">
            <img src="getImage?id=<%= rs.getInt("id") %>" alt="<%= rs.getString("nome") %>">
            <h3><%= rs.getString("nome") %></h3>
            <p>$<%= rs.getString("prezzo") %></p>
        </div>
        <%
                }
                con.close();
            } catch (Exception e) {
                out.println(e);
            }
        %>
    </div>
</div>

<div class="brands">
    <h2>Our Brands</h2>
    <div class="brand-icons">
        <i class="fab fa-microsoft brand-icon"></i>
        <i class="fab fa-apple brand-icon"></i>
        <i class="fab fa-amazon brand-icon"></i>
        <i class="fab fa-google brand-icon"></i>
    </div>
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
        slideIndex = (slideIndex + 1) % slides.length;
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
