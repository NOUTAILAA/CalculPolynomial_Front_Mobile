import 'package:flutter/material.dart';
import 'auth_screen.dart';

void main() {
  runApp(PolynomialSolverApp());
}

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
      home: LoginPage(), // Changez ici pour AuthScreen
    );
  }
}
