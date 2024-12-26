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
  String simplifiedExpression = "";
  String factoredExpression = "";
  List<String> roots = [];
  Image? graphImage;

  void _clearResults() {
    setState(() {
      simplifiedExpression = "";
      factoredExpression = "";
      roots = [];
      graphImage = null;
    });
  }

  void _calculate(String method) async {
    setState(() {
      isLoading = true;
      _clearResults();
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

      // Formatage des racines
      List<String> formattedRoots = (response['roots'] as List<dynamic>).map<String>((root) {
        String rootStr = root.toString().replaceAll("*I", "i").replaceAll(" ", "");
        return rootStr;
      }).toList();

      setState(() {
        simplifiedExpression = response['simplifiedExpression'];
        factoredExpression = response['factoredExpression'];
        roots = formattedRoots;
      });
    } catch (error) {
      setState(() {
        simplifiedExpression = "Erreur : ${error.toString()}";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _plotGraph() async {
    setState(() {
      isLoading = true;
      _clearResults();
    });

    try {
      final response = await apiService.plotPolynomial(expressionController.text);
      setState(() {
        graphImage = Image.memory(
          response.bodyBytes,
          fit: BoxFit.contain,
          width: double.infinity,
          height: 200,
        );
      });
    } catch (error) {
      setState(() {
        simplifiedExpression = "Erreur : ${error.toString()}";
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: TextField(
                      controller: expressionController,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        labelText: 'Entrez une expression polynomiale',
                        labelStyle: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                        icon: Icon(Icons.edit, color: Colors.deepPurpleAccent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (isLoading)
                  const Center(child: CircularProgressIndicator(color: Colors.white))
                else
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildStyledButton("Numpy", Colors.pinkAccent, () => _calculate("numpy")),
                      _buildStyledButton("Sympy", Colors.orangeAccent, () => _calculate("sympy")),
                      _buildStyledButton("Newton", Colors.greenAccent, () => _calculate("newton")),
                      _buildStyledButton("Courbe", Colors.blueAccent, _plotGraph),
                    ],
                  ),
                const SizedBox(height: 20),
                if (simplifiedExpression.isNotEmpty || factoredExpression.isNotEmpty || roots.isNotEmpty)
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (simplifiedExpression.isNotEmpty)
                            Text(
                              "Expression simplifiée : $simplifiedExpression",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                            ),
                          const SizedBox(height: 10),
                          if (factoredExpression.isNotEmpty)
                            Text(
                              "Expression factorisée : $factoredExpression",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                            ),
                          const SizedBox(height: 10),
                          if (roots.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Racines :",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                ...roots.map((root) => Text(
                                      "- $root",
                                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                                    )),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (graphImage != null)
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: graphImage!,
                    ),
                  ),
              ],
            ),
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
        fixedSize: const Size(120, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
