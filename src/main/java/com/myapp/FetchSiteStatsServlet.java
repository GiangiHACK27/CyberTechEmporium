package com.myapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

@WebServlet("/fetchSiteStats")
public class FetchSiteStatsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        try {
            // Recupera le statistiche necessarie dal database
            Map<String, Object> stats = fetchSiteStatistics();

            // Converte il map in formato JSON e lo invia alla pagina JSP
            String jsonStats = gson.toJson(stats);
            out.print(jsonStats);
            out.flush();
        } catch (SQLException e) {
            e.printStackTrace();
            // Gestione degli errori nel caso di problemi con il database
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private Map<String, Object> fetchSiteStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtils.getConnection();

            // Query per recuperare le statistiche
            String queryUsers = "SELECT COUNT(*) AS totalUsers FROM utenti";
            String querySales = "SELECT SUM(prezzo_totale) AS totalSales FROM ordini";
            String queryProductsCountByCategory = "SELECT categoria, COUNT(*) AS count FROM prodotti GROUP BY categoria";
            String queryAverageCredit = "SELECT AVG(credito) AS averageCredit FROM utenti";

            // Esegui le query per le statistiche
            pstmt = conn.prepareStatement(queryUsers);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("totalUsers", rs.getInt("totalUsers"));
            }

            pstmt = conn.prepareStatement(querySales);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                BigDecimal totalSales = rs.getBigDecimal("totalSales");
                if (totalSales == null) {
                    totalSales = BigDecimal.ZERO;
                }
                stats.put("totalSales", totalSales);
            }

            pstmt = conn.prepareStatement(queryProductsCountByCategory);
            rs = pstmt.executeQuery();
            Map<String, Integer> categoryCounts = new HashMap<>();
            while (rs.next()) {
                categoryCounts.put(rs.getString("categoria"), rs.getInt("count"));
            }
            stats.put("categoryCounts", categoryCounts);

            pstmt = conn.prepareStatement(queryAverageCredit);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                BigDecimal averageCredit = rs.getBigDecimal("averageCredit");
                if (averageCredit == null) {
                    averageCredit = BigDecimal.ZERO;
                }
                stats.put("averageCredit", averageCredit);
            }

        } finally {
            // Chiudi tutte le risorse
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return stats;
    }
}
