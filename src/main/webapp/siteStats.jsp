<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myapp.User" %>
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
    <title>Gestione Sito - Statistiche</title>
    <!-- Includi Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="css/siteStats.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <h1>Statistiche del Sito</h1>

    <!-- Grafico utenti iscritti -->
    <div class="chart-container">
        <canvas id="userChart" class="chart"></canvas>
    </div>

    <!-- Grafico vendite totali -->
    <div class="chart-container">
        <canvas id="salesChart" class="chart"></canvas>
    </div>

    <!-- Grafico categorie di prodotti -->
    <div class="chart-container">
        <canvas id="categoryChart" class="chart"></canvas>
    </div>

    <!-- Grafico credito medio per utente -->
    <div class="chart-container">
        <canvas id="averageCreditChart" class="chart"></canvas>
    </div>

    <!-- Grafico statistiche ordini -->
    <div class="chart-container">
        <canvas id="orderStatsChart" class="chart"></canvas>
    </div>
</div>

<!-- Script per recuperare e visualizzare i dati con Chart.js -->
<script>
    // Funzione per recuperare i dati dal servlet e creare i grafici
    function fetchSiteStats() {
        fetch('fetchSiteStats') // Chiamata al servlet per recuperare i dati
            .then(response => response.json())
            .then(data => {
                console.log(data); // Controlla i dati ricevuti nel console log

                // Grafico utenti iscritti
                var userCtx = document.getElementById('userChart').getContext('2d');
                var userChart = new Chart(userCtx, {
                    type: 'bar',
                    data: {
                        labels: ['Utenti Iscritti'],
                        datasets: [{
                            label: 'Numero di Utenti',
                            data: [data.totalUsers],
                            backgroundColor: '#007bff'
                        }]
                    },
                    options: {
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    stepSize: 1
                                }
                            }
                        },
                        plugins: {
                            animation: {
                                duration: 2000,
                                easing: 'easeInOutQuart'
                            }
                        }
                    }
                });

                // Grafico vendite totali
                var salesCtx = document.getElementById('salesChart').getContext('2d');
                var salesChart = new Chart(salesCtx, {
                    type: 'line',
                    data: {
                        labels: ['Vendite Totali'],
                        datasets: [{
                            label: 'Ammontare delle Vendite',
                            data: [data.totalSales],
                            borderColor: '#28a745',
                            fill: false
                        }]
                    },
                    options: {
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        },
                        plugins: {
                            animation: {
                                duration: 2000,
                                easing: 'easeInOutQuart'
                            }
                        }
                    }
                });

                // Grafico categorie di prodotti
                var categoryCtx = document.getElementById('categoryChart').getContext('2d');
                var categoryChart = new Chart(categoryCtx, {
                    type: 'doughnut',
                    data: {
                        labels: Object.keys(data.categoryCounts),
                        datasets: [{
                            label: 'Numero di Prodotti per Categoria',
                            data: Object.values(data.categoryCounts),
                            backgroundColor: ['#007bff', '#28a745', '#ffc107', '#dc3545', '#17a2b8', '#6610f2']
                        }]
                    },
                    options: {
                        plugins: {
                            animation: {
                                duration: 1500,
                                easing: 'easeInOutQuart'
                            }
                        }
                    }
                });

                // Grafico credito medio per utente
                var averageCreditCtx = document.getElementById('averageCreditChart').getContext('2d');
                var averageCreditChart = new Chart(averageCreditCtx, {
                    type: 'bar',
                    data: {
                        labels: ['Credito Medio per Utente'],
                        datasets: [{
                            label: 'Credito Medio',
                            data: [data.averageCredit],
                            backgroundColor: '#ff5733'
                        }]
                    },
                    options: {
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        },
                        plugins: {
                            animation: {
                                duration: 2000,
                                easing: 'easeInOutQuart'
                            }
                        }
                    }
                });

                // Grafico statistiche ordini
                var orderStatsCtx = document.getElementById('orderStatsChart').getContext('2d');
                var orderStatsChart = new Chart(orderStatsCtx, {
                    type: 'bar',
                    data: {
                        labels: ['Numero Totale Ordini'],
                        datasets: [{
                            label: 'Numero di Ordini',
                            data: [data.totalOrders],
                            backgroundColor: '#007bff'
                        }]
                    },
                    options: {
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    stepSize: 1
                                }
                            }
                        },
                        plugins: {
                            animation: {
                                duration: 2000,
                                easing: 'easeInOutQuart'
                            }
                        }
                    }
                });

            })
            .catch(error => {
                console.error('Errore durante il recupero dei dati:', error);
                // Gestione degli errori, ad esempio visualizzare un messaggio di errore
            });
    }

    // Chiamata alla funzione al caricamento della pagina
    document.addEventListener('DOMContentLoaded', fetchSiteStats);
</script>
<div class="footer">
    <p>&copy; 2024 CyberTech Emporium. All rights reserved.</p>
</div>
</body>
</html>
