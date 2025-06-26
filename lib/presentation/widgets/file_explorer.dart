import 'package:flutter/material.dart';

class FileExplorer extends StatelessWidget {
  final Map<String, String> files;
  final String? selectedFile;
  final Function(String) onFileSelected;

  const FileExplorer({
    Key? key,
    required this.files,
    this.selectedFile,
    required this.onFileSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
      child: ListView(
        children: files.keys.map((fileName) {
          final isSelected = fileName == selectedFile;
          return Material(
            color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Colors.transparent,
            child: InkWell(
              onTap: () => onFileSelected(fileName),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [
                    Icon(_getIconForFile(fileName), size: 18, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(child: Text(fileName)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIconForFile(String fileName) {
    if (fileName.endsWith('.html')) return Icons.code;
    if (fileName.endsWith('.css')) return Icons.color_lens_outlined;
    if (fileName.endsWith('.js')) return Icons.javascript;
    return Icons.insert_drive_file_outlined;
  }
}