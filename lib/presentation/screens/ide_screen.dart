import 'package:flutter/material.dart';
import 'package:srishti/models/project_model.dart';
import 'package:srishti/presentation/screens/ai_assistant_screen.dart';
import 'package:srishti/presentation/screens/canvas_pane.dart';
import 'package:srishti/presentation/screens/terminal_pane.dart'; // Import the new TerminalPane
import 'package:srishti/presentation/widgets/file_explorer.dart'; // Import the new FileExplorer
import 'package:resizable_widget/resizable_widget.dart'; // Make sure this is in your pubspec.yaml

class IDEScreen extends StatefulWidget {
  const IDEScreen({Key? key}) : super(key: key);

  @override
  _IDEScreenState createState() => _IDEScreenState();
}

class _IDEScreenState extends State<IDEScreen> {
  // Initialize a placeholder project.
  // The files are now part of the Project model.
  final Project _project = Project(
    id: '1',
    userId: 'user123', // Placeholder user ID
    name: 'My First Web Project',
    description: 'An interactive web page.',
    createdAt: DateTime.now(),
    files: Project.defaultFiles(), // Use the static method for default files
  );

  String _selectedFile = 'index.html'; // Default selected file

  // This function is called when the code in the editor changes (e.g., from an editor widget)
  // For now, this is a placeholder as no interactive editor is implemented yet.
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
                    flex: 7, // 70% of the space for CanvasPane (Preview/Editor)
                    child: CanvasPane(
                      key: ValueKey(_selectedFile), // Important for state reset when file changes
                      fileName: _selectedFile,
                      fileContent: _project.files[_selectedFile]!, // Pass content of selected file
                      projectFiles: _project.files, // Pass all project files for potential embedding (e.g., CSS/JS in HTML)
                      onCodeChanged: _updateFileContent, // Callback for when code in editor changes (future use)
                    ),
                  ),
                  const Divider(height: 4, thickness: 4), // Visual separator
                  const Expanded(
                    flex: 3, // 30% of the space for TerminalPane
                    child: TerminalPane(), // Your new TerminalPane
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
