import 'package:flutter/material.dart';
// CORRECTED: The import path now points to the new 'features' directory structure.
import 'package:srishti/features/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = SupabaseService.client;

  // --- Core Functions ---

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithOAuth(OAuthProvider provider) async {
    await _supabase.auth.signInWithOAuth(provider);
  }

  // --- Helper to show messages ---
  // A service can interact with the UI via a BuildContext passed from the widget.
  void showAuthMessage(BuildContext context, String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Colors.green[400],
      ),
    );
  }
}