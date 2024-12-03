import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  String message = '';

  void _signup() async {
  final email = _emailController.text;
  final username = _usernameController.text;
  final password = _passwordController.text;
  final telephone = _telephoneController.text;
  final department = _departmentController.text;

  if (email.isEmpty || username.isEmpty || password.isEmpty || telephone.isEmpty || department.isEmpty) {
    setState(() {
      message = "Veuillez remplir tous les champs.";
    });
    return;
  }

  final url = Uri.parse('http://192.168.1.107:8082/api/users/register');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
        'telephone': telephone,
        'department': department,
        'isCalculator': true, // Champ pour indiquer que c'est un Calculator
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        message = "Inscription réussie ! Veuillez vérifier votre email.";
      });
    } else {
      final responseBody = jsonDecode(response.body);
      setState(() {
        message = "Erreur lors de l'inscription : ${responseBody['message'] ?? 'Inconnue'}";
      });
    }
  } catch (e) {
    setState(() {
      message = "Erreur de connexion au serveur : $e";
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("S'inscrire comme Calculateur"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mot de passe'),
            ),
            TextField(
              controller: _telephoneController,
              decoration: InputDecoration(labelText: 'Téléphone'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _departmentController,
              decoration: InputDecoration(labelText: 'Département'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: Text("S'inscrire"),
            ),
            if (message.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(
                  color: message.startsWith("Erreur") ? Colors.red : Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
