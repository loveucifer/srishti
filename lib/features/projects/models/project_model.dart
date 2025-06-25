// lib/features/projects/models/project_model.dart
class Project {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}