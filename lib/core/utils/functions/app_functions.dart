import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_bloc.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_task_app/features/task/presentation/widgets/custom_task_form.dart';
import 'package:uuid/uuid.dart';

void showTaskDialog(BuildContext context, {TaskEntity? task}) {
  TaskPriority priority = task?.priority ?? TaskPriority.medium;
  TaskStatus status = task?.status ?? TaskStatus.pending;
  String title = task?.title ?? '';
  String description = task?.description ?? '';

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(task == null ? 'Add task' : 'Edit Task'),
      content: SingleChildScrollView(
        child: CustomTaskForm(
          initial: task,
          onChanged: (p, s, t, d) {
            priority = p;
            status = s;
            title = t;
            description = d;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final newTask = TaskEntity(
              id: task?.id ?? const Uuid().v4(),
              title: title,
              description: description,
              priority: priority,
              status: status,
              createdAt: task?.createdAt ?? DateTime.now(),
              completedAt: status == TaskStatus.completed
                  ? DateTime.now()
                  : null,
            );
            if (task == null) {
              context.read<TaskBloc>().add(AddTaskEvent(newTask));
            } else {
              context.read<TaskBloc>().add(UpdateTaskEvent(newTask));
            }
            Navigator.pop(context);
          },
          child: Text(task == null ? 'Add' : 'Update'),
        ),
      ],
    ),
  );
}

void confirmDelete(BuildContext context, String taskId) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Task'),
      content: const Text('Are you sure you want to delete this task?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<TaskBloc>().add(DeleteTaskEvent(taskId));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
