import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void _resetPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.forgotPassword(
        email: emailController.text,
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
                  // Icône et Titre
                  Icon(
                    Icons.lock_reset_rounded,
                    size: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Mot de passe oublié",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Formulaire stylisé
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
                            controller: emailController,
                            label: "Email",
                            icon: Icons.email_outlined,
                          ),
                          SizedBox(height: 24),
                          isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _resetPassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Réinitialiser le mot de passe",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),

                  // Bouton Retour
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Retour au Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
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
  }) {
    return TextField(
      controller: controller,
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
