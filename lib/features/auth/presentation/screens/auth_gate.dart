import 'package:flutter/material.dart';
import 'package:srishti/features/ai_assistant/presentation/screens/ai_assistant_screen.dart'; // Import new AI screen
import 'package:srishti/features/auth/presentation/screens/auth_screen.dart';
import 'package:srishti/features/core/services/supabase_service.dart';
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
          // User is logged in, show the AiAssistantScreen.
          return const AiAssistantScreen();
        } else {
          // User is not logged in, show the AuthScreen.
          return const AuthScreen();
        }
      },
    );
  }
}