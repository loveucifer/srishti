import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/features/core/services/supabase_service.dart';

class AiService {
  final _client = SupabaseService.client;

  Future<String> generateCode(String prompt) async {
    // In the future, this will call our Supabase Edge Function.
    // For now, let's return a realistic-looking mock response.
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    
    // This is where we would invoke the Supabase function:
    // final response = await _client.functions.invoke('generate-code', body: {'prompt': prompt});
    // return response.data['code'];

    return """
// AI-Generated response for prompt: "$prompt"
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
""";
  }
}

final aiServiceProvider = Provider((ref) => AiService());
