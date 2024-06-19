<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrello</title>
    <link rel="stylesheet" href="css/cart.css"> <!-- Assicurati che il percorso al tuo file CSS sia corretto -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        var updating = false; // Flag per evitare più aggiornamenti simultanei

        function updateQuantity(productId, newQuantity) {
            if (updating) return; // Se già in fase di aggiornamento, esce senza fare nulla
            updating = true; // Imposta il flag a true per indicare l'avvio dell'aggiornamento

            $.ajax({
                type: 'POST',
                url: 'updateCartQuantity', // URL della servlet per l'aggiornamento della quantità
                data: {
                    productId: productId,
                    newQuantity: newQuantity
                },
                success: function(response) {
                    // Aggiorna la quantità e il subtotale senza ricaricare la pagina
                    var quantityElement = document.getElementById("quantity_" + productId);
                    var subtotalElement = document.getElementById("subtotal_" + productId);
                    var totalElement = document.getElementById("total");

                    quantityElement.value = response.quantity; // Aggiorna la quantità nel campo input
                    subtotalElement.innerText = response.subtotal; // Aggiorna il subtotale nel DOM
                    totalElement.innerText = response.total; // Aggiorna il totale nel DOM

                    updating = false; // Resetta il flag dopo aver completato l'aggiornamento
                },
                error: function(xhr, status, error) {
                    alert('Errore durante l\'aggiornamento della quantità. Riprova più tardi.');
                    updating = false; // Assicura che il flag sia resettato anche in caso di errore
                }
            });
        }

        function removeFromCart(productId) {
            if (updating) return; // Se già in fase di aggiornamento, esce senza fare nulla
            updating = true; // Imposta il flag a true per indicare l'avvio della rimozione

            $.ajax({
                type: 'POST',
                url: 'removeFromCart', // URL della servlet per rimuovere dal carrello
                data: {
                    productId: productId
                },
                success: function(response) {
                    // Rimuovi la riga dal DOM senza ricaricare la pagina
                    var rowToRemove = document.getElementById("row_" + productId);
                    rowToRemove.parentNode.removeChild(rowToRemove);
                    var totalElement = document.getElementById("total");
                    totalElement.innerText = response.total; // Aggiorna il totale nel DOM

                    updating = false; // Resetta il flag dopo aver completato la rimozione
                },
                error: function(xhr, status, error) {
                    alert('Errore durante la rimozione dal carrello. Riprova più tardi.');
                    updating = false; // Assicura che il flag sia resettato anche in caso di errore
                }
            });
        }
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
                        <span class="quantity-minus" onclick="updateQuantity(${item.productId}, ${item.quantity - 1})">-</span>
                        <input id="quantity_${item.productId}" type="text" value="${item.quantity}" readonly>
                        <span class="quantity-plus" onclick="updateQuantity(${item.productId}, ${item.quantity + 1})">+</span>
                    </div>
                </td>
                <td id="subtotal_${item.productId}">
                    <c:choose>
                        <c:when test="${item.price != null and item.quantity != null}">
                            <c:out value="${item.price.multiply(item.quantity)}" />
                        </c:when>
                        <c:otherwise>
                            0
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <button onclick="removeFromCart(${item.productId})">Rimuovi</button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <!-- Riquadro per il codice sconto -->
    <div class="discount-code">
        <label for="coupon">Codice sconto:</label>
        <input type="text" id="coupon" placeholder="Inserisci il codice">
        <button onclick="applyCoupon()">Applica</button>
    </div>

    <!-- Pulsante Checkout (accessibile solo se loggato) -->
    <c:if test="${not empty sessionScope.user}">
        <button class="checkout-btn">Checkout</button>
    </c:if>
    <c:if test="${empty sessionScope.user}">
        <p>Per procedere con il checkout, effettua il <a href="login.jsp">login</a>.</p>
    </c:if>

    <!-- Mostra il totale -->
    <div class="total">
        <label>Totale:</label>
        <span id="total">
            ${totalAmount} <!-- Assumi che totalAmount sia l'importo totale calcolato -->
        </span>
    </div>
</div>
</body>
</html>
