import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/core/services/supabase_service.dart';

class AiService {
  final _client = SupabaseService.client;

  Future<String> generateCode(String prompt) async {
    // This calls our live Supabase Edge Function
    final response = await _client.functions.invoke(
      'generate-code',
      body: {'prompt': prompt},
    );

    // This block correctly checks for an 'error' key in the JSON data
    // returned BY THE FUNCTION if our TypeScript code catches an error.
    if (response.data is Map && response.data['error'] != null) {
      throw Exception('Failed to generate code: ${response.data['error']}');
    }

    // The incorrect block that checked for 'response.error' has been removed.
    // Any network or server errors will be caught by the try/catch in the UI.

    return response.data['code'];
  }
}

final aiServiceProvider = Provider((ref) => AiService());