import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

Future<List<dynamic>> getAllCalculators() async {
  final String url = "http://192.168.137.217:8082/api/calculators";

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Erreur lors du chargement des calculateurs");
  }
}

Future<void> deleteCalculator(int id) async {
  final String url = "http://192.168.137.217:8082/api/calculators/$id"; // URL correcte

  final response = await http.delete(Uri.parse(url));
  if (response.statusCode != 200) {
    throw Exception("Erreur lors de la suppression");
  }
}
Future<void> updateCalculator(int id, String username, String email, String telephone) async {
  final String url = "http://192.168.137.217:8082/api/calculators/$id"; // URL correcte

  final response = await http.put(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'email': email,
      'telephone': telephone,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception("Erreur lors de la mise à jour du calculateur");
  }
}

}