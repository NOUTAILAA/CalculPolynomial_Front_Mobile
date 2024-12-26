import 'package:flutter/material.dart';
import '../services/api_service_admin.dart';
import './user_polynomials_page.dart';

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
      _fetchCalculators();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
  }

  Future<void> _editCalculator(
      int id, String currentUsername, String currentEmail, String currentPhone) async {
    TextEditingController usernameController =
        TextEditingController(text: currentUsername);
    TextEditingController emailController =
        TextEditingController(text: currentEmail);
    TextEditingController phoneController =
        TextEditingController(text: currentPhone);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modifier le Calculateur"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(
                    controller: usernameController,
                    label: "Nom d'utilisateur",
                    icon: Icons.person),
                SizedBox(height: 10),
                _buildTextField(
                    controller: emailController,
                    label: "Email",
                    icon: Icons.email),
                SizedBox(height: 10),
                _buildTextField(
                    controller: phoneController,
                    label: "Téléphone",
                    icon: Icons.phone),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await apiService.updateCalculator(
                    id,
                    usernameController.text,
                    emailController.text,
                    phoneController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calculateur mis à jour avec succès')),
                  );
                  Navigator.pop(context);
                  _fetchCalculators();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur : ${e.toString()}')),
                  );
                }
              },
              child: Text("Enregistrer"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
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
            AppBar(
              title: const Text(
                "Gestion des Calculateurs",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.white))
                  : error.isNotEmpty
                      ? Center(
                          child: Text("Erreur : $error",
                              style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          itemCount: calculators.length,
                          itemBuilder: (context, index) {
                            final calculator = calculators[index];
                            return Card(
                              elevation: 6,
                              margin:
                                  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  child: Text(
                                    calculator['username']
                                        .toString()
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                title: Text(
                                  calculator['username'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                                subtitle: Text(
                                  "Email: ${calculator['email']}\nTéléphone: ${calculator['telephone'] ?? 'N/A'}",
                                  style: TextStyle(fontSize: 12),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _editCalculator(
                                        calculator['id'],
                                        calculator['username'],
                                        calculator['email'],
                                        calculator['telephone'] ?? "",
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () =>
                                          _deleteCalculator(calculator['id']),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.visibility,
                                          color: Colors.green),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserPolynomialsPage(
                                              userId: calculator['id'],
                                              username: calculator['username'],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
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
