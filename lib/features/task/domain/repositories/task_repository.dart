import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/error/failures.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';

/// Repository contract - domain doesn't know implementation details
abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, TaskEntity>> getTaskById(String id);
  Future<Either<Failure, TaskEntity>> addTask(TaskEntity task);
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task);
  Future<Either<Failure, void>> deleteTask(String id);
}