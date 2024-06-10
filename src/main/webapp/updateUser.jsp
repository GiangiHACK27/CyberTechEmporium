<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String id = request.getParameter("id");
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String nome = request.getParameter("nome");
    String cognome = request.getParameter("cognome");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");

        PreparedStatement ps;
        if (password != null && !password.isEmpty()) {
            ps = con.prepareStatement("UPDATE utenti SET nickname=?, email=?, password=?, nome=?, cognome=? WHERE id=?");
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, nome);
            ps.setString(5, cognome);
            ps.setString(6, id);
        } else {
            ps = con.prepareStatement("UPDATE utenti SET nickname=?, email=?, nome=?, cognome=? WHERE id=?");
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, nome);
            ps.setString(4, cognome);
            ps.setString(5, id);
        }

        int result = ps.executeUpdate();
        if (result > 0) {
            out.println("<script>alert('Dati utente aggiornati con successo');</script>");
            response.sendRedirect("user.jsp");
        } else {
            out.println("<script>alert('Si è verificato un errore durante l'aggiornamento dei dati utente');</script>");
        }
        con.close();
    } catch (Exception e) {
        out.println(e);
    }
%>
