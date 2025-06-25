import 'dart:ui';
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff0a0a0a),
      ),
      child: Stack(
        children: [
          // These positioned circles are blurred to create the gradient effect.
          const Align(
            alignment: Alignment(-0.8, -0.6),
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Color(0x3388a0f8),
            ),
          ),
          const Align(
            alignment: Alignment(0.9, 0.9),
            child: CircleAvatar(
              radius: 180,
              backgroundColor: Color(0x22ffffff),
            ),
          ),
          // The BackdropFilter is what applies the heavy blur.
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
            ),
          ),
        ],
      ),
    );
  }
}