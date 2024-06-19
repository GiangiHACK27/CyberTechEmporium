package com.myapp;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/updateCartQuantity")
public class UpdateCartQuantityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        int productId = Integer.parseInt(request.getParameter("productId"));
        int newQuantity = Integer.parseInt(request.getParameter("newQuantity"));

        // Trova l'elemento nel carrello
        for (CartItem item : cart) {
            if (item.getProductId() == productId) {
                // Aggiorna la quantità
                item.setQuantity(newQuantity);

                // Calcola il subtotale per questo elemento
                BigDecimal subtotal = item.getPrice().multiply(BigDecimal.valueOf(newQuantity));

                // Calcola il totale del carrello
                BigDecimal total = BigDecimal.ZERO;
                for (CartItem cartItem : cart) {
                    total = total.add(cartItem.getPrice().multiply(BigDecimal.valueOf(cartItem.getQuantity())));
                }

                // Aggiorna il carrello nella sessione
                session.setAttribute("cart", cart);

                // Prepara la risposta JSON
                String jsonResponse = "{\"status\":\"success\", \"subtotal\":\"" + subtotal + "\", \"total\":\"" + total + "\", \"quantity\":\"" + newQuantity + "\"}";

                // Invia la risposta JSON
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(jsonResponse);
                return;
            }
        }

        // Se l'elemento non è stato trovato nel carrello
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"status\":\"error\"}");
    }
}
