import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://192.168.1.102:8082"; // Changez l'URL si nécessaire

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
   Future<String> registerCalculator({
    required String username,
    required String email,
    required String password,
    required String telephone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/calculators/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'telephone': telephone,
      }),
    );

    if (response.statusCode == 201) {
      return "Inscription réussie. Veuillez vérifier votre e-mail.";
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
 Future<String> forgotPassword({required String email}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/calculators/forgot-password?email=$email'), // Ajout de email en tant que paramètre d'URL
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return "Un e-mail avec votre nouveau mot de passe a été envoyé.";
  } else {
    throw Exception(jsonDecode(response.body)['message']);
  }
}

}



