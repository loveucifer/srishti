// lib/features/projects/services/project_service.dart
import 'package:srishti/features/core/services/supabase_service.dart';
import 'package:srishti/features/projects/models/project_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectService {
  final _client = SupabaseService.client;

  Future<List<Project>> getProjects() async {
    final response = await _client.from('projects').select().order('created_at');
    return response.map((item) => Project.fromJson(item)).toList();
  }
}

// A provider to make the ProjectService available throughout the app
final projectServiceProvider = Provider((ref) => ProjectService());

// A future provider that fetches the projects and handles state (loading, error, data)
final projectsProvider = FutureProvider<List<Project>>((ref) async {
  return ref.watch(projectServiceProvider).getProjects();
});