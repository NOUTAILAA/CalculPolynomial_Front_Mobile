import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrlNumpy = "http://10.0.2.2:5004/calculateWithNumpy";
  final String baseUrlNewton = "http://10.0.2.2:5001/process_polynomial_new";
  final String baseUrlSympy = "http://10.0.2.2:5110/process_polynomial";

  Future<Map<String, dynamic>> calculateWithNumpy(String expression, String userId) async {
    return await _postRequest(baseUrlNumpy, expression, userId);
  }

  Future<Map<String, dynamic>> processPolynomialNew(String expression, String userId) async {
    return await _postRequest(baseUrlSympy, expression, userId);
  }

  Future<Map<String, dynamic>> processPolynomial(String expression, String userId) async {
    return await _postRequest(baseUrlNewton, expression, userId);
  }

  Future<Map<String, dynamic>> _postRequest(String url, String expression, String userId) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'expression': expression,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? "Erreur inconnue.");
    }
  }



  Future<List<Map<String, dynamic>>> fetchPolynomialHistory(String userId) async {
  final String url = "http://192.168.137.217:8082/api/users/$userId/polynomials"; // Mettre à jour avec votre IP/port correct.

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.cast<Map<String, dynamic>>();
  } else if (response.statusCode == 204) {
    return []; // Aucun contenu
  } else {
    throw Exception("Erreur lors du chargement de l'historique");
  }
}
Future<List<dynamic>> getPolynomialsByUser(int userId) async {
  final String url = "http://192.168.137.217:8082/api/users/$userId/polynomials";

  final response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    return jsonDecode(response.body); // Retourne la liste des polynômes
  } else if (response.statusCode == 204) {
    return []; // Aucun contenu
  } else {
    throw Exception("Erreur lors de la récupération des polynômes de l'utilisateur");
  }
}

Future<http.Response> plotPolynomial(String expression) async {
  final String url = "http://10.0.2.2:5110/plot_polynomial";

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'expression': expression}),
  );

  if (response.statusCode == 200) {
    return response; // Retourne la réponse brute contenant l'image
  } else {
    throw Exception(jsonDecode(response.body)['error'] ?? "Erreur inconnue.");
  }
}

}
