// lib/presentation/screens/generation_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:srishti/models/project_model.dart';

class GenerationDetailScreen extends StatelessWidget {
  final Project project;

  const GenerationDetailScreen({Key? key, required this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // CORRECTED: We now access the 'files' map to get content to display.
    // We'll default to showing 'index.html' or a message if it doesn't exist.
    final displayContent =
        project.files['index.html'] ?? 'No content saved for this project.';

    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SelectableText(displayContent),
        ),
      ),
    );
  }
}
