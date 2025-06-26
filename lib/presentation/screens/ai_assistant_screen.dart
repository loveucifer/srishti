import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/core/services/ai_service.dart';
import 'package:srishti/core/utils/html_stubs.dart'; // <-- This import is crucial
import 'package:srishti/models/chat_message_model.dart';
import 'package:srishti/presentation/widgets/gradient_background.dart';

// Provides the HTML content for the live preview canvas.
// The 'initialHtmlContent' is now correctly referenced from the imported stub file.
final htmlContentProvider = StateProvider<String>((ref) => initialHtmlContent);

// Provides the output for the terminal pane.
final terminalOutputProvider = StateProvider<String>((ref) => 'Srishti Terminal\n>');

// Provides the list of messages in the AI chat.
final chatMessagesProvider = StateProvider<List<ChatMessage>>((ref) => []);

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollToBottom() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
              );
          }
      });
  }

  void _sendMessage() async {
    final text = _controller.text;
    if (text.isEmpty) return;

    final userMessage = ChatMessage(text: text, isUser: true);
    ref.read(chatMessagesProvider.notifier).update((state) => [...state, userMessage]);
    _scrollToBottom();

    _controller.clear();

    try {
      final aiService = ref.read(aiServiceProvider);
      final response = await aiService.generateContent(text);

      final botMessage = ChatMessage(text: response.originalText, isUser: false);
      ref.read(chatMessagesProvider.notifier).update((state) => [...state, botMessage]);
      _scrollToBottom();
      
      if (response.htmlCode != null && response.htmlCode!.isNotEmpty) {
        ref.read(htmlContentProvider.notifier).state = response.htmlCode!;
      }
      
      if (response.terminalOutput != null && response.terminalOutput!.isNotEmpty) {
        ref.read(terminalOutputProvider.notifier).update(
          (state) => '$state\$ $text\n${response.terminalOutput!}\n>',
        );
      }

    } catch (e) {
      final errorMessage = ChatMessage(text: "An error occurred: ${e.toString()}", isUser: false);
      ref.read(chatMessagesProvider.notifier).update((state) => [...state, errorMessage]);
      _scrollToBottom();
      
      ref.read(terminalOutputProvider.notifier).update((state) => "$state\nError: ${e.toString()}\n>");
      
      ref.read(htmlContentProvider.notifier).state = '''
        <html><body><div style="color: red; text-align: center; padding-top: 50px; font-family: sans-serif;">
          <h1>Error Generating Content</h1>
          <p>${e.toString()}</p>
        </div></body></html>
      ''';
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    ref.listen(chatMessagesProvider, (_, __) => _scrollToBottom());

    return GradientBackground(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.blue[600] : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      message.text,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Ask Srishti to code or run commands...',
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                  iconSize: 24,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.all(15),
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
