import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:srishti/core/services/ai_service.dart';
import 'package:srishti/models/chat_message_model.dart';
import 'package:srishti/presentation/widgets/gradient_background.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});
  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final _promptController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    if (_promptController.text.isEmpty) return;
    final prompt = _promptController.text;
    _promptController.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _messages.add(ChatMessage(role: ChatMessageRole.user, content: prompt));
      _isLoading = true;
    });

    try {
      final response = await ref.read(aiServiceProvider).getAiResponse(_messages);
      setState(() {
        _messages.add(ChatMessage(role: ChatMessageRole.assistant, content: response));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(role: ChatMessageRole.assistant, content: "Error: ${e.toString()}"));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
          ),
          body: Column(
            children: [
              Expanded(
                child: _messages.isEmpty
                    ? const Center(child: Text("Ask Srishti to build something...", style: TextStyle(color: Colors.white54, fontSize: 18)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return ChatMessageWidget(message: message);
                        },
                      ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              _buildPromptInput(),
            ],
          ),
        ),
      ],
    );
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
              hintText: "Message Srishti...",
              hintStyle: const TextStyle(color: Colors.white54),
              contentPadding: const EdgeInsets.all(20),
              border: InputBorder.none,
              suffixIcon: IconButton(
                padding: const EdgeInsets.only(right: 12),
                onPressed: _isLoading ? null : _sendMessage,
                icon: const Icon(Icons.arrow_upward_rounded, size: 24),
                color: Colors.white,
              ),
            ),
            onSubmitted: _isLoading ? null : (_) => _sendMessage(),
          ),
        ),
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatMessageRole.user;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: isUser ? Colors.blue.withOpacity(0.5) : Colors.black.withOpacity(0.5),
            child: Icon(isUser ? Icons.person_outline : Icons.auto_awesome, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUser ? "You" : "Srishti",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                MarkdownBody(
                  data: message.content,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: const TextStyle(color: Colors.white, fontSize: 16),
                    code: GoogleFonts.getFont('JetBrains Mono', textStyle: const TextStyle(backgroundColor: Colors.transparent, color: Colors.lightBlueAccent)),
                  ),
                  builders: {
                    // CORRECTED: Target 'codeblock' instead of 'code'
                    'codeblock': CopyableCodeBlockBuilder(),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CopyableCodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget visit(element, parent) {
    final String text = element.textContent.trim();
    return CopyableCodeBlock(code: text);
  }
}

class CopyableCodeBlock extends StatelessWidget {
  final String code;
  const CopyableCodeBlock({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Text(
            code,
            style: GoogleFonts.getFont('JetBrains Mono', textStyle: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ),
        Positioned(
          top: 12,
          right: 4,
          child: IconButton(
            icon: const Icon(Icons.copy_all_outlined, size: 18, color: Colors.white70),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Code copied to clipboard!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Copy code',
          ),
        ),
      ],
    );
  }
}