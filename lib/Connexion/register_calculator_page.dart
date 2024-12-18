import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterCalculatorPage extends StatefulWidget {
  @override
  _RegisterCalculatorPageState createState() => _RegisterCalculatorPageState();
}

class _RegisterCalculatorPageState extends State<RegisterCalculatorPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();

  bool isLoading = false;

  void _registerCalculator() async {
    setState(() {
      isLoading = true;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.registerCalculator(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        telephone: telephoneController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );

      Navigator.pop(context); // Retour à la page précédente
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mot de passe'),
            ),
            TextField(
              controller: telephoneController,
              decoration: InputDecoration(labelText: 'Téléphone'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _registerCalculator,
                    child: Text('S\'inscrire'),
                  ),
          ],
        ),
      ),
    );
  }
}
