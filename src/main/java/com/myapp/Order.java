package com.myapp;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Order {
    private int id;
    private int userId;
    private LocalDate date;
    private BigDecimal total;

    public Order(int id, int userId, LocalDate date, BigDecimal total) {
        this.id = id;
        this.userId = userId;
        this.date = date;
        this.total = total;
    }

    public int getId() {
        return id;
    }

    public int getUserId() {
        return userId;
    }

    public LocalDate getDate() {
        return date;
    }

    public BigDecimal getTotal() {
        return total;
    }
}
