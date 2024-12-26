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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.indigo],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Titre et Logo
                  Icon(
                    Icons.app_registration,
                    size: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Inscription Calculator",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Formulaire stylisé dans une carte
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: usernameController,
                            label: "Nom d'utilisateur",
                            icon: Icons.person,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            controller: emailController,
                            label: "Email",
                            icon: Icons.email,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            controller: passwordController,
                            label: "Mot de passe",
                            icon: Icons.lock,
                            obscureText: true,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            controller: telephoneController,
                            label: "Téléphone",
                            icon: Icons.phone,
                          ),
                          SizedBox(height: 24),
                          isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _registerCalculator,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "S'inscrire",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Revenir au Login",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepPurpleAccent),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurpleAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
