class Project {
  final String id;
  final String userId; // New field for user ID
  final String name;
  final String? content; // This field might be used for a primary generated output
  final String? description; // New field for project description
  final DateTime createdAt;
  final Map<String, String> files; // New field to store file contents for the IDE

  Project({
    required this.id,
    required this.userId, // Now required in constructor
    required this.name,
    this.content,
    this.description, // Now a named parameter
    required this.createdAt,
    required this.files, // Now required in constructor
  });

  // Factory constructor to create a Project object from a JSON map
  factory Project.fromJson(Map<String, dynamic> json) {
    // Deserialize 'files' map safely. Firestore saves maps, so we cast directly.
    // Ensure that if 'files' is null or not a Map, it defaults to an empty map.
    final Map<String, String> filesMap = {};
    if (json['files'] is Map) {
      (json['files'] as Map).forEach((key, value) {
        if (key is String && value is String) {
          filesMap[key] = value;
        }
      });
    }

    return Project(
      id: json['id'] as String,
      userId: json['user_id'] as String, // Assuming 'user_id' in JSON for Supabase
      name: json['name'] as String,
      content: json['content'] as String?,
      description: json['description'] as String?, // Nullable field
      createdAt: DateTime.parse(json['created_at'] as String),
      files: filesMap,
    );
  }

  // Static method to provide default files for a new project in the IDE
  static Map<String, String> defaultFiles() {
    return {
      'index.html': '''
<!DOCTYPE html>
<html>
<head>
  <title>Srishti Project</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      margin: 0;
      background-color: #f0f0f0;
      color: #333;
    }
    h1 {
      color: #007bff;
    }
    p {
      font-size: 1.1em;
    }
  </style>
</head>
<body>
  <div>
    <h1>Welcome to Srishti!</h1>
    <p>Your creative journey begins here.</p>
  </div>
</body>
</html>
      ''',
      'style.css': '''
/* Basic styles for your Srishti project */
body {
  margin: 0;
  font-family: 'Arial', sans-serif;
  background-color: #1a1a2e;
  color: #e0e0e0;
}

.container {
  max-width: 960px;
  margin: 0 auto;
  padding: 20px;
  text-align: center;
}

h1 {
  color: #e94560;
  margin-bottom: 20px;
}

button {
  background-color: #0f3460;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1em;
}

button:hover {
  background-color: #0a2342;
}
      ''',
      'script.js': '''
// JavaScript for your Srishti project
document.addEventListener('DOMContentLoaded', () => {
  console.log('Project script loaded!');
  const button = document.createElement('button');
  button.textContent = 'Click me!';
  button.style.marginTop = '20px';
  document.body.appendChild(button);

  button.addEventListener('click', () => {
    alert('Button clicked!');
  });
});
      ''',
    };
  }
}
