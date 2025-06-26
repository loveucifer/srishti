// lib/presentation/screens/saved_generations_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/core/services/project_service.dart'; // CORRECTED: Import the service file
import 'package:srishti/models/project_model.dart';
import 'package:srishti/presentation/screens/generation_detail_screen.dart';

class SavedGenerationsScreen extends ConsumerWidget {
  const SavedGenerationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // CORRECTED: This will now find the projectsProvider defined in the service.
    final projectsAsyncValue = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Generations')),
      body: projectsAsyncValue.when(
        data: (projects) => ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return ListTile(
              title: Text(project.name),
              subtitle: Text(project.description),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GenerationDetailScreen(project: project),
                  ),
                );
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
