
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:srishti/features/auth/presentation/screens/auth_screen.dart';

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
        // A modern, clean font choice.
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
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