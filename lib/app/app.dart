import 'package:flutter/material.dart';
// Note: flutter_riverpod and google_fonts are no longer imported
// as per your latest code.

import 'package:srishti/presentation/screens/auth_gate.dart';
// If IDEScreen is still part of your application flow, ensure its
// WebViewController is properly initialized when it is rendered.

class SrishtiApp extends StatelessWidget {
  const SrishtiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: ProviderScope has been removed as flutter_riverpod is no longer used.
    return MaterialApp(
      title: 'Srishti',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: const Color(0xff0a0a0a),
        // Setting custom font family directly. Ensure 'Satoshi' is
        // correctly declared in your pubspec.yaml if it's a custom font.
        fontFamily: 'Satoshi',
        textTheme: const TextTheme(
          // Setting custom font family for headlineLarge. Ensure 'ClashDisplay' is
          // correctly declared in your pubspec.yaml if it's a custom font.
          headlineLarge: TextStyle(fontFamily: 'ClashDisplay', fontWeight: FontWeight.bold),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white70,
          error: Colors.redAccent,
        )
      ),
      // Home is now set to AuthGate, which will handle authentication flow.
      home: const AuthGate(),
    );
  }
}
