<%@ page import="com.myapp.User" %>
<!DOCTYPE html>
<html lang="en">
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRuolo().equals("admin")) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aggiungi Prodotto</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="css/adminOptions.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/addProducts.css"> <!-- Aggiungi questa riga -->
</head>
<body>
<div class="navbar" id="navbar">
    <a href="index.jsp"><i class="fa fa-home"></i> Home</a>
    <a href="products.jsp"><i class="fa fa-box-open"></i> Products</a>
    <a href="orders.jsp"><i class="fa fa-file-invoice-dollar"></i> Ordini</a>
    <a href="about.jsp"><i class="fa fa-info-circle"></i> About Us</a>
    <a href="contact.jsp"><i class="fa fa-envelope"></i> Contact</a>

    <div class="navbar-right" id="navbarRight">
        <a href="logout.jsp"><i class="fa fa-sign-out-alt"></i> Logout</a>
        <a href="user.jsp"><i class="fa fa-user"></i> Account</a>
    </div>
    <a href="cart.jsp"><i class="fa fa-shopping-cart"></i> Cart</a>
</div>

<div class="admin-options">
    <h1>Aggiungi Prodotto</h1>
    <form action="addProduct" method="post" enctype="multipart/form-data">
        <label for="nome">Nome Prodotto:</label>
        <input type="text" id="nome" name="nome" required>

        <label for="fornitore">Fornitore:</label>
        <input type="text" id="fornitore" name="fornitore" required>

        <label for="prezzo">Prezzo:</label>
        <input type="number" id="prezzo" name="prezzo" step="0.01" required>

        <label for="quantità_disponibile">Quantità Disponibile:</label>
        <input type="number" id="quantità_disponibile" name="quantità_disponibile" required>

        <label for="marca">Marca:</label>
        <input type="text" id="marca" name="marca" required>

        <label for="immagine">Immagine:</label>
        <input type="file" id="immagine" name="immagine" accept="image/*" required>

        <label for="categoria">Categoria:</label>
        <input type="text" id="categoria" name="categoria" required>

        <button type="submit">Aggiungi Prodotto</button>
    </form>
</div>

</body>
</html>
