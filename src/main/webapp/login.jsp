<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CyberTech Emporium</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f0f0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-form {
            background-color: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            width: 350px;
            text-align: center;
        }

        .login-form h1 {
            font-size: 32px;
            color: #333;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: center; /* Centra gli input */
        }

        .form-group label {
            font-size: 18px;
            color: #333;
            margin-bottom: 5px;
            display: block;
            text-align: center; /* Centra gli input */
        }

        .form-group input[type="email"],
        .form-group input[type="password"] {
            width: calc(100% - 24px); /* Larghezza del campo meno il padding */
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
            color: #333;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s ease;
            box-sizing: border-box; /* Include il padding nella larghezza totale */
            margin: 0 auto; /* Centra gli input */
        }

        .form-group input[type="email"]:focus,
        .form-group input[type="password"]:focus {
            border-color: #007bff;
        }

        .form-group button {
            width: calc(100% - 24px); /* Larghezza del bottone meno il padding */
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 12px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            transition: background-color 0.3s ease;
            box-sizing: border-box; /* Include il padding nella larghezza totale */
            margin: 0 auto; /* Centra il pulsante */
            display: block;
            margin-top: 20px; /* Spazio sopra il pulsante */
        }

        .form-group button:hover {
            background-color: #0056b3;
        }

        .footer {
            position: absolute;
            bottom: 10px;
            left: 50%;
            transform: translateX(-50%);
            text-align: center;
            width: 100%;
            color: #ccc;
        }
    </style>
</head>
<body>

<div class="login-form">
    <h1>Login - CyberTech Emporium</h1>
    <form action="loginProcess.jsp" method="POST">
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="submit">Accedi</button>
    </form>
</div>

<div class="footer">
    <p>&copy; 2024 CyberTech Emporium. All rights reserved.</p>
</div>

</body>
</html>
