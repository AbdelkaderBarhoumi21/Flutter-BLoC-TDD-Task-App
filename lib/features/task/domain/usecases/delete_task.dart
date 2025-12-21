import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/error/failures.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/task/domain/repositories/task_repository.dart';


class DeleteTaskParams {
  const DeleteTaskParams({required this.id});
  final String id;
}

class DeleteTask implements UseCase<void, DeleteTaskParams> {

  DeleteTask(this._repository);
  final TaskRepository _repository;

  @override
  Future<Either<Failure, void>> call(DeleteTaskParams params) async {
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Task ID cannot be empty'));
    }
    return _repository.deleteTask(params.id);
  }
}
