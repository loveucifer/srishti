import 'package:flutter/material.dart';

class TerminalPane extends StatelessWidget {
  const TerminalPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.2), // Dark background for terminal
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Text(
          'Welcome to the Srishti Terminal!\n\nThis is a placeholder. Command execution and output will appear here in future updates.',
          style: TextStyle(
            color: Colors.white70,
            fontFamily: 'monospace',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
