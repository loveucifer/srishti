// lib/presentation/screens/canvas_pane.dart

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/xml.dart';
import 'package:highlight/languages/css.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CanvasPane extends StatefulWidget {
  final String fileName;
  final String fileContent;
  final Map<String, String> projectFiles;
  final Function(String) onCodeChanged;

  const CanvasPane({
    Key? key,
    required this.fileName,
    required this.fileContent,
    required this.projectFiles,
    required this.onCodeChanged,
  }) : super(key: key);

  @override
  State<CanvasPane> createState() => _CanvasPaneState();
}

class _CanvasPaneState extends State<CanvasPane> {
  late final CodeController _codeController;
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _setupCodeController();
    _setupWebViewController();
    _updateWebView();
  }

  void _setupCodeController() {
    _codeController = CodeController(
      text: widget.fileContent,
      language: _getLanguage(widget.fileName),
    );
    _codeController.addListener(() {
      widget.onCodeChanged(_codeController.fullText);
      _updateWebView();
    });
  }

  void _setupWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  void _updateWebView() {
    final htmlFile = widget.projectFiles['index.html'] ?? '';
    final cssFile = widget.projectFiles['style.css'] ?? '';
    final jsFile = widget.projectFiles['script.js'] ?? '';

    final fullHtml = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { margin: 8px; font-family: sans-serif; }
            $cssFile
          </style>
        </head>
        <body>
          $htmlFile
          <script>
            try {
              $jsFile
            } catch (e) {
              console.error(e);
            }
          </script>
        </body>
      </html>
    ''';
    _webViewController.loadHtmlString(fullHtml);
  }

  dynamic _getLanguage(String fileName) {
    if (fileName.endsWith('.html')) return xml;
    if (fileName.endsWith('.css')) return css;
    if (fileName.endsWith('.js')) return javascript;
    return javascript;
  }

  @override
  void didUpdateWidget(covariant CanvasPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fileContent != oldWidget.fileContent && widget.fileContent != _codeController.fullText) {
      _codeController.text = widget.fileContent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: CodeTheme(
                  data: CodeThemeData(styles: monokaiSublimeTheme),
                  child: SingleChildScrollView(
                    child: CodeField(
                      controller: _codeController,
                      textStyle: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(
                child: WebViewWidget(controller: _webViewController),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
