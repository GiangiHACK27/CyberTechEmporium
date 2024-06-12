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
        <style>
            body {
                font-family: 'Roboto', sans-serif;
                margin: 0;
                padding: 0;
            }

            /* Includiamo il file CSS */
            <%@ include file="style.css" %>

            /* Carosello */
            .carousel {
                width: 80%;
                margin: auto;
                max-height: 400px; /* Limitiamo l'altezza del carosello */
            }
            .carousel img {
                width: auto;
                height: 400px;
                object-fit: contain; /* Manteniamo le proporzioni delle immagini */
                margin: 0 auto; /* Centriamo le immagini */
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
                height: 400px; /* Impostiamo l'altezza del carosello */
                transition: opacity 0.5s ease-in-out;
                text-align: center; /* Centriamo le immagini */
            }


            .carousel-item.active {
                display: block;
                position: relative;
                opacity: 1;
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

            /* Prodotti e offerte */
            .products .product img {
                width: 100%;
                height: auto;
            }

            /* Brand logos */
            .brands {
                display: flex;
                align-items: center;
                justify-content: space-around; /* Distribuiamo equamente le icone */
                padding: 20px;
                white-space: nowrap;
                flex-wrap: wrap;
            }
            .brands h2 {
                width: 100%;
                text-align: center;
                margin-bottom: 20px;
            }
            .brands .brand-icon {
                font-size: 60px;
                margin: 20px;
                color: #333;
                transition: color 0.3s ease, transform 0.3s ease;
                animation: bounce 2s infinite;
                flex: 1; /* Le icone occupano tutto lo spazio disponibile */
            }
            .brands .brand-icon:hover {
                color: #0073e6;
                transform: scale(1.2);
            }
            @keyframes bounce {
                0%, 20%, 50%, 80%, 100% {
                    transform: translateY(0);
                }
                40% {
                    transform: translateY(-10px);
                }
                60% {
                    transform: translateY(-5px);
                }
            }

            /* Modifica della scritta principale */
            .header h1 {
                font-size: 48px; /* Aumentiamo la dimensione del testo */
                text-align: center; /* Centriamo il testo */
            }

            .header h1 .cyber {
                color: #0073e6; /* Colore del testo per "CyberTech" */
                font-weight: bold; /* Rendiamo il testo più evidente */
                animation: neon-glow 1s infinite alternate; /* Aggiungiamo un'animazione neon */
            }

            .header h1 .emporium {
                color: #333; /* Colore del testo per "Emporium" */
                text-decoration: underline; /* Aggiungiamo una sottolineatura */
            }

            @keyframes neon-glow {
                from {
                    text-shadow: 0 0 10px #fff, 0 0 20px #fff, 0 0 30px #0073e6, 0 0 40px #0073e6, 0 0 70px #0073e6, 0 0 80px #0073e6, 0 0 100px #0073e6, 0 0 150px #0073e6;
                }
                to {
                    text-shadow: 0 0 5px #fff, 0 0 10px #fff, 0 0 15px #0073e6, 0 0 20px #0073e6, 0 0 35px #0073e6, 0 0 40px #0073e6, 0 0 50px #0073e6, 0 0 75px #0073e6;
                }
            }
        </style>
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
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT id, nome, prezzo FROM Prodotti");
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
