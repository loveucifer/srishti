import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:srishti/core/services/ai_service.dart';
import 'package:srishti/presentation/widgets/gradient_background.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final _promptController = TextEditingController();
  String? _generatedCode;
  bool _isLoading = false;
  String? _error;

  Future<void> _handleGenerate() async {
    if (_promptController.text.isEmpty) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _error = null;
      _generatedCode = null;
    });

    // --- START OF NEW DEBUGGING CODE ---
    try {
      print("Attempting to call AI service...");
      final code = await ref.read(aiServiceProvider).generateCode(_promptController.text);
      print("AI service call successful.");
      setState(() {
        _generatedCode = code;
      });
    } catch (e) {
      // This will catch any error during the function call and print it.
      print("!!! An error occurred: $e");
      setState(() {
        _error = "An error occurred: ${e.toString()}";
      });
    } finally {
      // --- END OF NEW DEBUGGING CODE ---
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ... the rest of your file (build methods, etc.) remains exactly the same
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GradientBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Srishti AI', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 24, color: Colors.white)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.folder_outlined))
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: _buildContentArea(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentArea() {
    if (_generatedCode == null && !_isLoading && _error == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Build something amazing", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildPromptInput(),
        ],
      );
    }
    return Column(
      children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildResponseArea(),
          ),
        ),
        _buildPromptInput(),
      ],
    );
  }

  Widget _buildResponseArea() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }
    if (_generatedCode != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SyntaxView(
          code: _generatedCode!,
          syntax: Syntax.DART,
          syntaxTheme: SyntaxTheme.vscodeDark(),
          expanded: true,
          withLinesCount: true,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildPromptInput() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        shadowColor: Colors.black.withOpacity(0.5),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff1c1c1c),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: _promptController,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: "Ask Srishti to create a landing page for...",
              hintStyle: const TextStyle(color: Colors.white54),
              contentPadding: const EdgeInsets.all(20),
              border: InputBorder.none,
              suffixIcon: IconButton(
                padding: const EdgeInsets.only(right: 12),
                onPressed: _isLoading ? null : _handleGenerate,
                icon: const Icon(Icons.arrow_upward_rounded, size: 24),
                color: Colors.white,
              ),
            ),
            onSubmitted: (_) => _handleGenerate(),
          ),
        ),
      ),
    );
  }
}