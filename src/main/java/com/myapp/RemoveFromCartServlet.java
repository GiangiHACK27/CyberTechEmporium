package com.myapp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Iterator;

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        int productId = Integer.parseInt(request.getParameter("productId"));

        Iterator<CartItem> iterator = cart.iterator();
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            if (item.getProductId() == productId) {
                iterator.remove();
                break;
            }
        }

        session.setAttribute("cart", cart);

        // Restituisce il nuovo HTML per i bottoni del carrello
        response.setContentType("text/html");
        response.getWriter().write("<form id=\"cartForm_" + productId + "\" onsubmit=\"addToCart(event, " + productId + ")\">"
                + "<input type=\"hidden\" name=\"productId\" value=\"" + productId + "\">"
                + "<button id=\"addBtn_" + productId + "\" type=\"submit\" class=\"add-to-cart-btn\">Aggiungi al carrello</button>"
                + "</form>");
    }
}
