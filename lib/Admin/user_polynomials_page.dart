import 'package:flutter/material.dart';
import '../services/api_service_polynome.dart';

class UserPolynomialsPage extends StatefulWidget {
  final int userId;
  final String username;

  const UserPolynomialsPage({required this.userId, required this.username, Key? key}) : super(key: key);

  @override
  _UserPolynomialsPageState createState() => _UserPolynomialsPageState();
}

String _formatRoots(dynamic roots) {
  if (roots is List) {
    return roots.join(", "); // Si roots est une liste, join les éléments
  } else if (roots is String) {
    return roots; // Si roots est une chaîne, renvoyer directement
  } else {
    return "Aucune racine trouvée"; // Valeur par défaut si null ou autre
  }
}

class _UserPolynomialsPageState extends State<UserPolynomialsPage> {
  final ApiService apiService = ApiService();
  bool isLoading = true;
  List<dynamic> polynomials = [];
  String error = "";

  @override
  void initState() {
    super.initState();
    _fetchPolynomials();
  }

  Future<void> _fetchPolynomials() async {
    try {
      final data = await apiService.getPolynomialsByUser(widget.userId);
      setState(() {
        polynomials = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
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
        child: Column(
          children: [
            // AppBar customisée
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Polynômes de ${widget.username}",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.white))
                  : error.isNotEmpty
                      ? Center(
                          child: Text(
                            "Erreur : $error",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      : polynomials.isEmpty
                          ? Center(
                              child: Text(
                                "Aucun polynôme trouvé pour cet utilisateur.",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              itemCount: polynomials.length,
                              padding: EdgeInsets.all(12),
                              itemBuilder: (context, index) {
                                final poly = polynomials[index];
                                return Card(
                                  elevation: 8,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(16),
                                    title: Text(
                                      "Expression Simplifiée",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Factorisée : ${poly['factoredExpression']}",
                                            style: TextStyle(fontSize: 14, color: Colors.black87),
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            "Racines : ${_formatRoots(poly['roots'])}",
                                            style: TextStyle(fontSize: 14, color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      child: Icon(Icons.functions, color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
