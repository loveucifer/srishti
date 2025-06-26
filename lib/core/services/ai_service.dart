import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:srishti/core/services/supabase_service.dart'; // <-- This import is crucial

// Using ref.read in a provider is best practice to avoid unnecessary rebuilds.
final aiServiceProvider = Provider((ref) {
  // Switched from ref.watch to ref.read.
  final supabaseService = ref.read(supabaseServiceProvider); 
  final generativeModel = supabaseService.getGenerativeModel();
  if (generativeModel == null) {
    throw Exception("Generative Model could not be initialized. Check your API key.");
  }
  return AiService(generativeModel);
});

/// A structured response from the AI, separating different content types.
class AiResponse {
  final String originalText;
  final String? htmlCode;
  final String? terminalOutput;

  AiResponse({required this.originalText, this.htmlCode, this.terminalOutput});
}

class AiService {
  final GenerativeModel _model;

  AiService(this._model);

  /// Generates content using the AI model and parses the response.
  Future<AiResponse> generateContent(String prompt) async {
    try {
      final fullPrompt = """
You are Srishti, an AI assistant in an IDE.
- For HTML code, wrap it in a markdown block: ```html\n...code...\n```
- For terminal commands, wrap them in a block: ```bash\n...commands...\n```
- For plain text, provide the text without code blocks.

User prompt: "$prompt"
""";
      final response = await _model.generateContent([Content.text(fullPrompt)]);
      final responseText = response.text ?? 'Sorry, I could not generate a response.';
      return _parseResponse(responseText);
    } catch (e) {
      print('Error generating content: $e');
      return AiResponse(originalText: "Error: ${e.toString()}");
    }
  }

  /// Parses the raw text from the AI to extract code blocks.
  AiResponse _parseResponse(String text) {
    String? html;
    String? terminal;

    final htmlRegex = RegExp(r"```html\s*\n(.*?)\n```", dotAll: true, caseSensitive: false);
    final terminalRegex = RegExp(r"```(bash|sh)\s*\n(.*?)\n```", dotAll: true, caseSensitive: false);

    final htmlMatch = htmlRegex.firstMatch(text);
    if (htmlMatch != null) {
      html = htmlMatch.group(1)?.trim();
    }

    final terminalMatch = terminalRegex.firstMatch(text);
    if (terminalMatch != null) {
      terminal = terminalMatch.group(2)?.trim();
    }

    String chatText = text.replaceAll(htmlRegex, '').replaceAll(terminalRegex, '').trim();
    if (chatText.isEmpty) {
      if (html != null) {
        chatText = "Here's the HTML code you requested.";
      } else if (terminal != null) {
        chatText = "Here are the terminal commands.";
      } else {
        chatText = text;
      }
    }

    return AiResponse(
      originalText: chatText,
      htmlCode: html,
      terminalOutput: terminal
    );
  }
}
