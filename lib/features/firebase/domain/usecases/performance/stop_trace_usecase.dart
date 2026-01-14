import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/performance_trace_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';


/// Use case for stopping a performance trace
class StopTraceUseCase implements UseCase<Unit, StopTraceParams> {

  StopTraceUseCase(this.repository);
  final FirebaseRepository repository;

  @override
  Future<Either<FirebaseFailure, Unit>> call(StopTraceParams params) async => await repository.stopTrace(params.trace);
}

class StopTraceParams extends Equatable {

  const StopTraceParams({required this.trace});
  final PerformanceTraceEntity trace;

  @override
  List<Object?> get props => [trace];
}
