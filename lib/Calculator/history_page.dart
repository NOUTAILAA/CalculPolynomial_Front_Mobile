import 'package:flutter/material.dart';
import '../services/api_service_polynome.dart';

class HistoryPage extends StatefulWidget {
  final String userId;

  const HistoryPage({required this.userId, Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ApiService apiService = ApiService();
  bool isLoading = true;
  List<Map<String, dynamic>> history = [];
  String error = "";

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    try {
      List<Map<String, dynamic>> fetchedHistory =
          await apiService.fetchPolynomialHistory(widget.userId);

      setState(() {
        history = fetchedHistory;
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
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Historique des Calculs",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (error.isNotEmpty)
            Center(child: Text("Erreur : $error"))
          else if (history.isEmpty)
            const Center(child: Text("Aucun historique trouvé."))
          else
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.history, color: Colors.deepPurpleAccent),
                      title: Text("Expression : ${item['simplifiedExpression']}"),
                      subtitle: Text("Racines : ${item['roots']}"),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
