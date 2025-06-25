
import 'package:flutter/material.dart';
import 'package:srishti/features/auth/presentation/widgets/auth_form.dart';
import 'package:srishti/shared/widgets/gradient_background.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Removed 'const' from Scaffold because SingleChildScrollView is not const.
    return Scaffold(
      body: Stack(
        children: [
          // Layer 1: The reusable gradient background.
          const GradientBackground(),
          
          // Layer 2: The main content, centered.
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                // The form is now its own complex widget.
                child: const AuthForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}