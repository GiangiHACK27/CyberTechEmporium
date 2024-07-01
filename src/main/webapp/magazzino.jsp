<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.myapp.DatabaseUtils, com.myapp.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRuolo().equals("admin")) {
        response.sendRedirect("index.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List<Map<String, Object>> products = new ArrayList<>();

    try {
        conn = DatabaseUtils.getConnection();
        String sql = "SELECT nome, quantità_disponibile FROM prodotti";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> product = new HashMap<>();
            product.put("nome", rs.getString("nome"));
            product.put("quantità_disponibile", rs.getInt("quantità_disponibile"));
            products.add(product);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Magazzino</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="css/magazzino.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <h1>Magazzino</h1>
    <input type="text" id="searchBar" class="search-bar" onkeyup="searchProducts()" placeholder="Cerca prodotti...">
    <table id="productsTable">
        <thead>
        <tr>
            <th>Nome Prodotto</th>
            <th>Quantità Disponibile</th>
        </tr>
        </thead>
        <tbody>
        <% for (Map<String, Object> product : products) { %>
        <tr class="<%= (int) product.get("quantità_disponibile") < 10 ? "low-stock" : (int) product.get("quantità_disponibile") <= 20 ? "medium-stock" : "high-stock" %>">
            <td><%= (int) product.get("quantità_disponibile") == 0 ? "<strike>" + product.get("nome") + "</strike>" : product.get("nome") %></td>
            <td><%= (int) product.get("quantità_disponibile") == 0 ? "Non disponibile" : product.get("quantità_disponibile") %></td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
<div class="footer">
    <p>&copy; 2024 CyberTech Emporium. All rights reserved.</p>
</div>

<script>
    function searchProducts() {
        let input = document.getElementById('searchBar').value.toLowerCase();
        let table = document.getElementById('productsTable');
        let tr = table.getElementsByTagName('tr');

        for (let i = 1; i < tr.length; i++) {
            let td = tr[i].getElementsByTagName('td')[0];
            if (td) {
                let txtValue = td.textContent || td.innerText;
                if (txtValue.toLowerCase().indexOf(input) > -1) {
                    tr[i].style.display = '';
                } else {
                    tr[i].style.display = 'none';
                }
            }
        }
    }
</script>

</body>
</html>
