<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, com.myapp.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            int userId = rs.getInt("id");
            String role = rs.getString("ruolo");
            User user = new User(userId, email, role);  // Crea l'oggetto User
            session = request.getSession();
            session.setAttribute("user", user); // Salva l'oggetto User nella sessione
            session.setAttribute("userId", userId); // Salva l'ID utente nella sessione

            // Log per debugging
            System.out.println("Login successful for user: " + email + ", Role: " + role);

            // Verifica se l'utente è un admin
            boolean isAdmin = role.equals("admin");
            response.sendRedirect("index.jsp");
        } else {
            // Credenziali non valide, reindirizza alla pagina di login con un messaggio di errore
            response.sendRedirect("login.jsp?error=invalid_credentials");
        }
        con.close();
    } catch (Exception e) {
        // Gestione dell'eccezione, stampa l'errore
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=internal_error");
    }
%>
