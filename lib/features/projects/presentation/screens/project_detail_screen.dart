import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/features/projects/models/project_model.dart';
import 'package:srishti/features/projects/models/task_model.dart';
import 'package:srishti/features/projects/services/task_service.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final Project project;
  const ProjectDetailScreen({super.key, required this.project});

  @override
  ConsumerState<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  late List<DragAndDropList> _taskColumns;

  @override
  Widget build(BuildContext context) {
    final tasksAsyncValue = ref.watch(tasksProvider(widget.project.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: tasksAsyncValue.when(
        data: (tasks) {
          // Build the columns for the drag and drop list
          _taskColumns = [
            _buildTaskList('To Do', tasks),
            _buildTaskList('In Progress', tasks),
            _buildTaskList('Done', tasks),
          ];

          return DragAndDropLists(
            children: _taskColumns,
            onItemReorder: _onItemReorder,
            onListReorder: (oldListIndex, newListIndex) {}, // List reordering not needed
            axis: Axis.horizontal,
            listWidth: 320,
            listPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            listDecoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTaskDialog(context),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add_task),
      ),
    );
  }

  DragAndDropList _buildTaskList(String status, List<Task> allTasks) {
    final tasksInList = allTasks.where((t) => t.status == status).toList();
    return DragAndDropList(
      header: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          status,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ),
      children: tasksInList.map((task) => _buildTaskItem(task)).toList(),
    );
  }

  DragAndDropItem _buildTaskItem(Task task) {
    return DragAndDropItem(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
        color: Colors.white.withOpacity(0.15),
        child: ListTile(
          title: Text(task.title, style: const TextStyle(color: Colors.white)),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            onPressed: () async {
              await ref.read(taskServiceProvider).deleteTask(task.id);
              ref.invalidate(tasksProvider(widget.project.id));
            },
          ),
        ),
      ),
    );
  }

  void _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) async {
    final taskService = ref.read(taskServiceProvider);
    
    // Get the status of the new column
    final newStatus = _taskColumns[newListIndex].header!.child as Text;

    // Find the task that was moved
    final movedTaskTitle = (_taskColumns[oldListIndex].children[oldItemIndex].child as Card).child as ListTile;
    final originalTask = (ref.read(tasksProvider(widget.project.id)).asData!.value)
        .firstWhere((task) => task.title == (movedTaskTitle.title as Text).data);

    // Call the service to update the status in the database
    await taskService.updateTaskStatus(originalTask.id, newStatus.data!);

    // Refresh the provider to show the updated state
    ref.invalidate(tasksProvider(widget.project.id));
  }

  void _showCreateTaskDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1a1a1a),
          title: const Text('Create New Task', style: TextStyle(color: Colors.white)),
          content: TextFormField(
            controller: nameController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Task Title', labelStyle: TextStyle(color: Colors.white70)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await ref.read(taskServiceProvider).createTask(
                        title: nameController.text,
                        projectId: widget.project.id,
                      );
                  ref.invalidate(tasksProvider(widget.project.id));
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('Create', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}