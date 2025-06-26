enum ChatMessageRole { user, assistant }

class ChatMessage {
  final ChatMessageRole role;
  final String content;

  // Added 'const' to the constructor
  const ChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() {
    return {
      'role': role.name,
      'content': content,
    };
  }
}
