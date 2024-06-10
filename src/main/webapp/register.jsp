<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - CyberTech Emporium</title>
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

        .register-form {
            background-color: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            width: 350px;
            text-align: center;
            position: relative; /* Aggiunto posizionamento relativo per l'elemento padre */
        }

        .register-form h1 {
            font-size: 32px;
            color: #333;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: center;
        }

        .form-group label {
            font-size: 18px;
            color: #333;
            margin-bottom: 5px;
            display: block;
            text-align: center;
        }

        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="password"] {
            width: calc(100% - 24px);
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
            color: #333;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
            margin: 0 auto;
        }

        .form-group input[type="text"]:focus,
        .form-group input[type="email"]:focus,
        .form-group input[type="password"]:focus {
            border-color: #007bff;
        }

        .form-group button {
            width: calc(100% - 24px);
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 12px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            transition: background-color 0.3s ease;
            box-sizing: border-box;
            margin: 0 auto;
            display: block;
            margin-top: 20px;
        }

        .form-group button:hover {
            background-color: #0056b3;
        }

        .footer {
            position: absolute;
            bottom: 10px;
            left: 0;
            right: 0;
            text-align: center;
            width: 100%;
            color: #ccc;
        }
    </style>
</head>
<body>

<div class="register-form">
    <h1>CyberTech Emporium Register</h1>
    <form action="registerProcess.jsp" method="POST">
        <div class="form-group">
            <label for="nome">Nome</label>
            <input type="text" id="nome" name="nome" required>
        </div>
        <div class="form-group">
            <label for="cognome">Cognome</label>
            <input type="text" id="cognome" name="cognome" required>
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="form-group">
            <label for="nickname">Nickname</label>
            <input type="text" id="nickname" name="nickname" required>
        </div>
        <button type="submit">Register</button>
        <hr>
    </form>
</div>

<div class="footer">

    <p><br>&copy; 2024 CyberTech Emporium. All rights reserved.</p>
    <hr>
</div>

</body>
</html>
