import 'package:flutter/material.dart';
import 'package:srishti/features/auth/presentation/screens/auth_screen.dart';

class SrishtiApp extends StatelessWidget {
  const SrishtiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Srishti AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: const Color(0xff0a0a0a),
        // Use the new Satoshi font for the base theme.
        fontFamily: 'Satoshi',
        textTheme: const TextTheme(
          // Example of using a specific font for headlines
          headlineLarge: TextStyle(fontFamily: 'ClashDisplay', fontWeight: FontWeight.bold),
          // Other text styles will inherit Satoshi
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white70,
          error: Colors.redAccent,
        )
      ),
      home: const AuthScreen(),
    );
  }
}