import 'package:flutter/material.dart';
import 'package:srishti/presentation/widgets/auth_form.dart';
import 'package:srishti/presentation/widgets/gradient_background.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        // The AuthForm was missing as a child for the background.
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: AuthForm(),
            ),
          ),
        ),
      ),
    );
  }
}
