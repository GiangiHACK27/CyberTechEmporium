<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    // Connessione al database e verifica delle credenziali
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
        PreparedStatement ps = con.prepareStatement("SELECT * FROM utenti WHERE email=? AND password=?");
        ps.setString(1, email);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            // Autenticazione riuscita, imposta l'utente e il ruolo nella sessione
            session.setAttribute("user", email); // Utilizzo diretto dell'oggetto session esistente
            String role = rs.getString("ruolo");
            session.setAttribute("userRole", role);
            response.sendRedirect("index.jsp");
        } else {
            // Credenziali non valide, reindirizza alla pagina di login con un messaggio di errore
            response.sendRedirect("login.jsp?error=invalid_credentials");
        }
        con.close();
    } catch (Exception e) {
        out.println(e);
    }
%>
