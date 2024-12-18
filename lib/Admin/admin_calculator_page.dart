import 'package:flutter/material.dart';
import '../services/api_service_admin.dart';

class AdminCalculatorPage extends StatefulWidget {
  @override
  _AdminCalculatorPageState createState() => _AdminCalculatorPageState();
}

class _AdminCalculatorPageState extends State<AdminCalculatorPage> {
  final ApiService apiService = ApiService();
  bool isLoading = true;
  List<dynamic> calculators = [];
  String error = "";

  @override
  void initState() {
    super.initState();
    _fetchCalculators();
  }

  Future<void> _fetchCalculators() async {
    try {
      final data = await apiService.getAllCalculators();
      setState(() {
        calculators = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _deleteCalculator(int id) async {
    try {
      await apiService.deleteCalculator(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Calculator supprimé avec succès')),
      );
      _fetchCalculators(); // Recharger les données
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Calculateurs"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text("Erreur : $error"))
              : ListView.builder(
                  itemCount: calculators.length,
                  itemBuilder: (context, index) {
                    final calculator = calculators[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(calculator['username']),
                        subtitle: Text("Email: ${calculator['email']}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCalculator(calculator['id']),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
