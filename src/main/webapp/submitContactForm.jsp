<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, javax.mail.*, javax.mail.internet.*, javax.activation.*, java.io.*" %>
<%@ include file="navbar.jsp" %>

<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String message = request.getParameter("message");

    String to = "gianlucafusco15@gmail.com";  // Destinatario
    String from = email;  // Mittente
    String host = "smtp.gmail.com";
    String username = "gianlucafusco15@gmail.com"; // Username SMTP
    String password = "nxyc bhnk ylac zaac";
    String port = "587";

    // Impostazioni delle proprietà per il server SMTP
    Properties properties = new Properties();
    properties.put("mail.smtp.host", host);
    properties.put("mail.smtp.port", port);
    properties.put("mail.smtp.auth", "true");
    properties.put("mail.smtp.starttls.enable", "true");

    // Ottieni la sessione di posta
    Session mailSession = Session.getInstance(properties, new javax.mail.Authenticator() {
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(username, password);
        }
    });

    try {
        // Crea un oggetto MimeMessage
        MimeMessage mimeMessage = new MimeMessage(mailSession);

        // Imposta l'indirizzo del mittente
        mimeMessage.setFrom(new InternetAddress(from));

        // Imposta l'indirizzo del destinatario
        mimeMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

        // Imposta l'oggetto del messaggio
        mimeMessage.setSubject("MESSAGGIO CYBERTECH EMPORIUM - " + name);

        // Imposta il corpo del messaggio
        mimeMessage.setText("Nome: " + name + "\nEmail: " + email + "\n\nMessaggio:\n" + message);

        // Invia il messaggio
        Transport.send(mimeMessage);

        out.println("<h2>Grazie per averci contattato, " + name + ". Abbiamo ricevuto il tuo messaggio.</h2>");
    } catch (MessagingException mex) {
        mex.printStackTrace();
        out.println("<h2>Spiacenti, si è verificato un errore durante l'invio del tuo messaggio. Per favore riprova più tardi.</h2>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Contact Us</h1>
    </div>

    <div class="content">
        <!-- Il contenuto generato dinamicamente dal blocco JSP sopra -->
    </div>

    <div class="footer">
        <p>&copy; 2024 CyberTech Emporium. All rights reserved.</p>
    </div>
</div>
</body>
</html>
