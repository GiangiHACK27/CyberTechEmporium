<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrello</title>
    <link rel="stylesheet" href="css/cart.css"> <!-- Nuovo CSS per il carrello -->
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <h1>Il tuo carrello</h1>
    <table>
        <thead>
        <tr>
            <th>Prodotto</th>
            <th>Prezzo</th>
            <th>Quantità</th>
            <th>Subtotale</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${sessionScope.cart}">
            <tr>
                <td>${item.name}</td>
                <td>${item.price}</td>
                <td>1</td> <!-- Placeholder per la quantità -->
                <td>${item.price}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
