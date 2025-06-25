import 'package:flutter/material.dart';
import 'package:srishti/features/auth/presentation/screens/auth_screen.dart';
import 'package:srishti/features/core/services/supabase_service.dart';
import 'package:srishti/features/home/presentation/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // A stream builder that listens to authentication state changes.
    return StreamBuilder<AuthState>(
      // CORRECTED: The method is 'onAuthStateChange' and it's a getter (no parentheses).
      stream: SupabaseService.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // If the stream is still loading, show a loading indicator.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If the snapshot has data, it means there's an active session.
        if (snapshot.hasData && snapshot.data?.session != null) {
          // User is logged in, show the HomeScreen.
          return const HomeScreen();
        } else {
          // User is not logged in, show the AuthScreen.
          return const AuthScreen();
        }
      },
    );
  }
}