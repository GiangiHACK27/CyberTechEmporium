<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*, java.math.BigDecimal, java.io.InputStream" %>
<%@ page import="javax.servlet.http.Part" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifica Prodotto</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="css/adminOptions.css">
    <link rel="stylesheet" href="css/editProduct.css">
    <style>
        .btn-submit,
        .btn-delete {
            margin-top: 10px;
            padding: 10px;
            cursor: pointer;
            border: none;
            border-radius: 5px;
            background-color: #4CAF50;
            color: white;
        }

        .btn-delete {
            background-color: #f44336;
        }

        .btn-submit:hover,
        .btn-delete:hover {
            opacity: 0.8;
        }
    </style>
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

<div class="container">
    <div class="admin-options">
        <h1>Modifica Prodotto</h1>

            <%
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                out.println("<p class='error-message'>Errore: ID prodotto non fornito.</p>");
            } else {
                int productId = Integer.parseInt(idParam);
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    // Caricamento del driver JDBC e connessione al database
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");

                    // Recupero dei dati del prodotto
                    String selectQuery = "SELECT * FROM prodotti WHERE id = ?";
                    ps = conn.prepareStatement(selectQuery);
                    ps.setInt(1, productId);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        String nome = rs.getString("nome");
                        String fornitore = rs.getString("fornitore");
                        BigDecimal prezzo = rs.getBigDecimal("prezzo");
                        int quantita = rs.getInt("quantità_disponibile");
                        String marca = rs.getString("marca");
                        String categoria = rs.getString("categoria");
                        boolean hasImage = rs.getBinaryStream("immagine") != null;
        %>
        <form action="updateProduct" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= productId %>">
            <input type="hidden" name="hasImage" value="<%= hasImage %>">
            <div class="form-group">
                <label for="nome">Nome</label>
                <input type="text" id="nome" name="nome" value="<%= nome %>" required>
            </div>
            <div class="form-group">
                <label for="fornitore">Fornitore</label>
                <input type="text" id="fornitore" name="fornitore" value="<%= fornitore %>" required>
            </div>
            <div class="form-group">
                <label for="prezzo">Prezzo</label>
                <input type="number" id="prezzo" name="prezzo" step="0.01" value="<%= prezzo %>" required>
            </div>
            <div class="form-group">
                <label for="quantita">Quantità Disponibile</label>
                <input type="number" id="quantita" name="quantita" value="<%= quantita %>" required>
            </div>
            <div class="form-group">
                <label for="marca">Marca</label>
                <input type="text" id="marca" name="marca" value="<%= marca %>" required>
            </div>
            <div class="form-group">
                <label for="categoria">Categoria</label>
                <input type="text" id="categoria" name="categoria" value="<%= categoria %>" required>
            </div>
            <div class="form-group">
                <label for="immagine">Immagine</label>
                <input type="file" id="immagine" name="immagine" accept="image/*">
                <% if (hasImage) { %>
                <img src="getImage?id=<%= productId %>" alt="Product Image" style="max-width: 200px;">
                <input type="hidden" name="hasExistingImage" value="true">
                <% } %>
            </div>
            <button type="submit" class="btn-submit" name="action" value="update">Aggiorna</button>
            <button type="submit" class="btn-delete" name="action" value="delete" onclick="return confirm('Sei sicuro di voler eliminare questo prodotto?');">Elimina</button>
        </form>
        <% } else {
            out.println("<p class='error-message'>Prodotto non trovato.</p>");
        }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<p class='error-message'>Errore: Impossibile trovare il driver JDBC.</p>");
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p class='error-message'>Errore nella connessione al database.</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
        }
        %>
    </div>
</div>
</body>
</html>
