import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/features/core/services/supabase_service.dart';
import 'package:srishti/features/projects/models/task_model.dart';

class TaskService {
  final _client = SupabaseService.client;

  Future<List<Task>> getTasks(String projectId) async {
    final response = await _client
        .from('tasks')
        .select()
        .eq('project_id', projectId)
        .order('created_at');
    return response.map((item) => Task.fromJson(item)).toList();
  }

  // Method to create a new task
  Future<void> createTask({
    required String title,
    required String projectId,
  }) async {
    await _client.from('tasks').insert({
      'title': title,
      'project_id': projectId,
      'user_id': _client.auth.currentUser!.id,
    });
  }

  // Method to update task status
  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    await _client.rpc('update_task_status', params: {
      'task_id_input': taskId,
      'new_status': newStatus,
    });
  }

  // Method to delete a task
  Future<void> deleteTask(String taskId) async {
    await _client.from('tasks').delete().eq('id', taskId);
  }
}

final taskServiceProvider = Provider((ref) => TaskService());

final tasksProvider = FutureProvider.family<List<Task>, String>((ref, projectId) async {
  return ref.watch(taskServiceProvider).getTasks(projectId);
});