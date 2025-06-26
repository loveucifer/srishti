import 'package:flutter/material.dart';

class FileExplorer extends StatelessWidget {
  final Map<String, String> files;
  final String selectedFile;
  final ValueChanged<String> onFileSelected;

  const FileExplorer({
    super.key,
    required this.files,
    required this.selectedFile,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1), // Background for file explorer
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Files',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView(
              children: files.keys.map((fileName) {
                final isSelected = fileName == selectedFile;
                return ListTile(
                  title: Text(
                    fileName,
                    style: TextStyle(
                      color: isSelected ? Colors.lightBlueAccent : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  tileColor: isSelected ? Colors.lightBlueAccent.withOpacity(0.2) : null,
                  onTap: () => onFileSelected(fileName),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
