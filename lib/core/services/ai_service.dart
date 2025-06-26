// lib/core/services/ai_service.dart

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/models/chat_message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// CORRECTED: Define the provider so the UI can access the service.
final aiServiceProvider = Provider((ref) => AIService());

class AIService {
  final _supabase = Supabase.instance.client;

  // This method is called by the UI.
  Future<String> getAiResponse(List<ChatMessage> messages) async {
    try {
      // The body now correctly maps the messages list to a list of JSON maps.
      final response = await _supabase.functions.invoke('ai-chat',
          body: {'messages': messages.map((m) => m.toJson()).toList()});

      if (response.status == 200) {
        // Assuming the edge function returns a map with a 'reply' key.
        return response.data['reply'] as String;
      } else {
        throw Exception(
            'Failed to get AI response: ${response.status} ${response.data}');
      }
    } catch (e) {
      print('Error invoking Supabase function: $e');
      rethrow;
    }
  }

  // This is a helper function that can be used if needed.
  String extractHtmlContent(String response) {
    final codeBlockRegex = RegExp(r"```html\s*([\s\S]+?)\s*```");
    final match = codeBlockRegex.firstMatch(response);
    return match?.group(1) ?? response;
  }
}
