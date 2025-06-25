import 'package:flutter/material.dart';
import 'package:srishti/models/chat_message_model.dart';
import 'package:srishti/models/project_model.dart';
import 'package:srishti/presentation/screens/ai_assistant_screen.dart'; // Re-using ChatMessageWidget
import 'package:srishti/presentation/widgets/gradient_background.dart';

class GenerationDetailScreen extends StatelessWidget {
  final Project project;
  const GenerationDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    // We create two "fake" chat messages from the saved data to display
    final userMessage = ChatMessage(role: ChatMessageRole.user, content: project.name);
    final assistantMessage = ChatMessage(role: ChatMessageRole.assistant, content: project.content ?? "No content saved.");

    return Stack(
      children: [
        const GradientBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(project.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16)),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ChatMessageWidget(message: userMessage),
              ChatMessageWidget(message: assistantMessage),
            ],
          ),
        ),
      ],
    );
  }
}
