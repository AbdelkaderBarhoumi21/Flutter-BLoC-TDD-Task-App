import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';

class CustomTaskItem extends StatelessWidget {
  const CustomTaskItem({
    required this.task,
    required this.onTap,
    required this.onDelete,
    super.key,
  });
  final TaskEntity task;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListTile(
      onTap: onTap,
      leading: Icon(_getStatusIcon(), color: _getStatusColor()),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.status == TaskStatus.completed
              ? TextDecoration.lineThrough
              : null,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description.isNotEmpty) Text(task.description),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              Chip(
                label: Text(
                  task.priority.name.toUpperCase(),
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: _getPriorityColor(),
                visualDensity: VisualDensity.compact,
              ),
              Chip(
                label: Text(
                  task.status.name.toUpperCase(),
                  style: const TextStyle(fontSize: 10),
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    ),
  );

  IconData _getStatusIcon() {
    switch (task.status) {
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.inProgress:
        return Icons.timelapse;
      case TaskStatus.pending:
        return Icons.pending;
    }
  }

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.pending:
        return Colors.grey;
    }
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.high:
        return Colors.red.shade100;
      case TaskPriority.medium:
        return Colors.orange.shade100;
      case TaskPriority.low:
        return Colors.green.shade100;
    }
  }
}
