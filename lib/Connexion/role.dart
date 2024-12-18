import 'package:flutter/material.dart';

class RolePage extends StatelessWidget {
  final String role;

  RolePage({required this.role});

  @override
  Widget build(BuildContext context) {
    String message;
    if (role == "Calculator") {
      message = "Hello Calculator!";
    } else if (role == "Admin") {
      message = "Hello Admin!";
    } else {
      message = "Hello User!";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
