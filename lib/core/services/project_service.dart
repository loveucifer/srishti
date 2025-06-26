// lib/core/services/project_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/models/project_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

// Defines the provider for the service itself.
final projectServiceProvider = Provider((ref) => ProjectService());

// Defines the provider that will fetch the projects.
final projectsProvider = FutureProvider<List<Project>>((ref) {
  return ref.watch(projectServiceProvider).getProjects();
});

class ProjectService {
  final SupabaseClient _client = Supabase.instance.client;
  // This will now work because the uuid package is in pubspec.yaml
  final _uuid = const Uuid();

  Future<List<Project>> getProjects() async {
    final response = await _client.from('projects').select().order('created_at', ascending: false);
    return (response as List)
        .map((item) => Project.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveProject(String content) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception("User is not logged in.");
    }
    
    final newProject = Project(
      id: _uuid.v4(), // This now correctly calls the package
      userId: userId,
      name: 'AI Generation - ${DateTime.now().toIso8601String()}',
      description: content.substring(0, (content.length > 100 ? 100 : content.length)),
      createdAt: DateTime.now(),
      files: {'index.html': content}, 
    );

    await _client.from('projects').upsert(newProject.toMap());
  }
}
