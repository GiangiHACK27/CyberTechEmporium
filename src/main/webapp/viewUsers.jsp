<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.myapp.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRuolo().equals("admin")) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visualizza Utenti</title>
    <link rel="stylesheet" href="css/viewUsers.css">
    <link rel="stylesheet" href="css/navbar.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="container">
    <h2>Visualizza Utenti</h2>
    <!-- Form di ricerca -->
    <form method="get" action="viewUsers.jsp">
        <label for="searchName">Nome:</label>
        <input type="text" id="searchName" name="searchName" placeholder="Cerca per nome">
        <label for="searchCognome">Cognome:</label>
        <input type="text" id="searchCognome" name="searchCognome" placeholder="Cerca per cognome">
        <input type="submit" value="Cerca">
    </form>

    <%
        String searchName = request.getParameter("searchName");
        String searchCognome = request.getParameter("searchCognome");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
            Statement stmt = con.createStatement();

            String query = "SELECT * FROM utenti WHERE 1=1";
            if (searchName != null && !searchName.isEmpty()) {
                query += " AND nome LIKE '%" + searchName + "%'";
            }
            if (searchCognome != null && !searchCognome.isEmpty()) {
                query += " AND cognome LIKE '%" + searchCognome + "%'";
            }

            ResultSet rs = stmt.executeQuery(query);

            while (rs.next()) {
    %>
    <div class="user">
        <p>Username: <%= rs.getString("nickname") %></p>
        <p>Email: <%= rs.getString("email") %></p>
        <p>Nome: <%= rs.getString("nome") %></p>
        <p>Cognome: <%= rs.getString("cognome") %></p>
        <p>Ruolo: <%= rs.getString("ruolo") %></p>
        <button class="edit-btn" data-id="<%= rs.getInt("id") %>"
                data-username="<%= rs.getString("nickname") %>"
                data-email="<%= rs.getString("email") %>"
                data-nome="<%= rs.getString("nome") %>"
                data-cognome="<%= rs.getString("cognome") %>"
                data-ruolo="<%= rs.getString("ruolo") %>">Modifica</button>
    </div>
    <%
            }
            con.close();
        } catch (Exception e) {
            out.println(e);
        }
    %>

    <div id="editFormContainer">
        <h2>Modifica Utente</h2>
        <form id="editForm" action="updateUser" method="post">
            <input type="hidden" name="id" id="editId">
            <label for="editUsername">Username</label>
            <input type="text" id="editUsername" name="username"><br>
            <label for="editEmail">Email</label>
            <input type="email" id="editEmail" name="email"><br>
            <label for="editNome">Nome</label>
            <input type="text" id="editNome" name="nome"><br>
            <label for="editCognome">Cognome</label>
            <input type="text" id="editCognome" name="cognome"><br>
            <label for="editRuolo">Ruolo</label>
            <select id="editRuolo" name="ruolo">
                <option value="utente">Utente</option>
                <option value="admin">Admin</option>
            </select><br>
            <input type="submit" value="Salva">
        </form>
    </div>
</div>

<script>
    document.querySelectorAll('.edit-btn').forEach(button => {
        button.addEventListener('click', function() {
            document.getElementById('editId').value = this.dataset.id;
            document.getElementById('editUsername').value = this.dataset.username;
            document.getElementById('editEmail').value = this.dataset.email;
            document.getElementById('editNome').value = this.dataset.nome;
            document.getElementById('editCognome').value = this.dataset.cognome;
            document.getElementById('editRuolo').value = this.dataset.ruolo;
            document.getElementById('editFormContainer').style.display = 'block';
        });
    });
</script>

</body>
</html>
