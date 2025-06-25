import 'package:flutter/material.dart';
import 'package:srishti/core/services/supabase_service.dart';
import 'package:srishti/presentation/screens/auth_screen.dart';
import 'package:srishti/presentation/screens/ide_screen.dart'; // Import the new IDE screen
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: SupabaseService.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data?.session != null) {
          // User is logged in, show the new IdeScreen.
          return const IdeScreen();
        } else {
          // User is not logged in, show the AuthScreen.
          return const AuthScreen();
        }
      },
    );
  }
}
