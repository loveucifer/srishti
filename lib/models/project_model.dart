// lib/models/project_model.dart

class Project {
  final String id;
  final String userId;
  final String name;
  final String description;
  final DateTime createdAt;
  Map<String, String> files; // Changed from a single string

  Project({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.files,
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      // Ensure files are loaded as Map<String, String>
      files: Map<String, String>.from(map['files'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'files': files,
    };
  }

  // Helper to create a new project with default files
  static Map<String, String> defaultFiles() {
    return {
      'index.html': '''
<!DOCTYPE html>
<html>
<head>
  <title>Srishti Project</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Welcome to your Srishti Project!</h1>
  <p>Your live preview is working.</p>
  <script src="script.js"></script>
</body>
</html>
      ''',
      'style.css': '''
body {
  font-family: sans-serif;
  background-color: #f0f0f0;
  color: #333;
  padding: 2em;
}
h1 {
  color: #007bff;
}
      ''',
      'script.js': '''
console.log("Srishti project script loaded!");
      ''',
    };
  }
}

