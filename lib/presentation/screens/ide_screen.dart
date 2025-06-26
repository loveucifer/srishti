
import 'package:flutter/material.dart';
import 'package:srishti/models/project_model.dart';
import 'package:srishti/presentation/screens/ai_assistant_screen.dart';
import 'package:srishti/presentation/screens/canvas_pane.dart';
import 'package:srishti/presentation/screens/terminal_pane.dart';
import 'package:srishti/presentation/widgets/file_explorer.dart';
import 'package:resizable_widget/resizable_widget.dart';

class IDEScreen extends StatefulWidget {
  const IDEScreen({Key? key}) : super(key: key);

  @override
  _IDEScreenState createState() => _IDEScreenState();
}

class _IDEScreenState extends State<IDEScreen> {
  // We'll use a placeholder project for now.
  final Project _project = Project(
    id: '1',
    userId: '1',
    name: 'My First Web Project',
    description: 'An interactive web page.',
    createdAt: DateTime.now(),
    files: Project.defaultFiles(),
  );

  String _selectedFile = 'index.html';

  // This function is called when the code in the editor changes.
  void _updateFileContent(String newContent) {
    setState(() {
      _project.files[_selectedFile] = newContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ResizableWidget(
        separatorSize: 4.0,
        separatorColor: Theme.of(context).colorScheme.background,
        percentages: const [0.18, 0.82], // File Explorer vs Main Area
        children: [
          FileExplorer(
            files: _project.files,
            selectedFile: _selectedFile,
            onFileSelected: (fileName) {
              setState(() {
                _selectedFile = fileName;
              });
            },
          ),
          ResizableWidget(
            separatorSize: 4.0,
            separatorColor: Theme.of(context).colorScheme.background,
            percentages: const [0.65, 0.35], // Editor/Preview vs AI Assistant
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 7, // 70% of the space
                    child: CanvasPane(
                      key: ValueKey(_selectedFile), // Important for state reset
                      fileName: _selectedFile,
                      fileContent: _project.files[_selectedFile]!,
                      projectFiles: _project.files,
                      onCodeChanged: _updateFileContent,
                    ),
                  ),
                  const Divider(height: 4, thickness: 4),
                  const Expanded(
                    flex: 3, // 30% of the space
                    child: TerminalPane(),
                  ),
                ],
              ),
              // Your existing AiAssistantScreen is now a pane in the IDE.
              const AiAssistantScreen(),
            ],
          )
        ],
      ),
    );
  }
}