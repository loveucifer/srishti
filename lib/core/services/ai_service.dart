import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/core/services/supabase_service.dart';
import 'package:srishti/models/chat_message_model.dart'; // Import the new model

class AiService {
  final _client = SupabaseService.client;

  // Update the method to accept a list of messages
  Future<String> getAiResponse(List<ChatMessage> messages) async {
    final response = await _client.functions.invoke(
      'generate-code',
      // Pass the list of messages in the body
      body: {'messages': messages.map((m) => m.toJson()).toList()},
    );

    if (response.data is Map && response.data['error'] != null) {
      throw Exception('Failed to get response: ${response.data['error']}');
    }

    // The edge function now returns 'content' instead of 'code'
    return response.data['content'];
  }
}

final aiServiceProvider = Provider((ref) => AiService());