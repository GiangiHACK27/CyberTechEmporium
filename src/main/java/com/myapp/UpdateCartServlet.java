package com.myapp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/UpdateCartServlet")
public class UpdateCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        int productId = Integer.parseInt(request.getParameter("productId"));
        String action = request.getParameter("action");

        for (CartItem item : cart) {
            if (item.getProductId() == productId) {
                if ("plus".equals(action)) {
                    item.setQuantity(item.getQuantity() + 1);
                } else if ("minus".equals(action) && item.getQuantity() > 1) {
                    item.setQuantity(item.getQuantity() - 1);
                }
                break;
            }
        }

        session.setAttribute("cart", cart);

        // Restituisce il nuovo HTML per i bottoni del carrello
        int quantity = 1;
        for (CartItem item : cart) {
            if (item.getProductId() == productId) {
                quantity = item.getQuantity();
                break;
            }
        }
        response.setContentType("text/html");
        response.getWriter().write("<span onclick=\"updateCartQuantity(" + productId + ", 'minus')\" class=\"quantity-action\"><i class=\"fas fa-minus-circle\"></i></span>"
                + "<input id=\"quantity_" + productId + "\" type=\"text\" value=\"" + quantity + "\" readonly>"
                + "<span onclick=\"updateCartQuantity(" + productId + ", 'plus')\" class=\"quantity-action\"><i class=\"fas fa-plus-circle\"></i></span>"
                + "<span onclick=\"removeFromCart(" + productId + ")\" class=\"remove-from-cart\"><i class=\"fas fa-trash-alt\"></i></span>");
    }
}
