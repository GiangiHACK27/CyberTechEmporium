<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, com.myapp.User" %>
<%
    String nome = request.getParameter("nome");
    String cognome = request.getParameter("cognome");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String nickname = request.getParameter("nickname");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");

        // Verifica se l'utente esiste già
        PreparedStatement checkExistingUser = con.prepareStatement("SELECT * FROM utenti WHERE email=?");
        checkExistingUser.setString(1, email);
        ResultSet existingUserResult = checkExistingUser.executeQuery();

        if (existingUserResult.next()) {
            // Utente già registrato, reindirizza con un messaggio di errore
            response.sendRedirect("register.jsp?error=user_exists");
        } else {
            // Inserisce il nuovo utente nel database
            PreparedStatement ps = con.prepareStatement("INSERT INTO utenti (nome, cognome, email, password, nickname, ruolo) VALUES (?, ?, ?, ?, ?, 'utente')");
            ps.setString(1, nome);
            ps.setString(2, cognome);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setString(5, nickname);
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                // Registrazione riuscita, reindirizza alla pagina di login
                response.sendRedirect("login.jsp");
            } else {
                // Errore durante la registrazione
                response.sendRedirect("register.jsp?error=registration_failed");
            }
        }

        con.close();
    } catch (Exception e) {
        out.println(e);
    }
%>
