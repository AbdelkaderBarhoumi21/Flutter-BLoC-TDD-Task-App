import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';

class CustomTaskForm extends StatefulWidget {
  const CustomTaskForm({
    required this.initial,
    required this.onChanged,
    super.key,
  });
  final TaskEntity? initial;
  final void Function(
    TaskPriority priority,
    TaskStatus status,
    String title,
    String description,
  )
  onChanged;

  @override
  State<CustomTaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<CustomTaskForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  late TaskPriority _priority;
  late TaskStatus _status;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initial?.title ?? '');
    _descController = TextEditingController(
      text: widget.initial?.description ?? '',
    );
    _priority = widget.initial?.priority ?? TaskPriority.medium;
    _status = widget.initial?.status ?? TaskStatus.pending;

    _notify();
    _titleController.addListener(_notify);
    _descController.addListener(_notify);
  }

  void _notify() {
    widget.onChanged(
      _priority,
      _status,
      _titleController.text,
      _descController.text,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<TaskPriority>(
          value: _priority,
          decoration: const InputDecoration(
            labelText: 'Priority',
            border: OutlineInputBorder(),
          ),
          items: TaskPriority.values
              .map(
                (p) => DropdownMenuItem(
                  value: p,
                  child: Text(p.name.toUpperCase()),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _priority = value);
            _notify();
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<TaskStatus>(
          value: _status,
          decoration: const InputDecoration(
            labelText: 'Status',
            border: OutlineInputBorder(),
          ),
          items: TaskStatus.values
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(s.name.toUpperCase()),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _status = value);
            _notify();
          },
        ),
      ],
    );
  }
}
