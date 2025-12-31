import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  const TaskLoaded(this.tasks);
  final List<TaskEntity> tasks;

  @override
  List<Object?> get props => [tasks];
}

class TaskError extends TaskState {
  const TaskError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class TaskOperationSuccess extends TaskState {
  const TaskOperationSuccess(this.message);
  final String message;
  @override

  List<Object?> get props => [message];
}
