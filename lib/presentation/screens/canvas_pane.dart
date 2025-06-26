import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // For conditional rendering
// Conditional import for IFrameElement to allow compilation on non-web
import 'package:srishti/core/utils/html_stubs.dart' if (dart.library.html) 'dart:html';


class CanvasPane extends ConsumerStatefulWidget {
  final String fileName;
  final String fileContent;
  final Map<String, String> projectFiles;
  final ValueChanged<String> onCodeChanged;

  const CanvasPane({
    super.key,
    required this.fileName,
    required this.fileContent,
    required this.projectFiles,
    required this.onCodeChanged,
  });

  @override
  ConsumerState<CanvasPane> createState() => _CanvasPaneState();
}

class _CanvasPaneState extends ConsumerState<CanvasPane> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // debugPrint('WebView is loading (progress: $progress%)');
            },
            onPageStarted: (String url) {
              // debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              // debugPrint('Page finished loading: $url');
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('Web resource error: ${error.description}');
            },
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        );
      _loadHtmlContent();
    }
  }

  @override
  void didUpdateWidget(covariant CanvasPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload content only if the file content or fileName has changed
    if (oldWidget.fileContent != widget.fileContent || oldWidget.fileName != widget.fileName) {
      _loadHtmlContent();
    }
  }

  void _loadHtmlContent() {
    if (_controller != null && widget.fileName.endsWith('.html')) {
      // For HTML files, load directly.
      _controller!.loadHtmlString(widget.fileContent);
    } else if (_controller != null) {
      // For non-HTML files (CSS, JS), we might need to embed them within a generic HTML structure.
      // This is a basic example; a more robust solution would dynamically generate the HTML
      // including script/style tags for the associated CSS/JS files in projectFiles.
      final htmlStructure = '''
<!DOCTYPE html>
<html>
<head>
  <title>${widget.fileName}</title>
  ${widget.projectFiles.containsKey('style.css') ? '<style>${widget.projectFiles['style.css']}</style>' : ''}
</head>
<body>
  <pre>${_htmlEscape(widget.fileContent)}</pre>
  ${widget.projectFiles.containsKey('script.js') ? '<script>${widget.projectFiles['script.js']}</script>' : ''}
</body>
</html>
      ''';
      _controller!.loadHtmlString(htmlStructure);
    }
  }

  // Helper to escape HTML characters for displaying code directly in <pre>
  String _htmlEscape(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#039;');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.1),
      child: kIsWeb && _controller != null
          ? WebViewWidget(controller: _controller!)
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber, size: 60, color: Colors.amber),
                  SizedBox(height: 16),
                  Text(
                    'Live Preview available on Web Platform',
                    style: TextStyle(fontSize: 18, color: Colors.white54),
                  ),
                ],
              ),
            ),
    );
  }
}
