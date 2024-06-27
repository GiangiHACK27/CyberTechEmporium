<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*, java.math.BigDecimal, java.io.*, java.nio.file.Paths, java.nio.file.Files, java.util.Base64" %>
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

                    // Gestione delle richieste POST
                    if (request.getMethod().equalsIgnoreCase("post")) {
                        String action = request.getParameter("action");
                        if ("update".equals(action)) {
                            // Recupero dei parametri dal form
                            String nome = request.getParameter("nome");
                            String fornitore = request.getParameter("fornitore");
                            BigDecimal prezzo = new BigDecimal(request.getParameter("prezzo"));
                            int quantita = Integer.parseInt(request.getParameter("quantita"));
                            String marca = request.getParameter("marca");
                            String categoria = request.getParameter("categoria");

                            // Gestione del caricamento dell'immagine
                            String immagine = null;
                            Part filePart = request.getPart("immagine");
                            if (filePart != null && filePart.getSize() > 0) {
                                InputStream fileContent = filePart.getInputStream();
                                immagine = Base64.getEncoder().encodeToString(fileContent.readAllBytes());
                            }

                            // Aggiornamento del prodotto nel database
                            String updateQuery = "UPDATE prodotti SET nome = ?, fornitore = ?, prezzo = ?, quantità_disponibile = ?, marca = ?, categoria = ?, immagine = ? WHERE id = ?";
                            ps = conn.prepareStatement(updateQuery);
                            ps.setString(1, nome);
                            ps.setString(2, fornitore);
                            ps.setBigDecimal(3, prezzo);
                            ps.setInt(4, quantita);
                            ps.setString(5, marca);
                            ps.setString(6, categoria);
                            ps.setString(7, immagine);
                            ps.setInt(8, productId);

                            int rowsUpdated = ps.executeUpdate();
                            if (rowsUpdated > 0) {
                                out.println("<p class='success-message'>Prodotto aggiornato con successo.</p>");
                            } else {
                                out.println("<p class='error-message'>Errore nell'aggiornamento del prodotto.</p>");
                            }
                        } else if ("delete".equals(action)) {
                            // Eliminazione del prodotto dal database
                            String deleteDetailsQuery = "DELETE FROM dettagli_ordine WHERE id_prodotto = ?";
                            PreparedStatement psDeleteDetails = conn.prepareStatement(deleteDetailsQuery);
                            psDeleteDetails.setInt(1, productId);
                            int rowsDeletedDetails = psDeleteDetails.executeUpdate();
                            psDeleteDetails.close();

                            String deleteProductQuery = "DELETE FROM prodotti WHERE id = ?";
                            PreparedStatement psDeleteProduct = conn.prepareStatement(deleteProductQuery);
                            psDeleteProduct.setInt(1, productId);
                            int rowsDeletedProduct = psDeleteProduct.executeUpdate();
                            psDeleteProduct.close();

                            if (rowsDeletedProduct > 0) {
                                out.println("<p class='success-message'>Prodotto eliminato con successo.</p>");
                            } else {
                                out.println("<p class='error-message'>Errore nell'eliminazione del prodotto.</p>");
                            }
                        }
                    }

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
                        String immagine = rs.getString("immagine");

        %>
        <form action="editProductForm.jsp?id=<%= productId %>" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="nome">Nome</label>
                <input type="text" id="nome" name="nome" value="<%= nome %>">
            </div>
            <div class="form-group">
                <label for="fornitore">Fornitore</label>
                <input type="text" id="fornitore" name="fornitore" value="<%= fornitore %>">
            </div>
            <div class="form-group">
                <label for="prezzo">Prezzo</label>
                <input type="text" id="prezzo" name="prezzo" value="<%= prezzo %>">
            </div>
            <div class="form-group">
                <label for="quantita">Quantità Disponibile</label>
                <input type="text" id="quantita" name="quantita" value="<%= quantita %>">
            </div>
            <div class="form-group">
                <label for="marca">Marca</label>
                <input type="text" id="marca" name="marca" value="<%= marca %>">
            </div>
            <div class="form-group">
                <label for="categoria">Categoria</label>
                <input type="text" id="categoria" name="categoria" value="<%= categoria %>">
            </div>
            <div class="form-group">
                <label for="immagine">Immagine</label>
                <% if (immagine != null) { %>
                <img src="data:image/jpeg;base64,<%= immagine %>" width="100"/>
                <% } %>
                <input type="file" id="immagine" name="immagine">
            </div>
            <input type="hidden" name="action" value="update">
            <button type="submit" class="btn-submit">Aggiorna Prodotto</button>
        </form>
        <form action="editProductForm.jsp?id=<%= productId %>" method="post" onsubmit="return confirm('Sei sicuro di voler eliminare questo prodotto?');">
            <input type="hidden" name="action" value="delete">
            <button type="submit" class="btn-delete">Elimina Prodotto</button>
        </form>
        <%
                    } else {
                        out.println("<p class='error-message'>Prodotto non trovato.</p>");
                    }

                } catch (ClassNotFoundException | SQLException e) {
                    out.println("<p class='error-message'>Errore: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    // Chiusura delle risorse
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        out.println("<p class='error-message'>Errore SQL nella chiusura delle risorse: " + e.getMessage() + "</p>");
                        e.printStackTrace();
                    }
                }
            }
        %>
    </div>
</div>

</body>
</html>
