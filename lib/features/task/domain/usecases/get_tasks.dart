import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/error/failures.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';
import 'package:flutter_task_app/features/task/domain/repositories/task_repository.dart';

class GetTasks implements UseCase<List<TaskEntity>, NoParams> {
  GetTasks(this._repository);
  final TaskRepository _repository;

  @override
  Future<Either<Failure, List<TaskEntity>>> call(NoParams params) =>
      _repository.getTasks();
}
