// lib/features/projects/models/task_model.dart
class Task {
  final String id;
  final String projectId;
  final String title;
  final String? description;
  final String status;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    required this.status,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      projectId: json['project_id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}