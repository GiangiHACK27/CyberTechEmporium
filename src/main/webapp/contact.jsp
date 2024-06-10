<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="navbar.jsp" %> <!-- Includiamo la barra di navigazione -->


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Contact Us</h1>
    </div>

    <div class="content">
        <div class="contact-info">
            <h2>Contact Information</h2>
            <p>RIMANIAMO A DISPOSIZIONE PER TUTTI I NOSTRI CLIENTI contact below:</p>
            <ul>
                <li><i class="fas fa-envelope"></i> Email: g.fusco28@studenti.unisa.it</li>
                <li><i class="fas fa-phone"></i> Phone: +39 3283098458</li>
                <li><i class="fas fa-map-marker-alt"></i> Address: Università degli Studi di Salerno</li>
            </ul>
        </div>

        <div class="contact-form">
            <h2>Contact Form</h2>
            <form action="submitContactForm.jsp" method="post">
                <div class="form-group">
                    <label for="name"><i class="fas fa-user"></i> Name:</label>
                    <input type="text" id="name" name="name" required>
                </div>

                <div class="form-group">
                    <label for="email"><i class="fas fa-envelope"></i> Email:</label>
                    <input type="email" id="email" name="email" required>
                </div>

                <div class="form-group">
                    <label for="message"><i class="fas fa-comment"></i> Message:</label><br>
                    <textarea id="message" name="message" rows="4" cols="50" required></textarea>
                </div>

                <button type="submit" class="btn-submit"><i class="fas fa-paper-plane"></i> Submit</button>
            </form>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2024 CyberTech Emporium. All rights reserved.</p>
    </div>
</div>
</body>
</html>
