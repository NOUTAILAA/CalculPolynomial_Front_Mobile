import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(PolynomialSolverApp());

class PolynomialSolverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polynomial Solver',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.blueGrey,
        ),
        fontFamily: 'Roboto',
      ),
      home: PolynomialSolverScreen(),
    );
  }
}

class PolynomialSolverScreen extends StatefulWidget {
  @override
  _PolynomialSolverScreenState createState() => _PolynomialSolverScreenState();
}

class _PolynomialSolverScreenState extends State<PolynomialSolverScreen> {
  final TextEditingController _expressionController = TextEditingController();
  final TextEditingController _variableController = TextEditingController(text: 'x'); // Valeur par défaut 'x'

  String simplifiedExpression = '';
  String factoredExpression = '';
  List<String> roots = [];
  String errorMessage = '';

  void _solvePolynomial() async {
    final expression = _expressionController.text.trim();
    final variable = _variableController.text.trim().isEmpty
        ? 'x' // Utiliser 'x' si aucune variable n'est saisie
        : _variableController.text.trim();

    if (expression.isEmpty) {
      setState(() {
        errorMessage = 'Veuillez entrer une expression.';
      });
      return;
    }

    final url = Uri.parse('http://10.0.2.2:5000/process_polynomial'); // IP locale pour Android Emulator
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'expression': expression, 'variable': variable}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          simplifiedExpression = data['simplifiedExpression'];
          factoredExpression = data['factoredExpression'];
          roots = List<String>.from(data['roots']);
          errorMessage = '';
        });
      } else {
        setState(() {
          errorMessage = 'Erreur lors du traitement.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur réseau : $e';
      });
    }
  }

  void _clearFields() {
    setState(() {
      _expressionController.clear();
      _variableController.text = 'x'; // Réinitialise à 'x'
      simplifiedExpression = '';
      factoredExpression = '';
      roots = [];
      errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polynomial Solver'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _variableController,
              decoration: InputDecoration(
                labelText: 'Variable (par défaut : x)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _expressionController,
              decoration: InputDecoration(
                labelText: 'Expression polynomiale',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _solvePolynomial,
                    child: Text('Calculer'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: Text('Effacer'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            if (simplifiedExpression.isNotEmpty) ...[
              _buildResultCard('Simplified Expression', simplifiedExpression),
              _buildResultCard('Factored Expression', factoredExpression),
              _buildResultCard('Racines', roots.join('\n')),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String content) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
