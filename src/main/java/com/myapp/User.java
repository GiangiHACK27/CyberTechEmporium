package com.myapp;

public class User {
    private int id;
    private String nome;
    private String cognome;
    private String email;
    private String ruolo;
    private String nickname;
    private int credito;

    // Costruttore con parametri id, email e ruolo
    public User(int id, String email, String ruolo) {
        this.id = id;
        this.email = email;
        this.ruolo = ruolo;
    }

    // Getters e setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getCognome() { return cognome; }
    public void setCognome(String cognome) { this.cognome = cognome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRuolo() { return ruolo; }
    public void setRuolo(String ruolo) { this.ruolo = ruolo; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public int getCredito() { return credito; }
    public void setCredito(int credito) { this.credito = credito; }
}
