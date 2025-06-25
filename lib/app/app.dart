import 'package:flutter/material.dart';
import 'package:srishti/presentation/screens/auth_gate.dart';

class SrishtiApp extends StatelessWidget {
  const SrishtiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Srishti',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: const Color(0xff0a0a0a),
        fontFamily: 'Satoshi',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'ClashDisplay', fontWeight: FontWeight.bold),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white70,
          error: Colors.redAccent,
        )
      ),
      home: const AuthGate(),
    );
  }
}