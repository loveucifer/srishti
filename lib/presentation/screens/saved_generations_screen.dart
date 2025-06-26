import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/core/services/project_service.dart';
import 'package:srishti/models/project_model.dart'; // Ensure this is the updated model
import 'package:srishti/presentation/screens/generation_detail_screen.dart';
import 'package:srishti/presentation/widgets/gradient_background.dart';

class SavedGenerationsScreen extends ConsumerWidget {
  const SavedGenerationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the provider we already have to fetch the projects/generations
    final projectsAsyncValue = ref.watch(projectsProvider);

    return Stack(
      children: [
        const GradientBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Saved Generations'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: projectsAsyncValue.when(
            data: (projects) {
              if (projects.isEmpty) {
                return const Center(
                  child: Text(
                    'You haven\'t saved any generations yet.',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                );
              }
              // Display the list of saved generations
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return GenerationCard(project: project);
                },
              );
            },
            error: (err, stack) => Center(
              child: Text('Error: ${err.toString()}', style: const TextStyle(color: Colors.red)),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }
}

// A card widget to display a single saved generation
class GenerationCard extends StatelessWidget {
  const GenerationCard({super.key, required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: const Icon(Icons.history_edu_outlined, color: Colors.white70),
        title: Text(
          project.name, // The user's original prompt
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        subtitle: Text(
          // Use description if available, otherwise fallback to a formatted date
          project.description ?? 'Saved on: ${project.createdAt.toLocal().day}/${project.createdAt.toLocal().month}/${project.createdAt.toLocal().year}',
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: () {
          // Navigate to a detail screen to view the full content
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GenerationDetailScreen(project: project),
            ),
          );
        },
      ),
    );
  }
}
