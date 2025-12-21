import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high }

enum TaskStatus { pending, inProgress, completed }

/// Core business entity - Pure Dart, no Flutter imports
class TaskEntity extends Equatable {
  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) => TaskEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt ?? this.completedAt,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    priority,
    status,
    createdAt,
    completedAt,
  ];

  @override
  String toString() => 'Task(id: $id, title: $title, status: $status)';
}
