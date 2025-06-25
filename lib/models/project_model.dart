class Project {
  final String id;
  final String name;
  final String? content; // The new content field
  final DateTime createdAt;

  Project({
    required this.id,
    required this.name,
    this.content,
    required this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}