import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../Calculator/dashboard_page.dart'; // Page pour les calculators
import 'role.dart'; // Page pour d'autres rôles
import 'forgot_password_page.dart';
import 'register_calculator_page.dart';
import '../Admin/admin_calculator_page.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.login(
        emailController.text,
        passwordController.text,
      );

      final role = response['scope']; // Rôle de l'utilisateur
      final userId = response['userId']; // ID de l'utilisateur

      if (role == "CALCULATOR") {
        // Redirige vers la page de calcul de polynômes
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(userId: userId),
          ),
        );
      } else if (role == "ADMIN") {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AdminCalculatorPage(), // Redirection vers CRUD des calculateurs
    ),
  );
}else {
        // Redirige vers une page générique pour d'autres rôles
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RolePage(role: role),
          ),
        );
      }
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
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mot de passe'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Se connecter'),
                  ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Redirige vers une page d'inscription
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterCalculatorPage(),
                  ),
                );
              },
              child: Text('Créer un compte Calculator'),
            ),
            TextButton(
              onPressed: () {
                // Redirige vers une page de réinitialisation du mot de passe
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgotPasswordPage(),
                  ),
                );
              },
              child: Text('Mot de passe oublié ?'),
            ),
          ],
        ),
      ),
    );
  }
}
