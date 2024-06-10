<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*" %>
<%
    // Rimuovi l'attributo di sessione relativo all'utente
    session.removeAttribute("user");
    // Reindirizza alla pagina di login o a un'altra pagina appropriata
    response.sendRedirect("index.jsp");
%>
