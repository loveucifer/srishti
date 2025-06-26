// lib/models/chat_message_model.dart

enum ChatMessageRole { user, assistant }

class ChatMessage {
  final ChatMessageRole role;
  final String content;

  ChatMessage({required this.role, required this.content});

  // CORRECTED: Added the toJson method. The AI service calls this
  // to prepare the chat history for the API request.
  Map<String, String> toJson() {
    return {
      'role': role.name, // .name is safer than string splitting
      'content': content,
    };
  }
}
