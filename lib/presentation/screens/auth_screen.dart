import 'package:flutter/material.dart';
import 'package:srishti/presentation/widgets/auth_form.dart';
import 'package:srishti/presentation/widgets/gradient_background.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: const AuthForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}