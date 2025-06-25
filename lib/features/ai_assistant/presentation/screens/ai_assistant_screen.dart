import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:srishti/features/ai_assistant/services/ai_service.dart';

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

    setState(() {
      _isLoading = true;
      _error = null;
      _generatedCode = null;
    });

    try {
      final code = await ref.read(aiServiceProvider).generateCode(_promptController.text);
      setState(() {
        _generatedCode = code;
      });
    } catch (e) {
      setState(() {
        _error = "An error occurred: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Srishti AI', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // We can add a "My Projects" button here later to see saved code
          IconButton(onPressed: () { /* TODO: Navigate to projects list */ }, icon: const Icon(Icons.folder_outlined))
        ],
      ),
      body: Column(
        children: [
          // The main content area to display the generated code
          Expanded(
            child: _buildContentArea(),
          ),
          // The prompt input bar at the bottom
          _buildPromptInput(),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }
    if (_generatedCode != null) {
      return SyntaxView(
        code: _generatedCode!,
        syntax: Syntax.DART,
        syntaxTheme: SyntaxTheme.vscodeDark(),
        expanded: true,
        withLinesCount: true,
      );
    }
    return const Center(
      child: Text("Describe the UI you want to build.", style: TextStyle(color: Colors.white54, fontSize: 18)),
    );
  }

  Widget _buildPromptInput() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promptController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "e.g., a login screen with a logo...",
                    hintStyle: TextStyle(color: Colors.white54),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: _isLoading ? null : _handleGenerate,
                icon: const Icon(Icons.arrow_upward_rounded),
                color: Colors.white,
                style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.2)),
              )
            ],
          ),
        ),
      ),
    );
  }
}