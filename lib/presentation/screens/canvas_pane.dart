import 'package:flutter/material.dart';

class CanvasPane extends StatelessWidget {
  const CanvasPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.1),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.web, size: 60, color: Colors.white24),
            SizedBox(height: 16),
            Text(
              'Live Preview & Terminal',
              style: TextStyle(fontSize: 24, color: Colors.white54),
            ),
            Text(
              'Coming Soon',
              style: TextStyle(fontSize: 18, color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}
