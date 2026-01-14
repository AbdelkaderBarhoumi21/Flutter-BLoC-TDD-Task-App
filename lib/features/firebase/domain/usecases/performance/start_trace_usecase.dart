import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/performance_trace_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';


/// Use case for starting a performance trace
class StartTraceUseCase implements UseCase<PerformanceTraceEntity, StartTraceParams> {

  const StartTraceUseCase(this.repository);
  final FirebaseRepository repository;

  @override
  Future<Either<FirebaseFailure, PerformanceTraceEntity>> call(StartTraceParams params) async {
    // Validate trace name
    if (params.name.isEmpty) {
      return const Left(PerformanceFailure('Trace name cannot be empty'));
    }

    // Validate trace name length (max 100 characters)
    if (params.name.length > 100) {
      return const Left(PerformanceFailure('Trace name must be 100 characters or less'));
    }

    return await repository.startTrace(params.name);
  }
}

class StartTraceParams extends Equatable {

  const StartTraceParams({required this.name});
  final String name;

  @override
  List<Object?> get props => [name];
}
