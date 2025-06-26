import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child; // Add child property

  // Update constructor to accept a child
  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey.shade900, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child, // Use the child here
    );
  }
}
