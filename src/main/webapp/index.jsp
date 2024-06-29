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
    <h2>Last Arrived</h2>
    <div class="products">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
                Statement stmt = con.createStatement();
                // Query per ottenere l'ultimo prodotto per categoria, limitato a 4 prodotti totali
                String query = "SELECT p.id, p.nome, p.prezzo, p.categoria " +
                        "FROM prodotti p " +
                        "JOIN (SELECT categoria, MAX(id) AS max_id FROM prodotti GROUP BY categoria) max_ids " +
                        "ON p.categoria = max_ids.categoria AND p.id = max_ids.max_id " +
                        "ORDER BY p.id DESC " +
                        "LIMIT 4";
                ResultSet rs = stmt.executeQuery(query);
                while (rs.next()) {
        %>
        <div class="product">
            <img src="getImage?id=<%= rs.getInt("id") %>" alt="<%= rs.getString("nome") %>">
            <h3><%= rs.getString("nome") %></h3>
            <p>$<%= rs.getString("prezzo") %> - <%= rs.getString("categoria") %></p>
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
