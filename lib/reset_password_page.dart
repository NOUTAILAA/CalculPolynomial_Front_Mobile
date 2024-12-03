import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  String message = '';

  void _resetPassword() async {
    final email = _emailController.text;

    if (email.isEmpty) {
      setState(() {
        message = "Veuillez entrer votre adresse e-mail.";
      });
      return;
    }

    final url = Uri.parse('http://192.168.1.107:8082/api/calculators/forgot-password?email=$email');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        message = "Un e-mail avec votre nouveau mot de passe a été envoyé.";
      });
    } else {
      setState(() {
        message = "Erreur lors de la réinitialisation du mot de passe.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Réinitialiser le mot de passe"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Entrez votre e-mail',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text("Réinitialiser le mot de passe"),
            ),
            if (message.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
