import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'polynomial_solver_screen.dart'; // Page de destination après une connexion réussie
import 'package:flutter/material.dart';
import 'reset_password_page.dart'; // Import de la page de réinitialisation
import 'signup_page.dart'; // Import de la page d'inscription

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String message = '';

  // Fonction de connexion
  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        message = "Veuillez entrer un nom d'utilisateur et un mot de passe.";
      });
      return;
    }

    final url = Uri.parse('http://192.168.1.107:8082/api/calculators/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        message = "Connexion réussie !";
      });

      // Naviguer vers la page d'accueil ou la page de destination après la connexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PolynomialSolverScreen()),
      );
    } else {
      setState(() {
        message = "Nom d'utilisateur ou mot de passe incorrect.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connexion"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nom d\'utilisateur',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Se connecter"),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Redirige vers la page de réinitialisation du mot de passe
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                );
              },
              child: Text("Mot de passe oublié ?"),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Redirige vers la page d'inscription
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: Text("S'inscrire"),
            ),
            if (message.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ]
          ],
        ),
      ),
    );
  }
}