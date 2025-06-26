// lib/presentation/screens/auth_gate.dart
import 'package:flutter/material.dart';
import 'package:srishti/presentation/screens/auth_screen.dart';
// CORRECTED: Import the new IDEScreen
import 'package:srishti/presentation/screens/ide_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.session != null) {
          // CORRECTED: Navigate to the IDEScreen after login
          return const IDEScreen(); 
        } else {
          // If not logged in, show the original AuthScreen.
          // Note: If you want to bypass login for testing, you can temporarily
          // return IDEScreen() here as well.
          return const AuthScreen();
        }
      },
    );
  }
}
