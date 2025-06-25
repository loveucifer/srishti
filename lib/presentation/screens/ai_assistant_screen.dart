import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:srishti/core/services/ai_service.dart';
import 'package:srishti/core/services/project_service.dart';
import 'package:srishti/models/chat_message_model.dart';
import 'package:srishti/presentation/screens/saved_generations_screen.dart';
import 'package:srishti/presentation/widgets/gradient_background.dart';

// Represents a chunk of content, either plain text or a code block
class ContentChunk {
  final String type; // 'text' or 'code'
  final String content;
  ContentChunk({required this.type, required this.content});
}

// Provider to hold the chat messages, making state accessible everywhere
final messagesProvider = StateProvider<List<ChatMessage>>((ref) => []);
// Provider to track loading state
final isLoadingProvider = StateProvider<bool>((ref) => false);


// The main screen is now a stateless ConsumerWidget.
// All state is handled by the providers above.
class AiAssistantScreen extends ConsumerWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The TextEditingController can be created here, no need for a stateful widget.
    final promptController = TextEditingController();
    final messages = ref.watch(messagesProvider);
    final isLoading = ref.watch(isLoadingProvider);

    // This method is now defined inside build where it has access to ref and context
    Future<void> sendMessage() async {
      if (promptController.text.isEmpty) return;
      final prompt = promptController.text;
      promptController.clear();
      FocusScope.of(context).unfocus();

      // Update state purely through Riverpod providers
      ref.read(isLoadingProvider.notifier).state = true;
      ref.read(messagesProvider.notifier).update((state) => [...state, ChatMessage(role: ChatMessageRole.user, content: prompt)]);

      try {
        final response = await ref.read(aiServiceProvider).getAiResponse(ref.read(messagesProvider));
        ref.read(messagesProvider.notifier).update((state) => [...state, ChatMessage(role: ChatMessageRole.assistant, content: response)]);
      } catch (e) {
        ref.read(messagesProvider.notifier).update((state) => [...state, ChatMessage(role: ChatMessageRole.assistant, content: "Error: ${e.toString()}")]);
      } finally {
        ref.read(isLoadingProvider.notifier).state = false;
      }
    }

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
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton.icon(
                  onPressed: () {
                    // This will fetch the latest saved generations when the history page is opened
                    ref.invalidate(projectsProvider);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SavedGenerationsScreen()),
                    );
                  },
                  icon: const Icon(Icons.history, size: 20),
                  label: const Text('History'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? const Center(child: Text("Ask Srishti to build something...", style: TextStyle(color: Colors.white54, fontSize: 18)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return ChatMessageWidget(message: message);
                        },
                      ),
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              Padding(
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
                      controller: promptController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: "Message Srishti...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        contentPadding: const EdgeInsets.all(20),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          padding: const EdgeInsets.only(right: 12),
                          onPressed: isLoading ? null : sendMessage,
                          icon: const Icon(Icons.arrow_upward_rounded, size: 24),
                          color: Colors.white,
                        ),
                      ),
                      onSubmitted: isLoading ? null : (_) => sendMessage(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  const ChatMessageWidget({super.key, required this.message});

  List<ContentChunk> _parseContent(String content) {
    final chunks = <ContentChunk>[];
    final regex = RegExp(r"```[\s\S]*?```", multiLine: true);
    int lastEnd = 0;
    for (final match in regex.allMatches(content)) {
      if (match.start > lastEnd) {
        chunks.add(ContentChunk(type: 'text', content: content.substring(lastEnd, match.start)));
      }
      chunks.add(ContentChunk(type: 'code', content: match.group(0)!));
      lastEnd = match.end;
    }
    if (lastEnd < content.length) {
      chunks.add(ContentChunk(type: 'text', content: content.substring(lastEnd)));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatMessageRole.user;
    final chunks = isUser ? [ContentChunk(type: 'text', content: message.content)] : _parseContent(message.content);

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
                Row(
                  children: [
                    Text(
                      isUser ? "You" : "Srishti",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const Spacer(),
                    if (!isUser) // Show save button only for AI messages
                      IconButton(
                        icon: const Icon(Icons.save_alt_outlined, size: 20, color: Colors.white70),
                        tooltip: 'Save Generation',
                        onPressed: () async {
                           // This requires the widget to be a ConsumerWidget to access ref.
                           // For now, this is a placeholder. We will wire this up properly.
                           print("Save button tapped");
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ...chunks.map((chunk) {
                  if (chunk.type == 'text' && chunk.content.trim().isNotEmpty) {
                    return SelectableText(chunk.content.trim(), style: const TextStyle(color: Colors.white, fontSize: 16));
                  } else if (chunk.type == 'code') {
                    final codeContent = chunk.content.replaceAll(RegExp(r"^```(\w*\n)?|```$"), "").trim();
                    return CopyableCodeBlock(code: codeContent);
                  } else {
                    return const SizedBox.shrink();
                  }
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CopyableCodeBlock extends StatelessWidget {
  final String code;
  const CopyableCodeBlock({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: Text(
              code.trim(),
              style: GoogleFonts.getFont('JetBrains Mono', textStyle: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.copy_all_outlined, size: 18, color: Colors.white70),
              tooltip: 'Copy code',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code.trim()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Code copied to clipboard!'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
