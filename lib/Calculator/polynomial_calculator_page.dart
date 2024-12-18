import 'package:flutter/material.dart';
import '../services/api_service_polynome.dart';

class PolynomialCalculatorPage extends StatefulWidget {
  final String userId;

  const PolynomialCalculatorPage({required this.userId, Key? key}) : super(key: key);

  @override
  _PolynomialCalculatorPageState createState() => _PolynomialCalculatorPageState();
}

class _PolynomialCalculatorPageState extends State<PolynomialCalculatorPage> {
  final TextEditingController expressionController = TextEditingController();
  final ApiService apiService = ApiService();

  bool isLoading = false;
  String result = "";

  void _calculate(String method) async {
    setState(() {
      isLoading = true;
      result = "";
    });

    try {
      Map<String, dynamic> response;

      if (method == "numpy") {
        response = await apiService.calculateWithNumpy(expressionController.text, widget.userId);
      } else if (method == "sympy") {
        response = await apiService.processPolynomialNew(expressionController.text, widget.userId);
      } else if (method == "newton") {
        response = await apiService.processPolynomial(expressionController.text, widget.userId);
      } else {
        throw Exception("Méthode inconnue.");
      }

      // Traitement des racines complexes
      List<String> roots = (response['roots'] as List<dynamic>).map<String>((root) {
        String rootStr = root.toString().replaceAll("*I", "i").replaceAll(" ", "");
        return rootStr;
      }).toList();

      setState(() {
        result = """
Racines : ${roots.join(", ")}
Expression simplifiée : ${response['simplifiedExpression']}
Expression factorisée : ${response['factoredExpression']}
      """;
      });
    } catch (error) {
      setState(() {
        result = "Erreur : ${error.toString()}";
      });
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: TextField(
                    controller: expressionController,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Entrez une expression polynomiale',
                      labelStyle: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
                      border: InputBorder.none,
                      icon: Icon(Icons.edit, color: Colors.deepPurpleAccent),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStyledButton("Numpy", Colors.pinkAccent, () => _calculate("numpy")),
                        _buildStyledButton("Sympy", Colors.orangeAccent, () => _calculate("sympy")),
                        _buildStyledButton("Newton-Raphson", Colors.greenAccent, () => _calculate("newton")),
                      ],
                    ),
              const SizedBox(height: 20),
              Expanded(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      result.isEmpty ? "Les résultats apparaîtront ici..." : result,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 6,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
