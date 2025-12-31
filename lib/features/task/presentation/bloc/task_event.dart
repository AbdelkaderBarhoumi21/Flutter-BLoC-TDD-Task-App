import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskEvent extends TaskEvent {
  const LoadTaskEvent();
}

class AddTaskEvent extends TaskEvent {
  const AddTaskEvent(this.task);
  final TaskEntity task;

  @override
  List<Object> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  const UpdateTaskEvent(this.task);
  final TaskEntity task;

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  const DeleteTaskEvent(this.taskId);
  final String taskId;

  @override
  List<Object> get props => [taskId];
}
