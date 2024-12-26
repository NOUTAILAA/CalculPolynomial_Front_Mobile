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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage(userId: userId)),
        );
      } else if (role == "ADMIN") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminCalculatorPage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RolePage(role: role)),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.indigoAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Icon(
                    Icons.lock_outline,
                    size: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Connexion",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40),
                  // Formulaire dans une carte
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email, color: Colors.deepPurpleAccent),
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.deepPurpleAccent),
                              labelText: 'Mot de passe',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Se connecter',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Lien vers inscription et mot de passe oublié
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterCalculatorPage()),
                      );
                    },
                    child: Text(
                      "Créer un compte Calculator",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
