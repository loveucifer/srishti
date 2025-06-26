import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/core/services/supabase_service.dart';
import 'package:srishti/models/project_model.dart';

class ProjectService {
  final _client = SupabaseService.client;

  Future<List<Project>> getProjects() async {
    final response = await _client.from('projects').select().order('created_at', ascending: false);
    return response.map((item) => Project.fromJson(item)).toList();
  }

  Future<void> saveGeneration({
    required String name,
    required String content,
  }) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('projects').insert({
      'name': name,
      'content': content,
      'user_id': userId,
    });
  }
}

final projectServiceProvider = Provider((ref) => ProjectService());

// This is the provider that was missing
final projectsProvider = FutureProvider<List<Project>>((ref) async {
  return ref.watch(projectServiceProvider).getProjects();
});
