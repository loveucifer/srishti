import 'package:flutter/material.dart';
import 'package:srishti/presentation/screens/ai_assistant_screen.dart';
import 'package:srishti/presentation/screens/canvas_pane.dart';
import 'package:srishti/presentation/widgets/gradient_background.dart';

class IdeScreen extends StatelessWidget {
  const IdeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GradientBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              // Left Pane: The AI Chat Assistant
              // We constrain its width for a balanced layout.
              const SizedBox(
                width: 550, // Or a flexible fraction of the screen
                child: AiAssistantScreen(),
              ),

              // A visual divider between the panes
              const VerticalDivider(width: 1, color: Colors.white24),

              // Right Pane: The Canvas for Preview, Terminal, etc.
              const Expanded(
                child: CanvasPane(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
