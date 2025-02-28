package com.myapp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        int productId = Integer.parseInt(request.getParameter("productId"));
        String productName = request.getParameter("productName");
        BigDecimal productPrice = new BigDecimal(request.getParameter("productPrice"));
        String productDescription = request.getParameter("productDescription");
        String productImageUrl = request.getParameter("productImageUrl");

        boolean itemExists = false;
        for (CartItem item : cart) {
            if (item.getProductId() == productId) {
                itemExists = true;
                item.setQuantity(item.getQuantity() + 1);
                break;
            }
        }

        if (!itemExists) {
            CartItem newItem = new CartItem(productId, productName, productDescription, productPrice, productImageUrl, 1);
            cart.add(newItem);
        }

        session.setAttribute("cart", cart);

        // Restituisce il nuovo HTML per i bottoni del carrello
        response.setContentType("text/html");
        response.getWriter().write("<span onclick=\"updateCartQuantity(" + productId + ", 'minus')\" class=\"quantity-action\"><i class=\"fas fa-minus-circle\"></i></span>"
                + "<input id=\"quantity_" + productId + "\" type=\"text\" value=\"1\" readonly>"
                + "<span onclick=\"updateCartQuantity(" + productId + ", 'plus')\" class=\"quantity-action\"><i class=\"fas fa-plus-circle\"></i></span>"
                + "<span onclick=\"removeFromCart(" + productId + ")\" class=\"remove-from-cart\"><i class=\"fas fa-trash-alt\"></i></span>");
    }
}
