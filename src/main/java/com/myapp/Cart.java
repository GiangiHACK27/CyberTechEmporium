package com.myapp;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Cart {
    private List<CartItem> items;

    public Cart() {
        items = new ArrayList<>();
    }

    public List<CartItem> getItems() {
        return items;
    }

    public void addItem(CartItem item) {
        items.add(item);
    }

    public void removeItem(int productId) {
        items.removeIf(item -> item.getProductId() == productId);
    }

    public void updateItemQuantity(int productId, int quantity) {
        for (CartItem item : items) {
            if (item.getProductId() == productId) {
                if (quantity <= 0) {
                    items.remove(item);
                } else {
                    item.setQuantity(quantity);
                }
                return;
            }
        }
    }

    public BigDecimal calculateTotal() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) {
            total = total.add(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
        }
        return total;
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public void clear() {
        items.clear();
    }

    public void applyDiscount(BigDecimal discountPercent) {
        BigDecimal multiplier = BigDecimal.ONE.subtract(discountPercent.divide(BigDecimal.valueOf(100)));
        for (CartItem item : items) {
            BigDecimal discountedPrice = item.getPrice().multiply(multiplier);
            item.setPrice(discountedPrice);
        }
    }
}
