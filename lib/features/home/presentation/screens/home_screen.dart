// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/features/projects/services/project_service.dart';

// Change from StatelessWidget to ConsumerWidget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the projectsProvider to get the state of our data
    final projectsAsyncValue = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: projectsAsyncValue.when(
        // Data is successfully loaded
        data: (projects) {
          if (projects.isEmpty) {
            return const Center(
              child: Text(
                'No projects yet. Tap + to create one!',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            );
          }
          // Display the list of projects
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return ListTile(
                title: Text(project.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: project.description != null
                    ? Text(project.description!, style: const TextStyle(color: Colors.white70))
                    : null,
                trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                onTap: () {
                  // TODO: Navigate to project details screen
                },
              );
            },
          );
        },
        // An error occurred
        error: (err, stack) => Center(
          child: Text('Error: ${err.toString()}', style: const TextStyle(color: Colors.red)),
        ),
        // Data is loading
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show a dialog or navigate to a new screen to create a project
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}