<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Il tuo carrello</title>
    <link rel="stylesheet" href="css/cart.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            $('.quantity-control').on('click', '.quantity-minus', function() {
                var productId = $(this).data('product-id');
                var currentQuantity = parseInt($('#quantity_' + productId).val(), 10);
                if (currentQuantity > 1) {
                    updateQuantity(productId, currentQuantity - 1);
                }
            });

            $('.quantity-control').on('click', '.quantity-plus', function() {
                var productId = $(this).data('product-id');
                var currentQuantity = parseInt($('#quantity_' + productId).val(), 10);
                updateQuantity(productId, currentQuantity + 1);
            });

            function updateQuantity(productId, newQuantity) {
                $.ajax({
                    type: 'POST',
                    url: 'updateCartQuantity',
                    data: {
                        productId: productId,
                        newQuantity: newQuantity
                    },
                    success: function(response) {
                        $('#quantity_' + productId).val(response.quantity);
                        $('#subtotal_' + productId).text(response.subtotal);
                        $('#total').text(response.total);
                    },
                    error: function(xhr, status, error) {
                        alert('Errore durante l\'aggiornamento della quantità. Riprova più tardi.');
                    }
                });
            }

            $('.remove-btn').click(function() {
                var productId = $(this).data('product-id');
                removeFromCart(productId);
            });

            function removeFromCart(productId) {
                $.ajax({
                    type: 'POST',
                    url: 'removeFromCart',
                    data: {
                        productId: productId
                    },
                    success: function(response) {
                        $('#row_' + productId).remove();
                        $('#total').text(response.total);
                    },
                    error: function(xhr, status, error) {
                        alert('Errore durante la rimozione dal carrello. Riprova più tardi.');
                    }
                });
            }
        });
    </script>
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
            <th>Azioni</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${sessionScope.cart}">
            <tr id="row_${item.productId}">
                <td>${item.name}</td>
                <td>${item.price}</td>
                <td>
                    <div class="quantity-control">
                        <span class="quantity-minus" data-product-id="${item.productId}">-</span>
                        <input id="quantity_${item.productId}" class="quantity-input" type="text" value="${item.quantity}" readonly>
                        <span class="quantity-plus" data-product-id="${item.productId}">+</span>
                    </div>
                </td>
                <td id="subtotal_${item.productId}">
                        ${item.price * item.quantity}
                </td>
                <td>
                    <button class="remove-btn" data-product-id="${item.productId}">Rimuovi</button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <!-- Riquadro Codice Sconto -->
    <div class="discount-code">
        <label for="coupon">Codice sconto:</label>
        <input type="text" id="coupon" placeholder="Inserisci il codice">
        <button onclick="applyCoupon()">Applica</button>
    </div>

    <!-- Pulsante Checkout -->
    <c:if test="${not empty sessionScope.user}">
        <form action="checkout" method="post">
            <button type="submit" class="checkout-btn">Checkout</button>
        </form>
    </c:if>
    <c:if test="${empty sessionScope.user}">
        <p>Per procedere con il checkout, effettua il <a href="login.jsp">login</a>.</p>
    </c:if>

    <!-- Totale -->
    <div class="total">
        <label>Totale:</label>
        <span id="total">
            <c:forEach var="item" items="${sessionScope.cart}" varStatus="status">
                <c:set var="total" value="${total + item.price * item.quantity}" scope="page"/>
            </c:forEach>
            ${total}
        </span>
    </div>
</div>
</body>
</html>
