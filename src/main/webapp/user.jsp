<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>User Account</title>
</head>
<body>
<%@ include file="navbar.jsp" %>
<%
  String username = (String) session.getAttribute("user");

  if (username == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce", "root", "root");
    PreparedStatement ps = con.prepareStatement("SELECT * FROM Users WHERE username = ?");
    ps.setString(1, username);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
%>
<h2>Account Details</h2>
<p>Username: <%= rs.getString("username") %></p>
<p>Email: <%= rs.getString("email") %></p>
<%  }
  con.close();
} catch (Exception e) {
  out.println(e);
}
%>
</body>
</html>
