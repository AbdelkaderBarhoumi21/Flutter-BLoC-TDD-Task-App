import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';

class LogErrorUseCase implements UseCase<Unit, LogErrorParams> {
  const LogErrorUseCase(this.repository);
  final FirebaseRepository repository;
  @override
  Future<Either<FirebaseFailure, Unit>> call(LogErrorParams params) =>
      repository.recordError(
        params.error,
        params.stackTrace,
        reason: params.reason,
        fatal: params.fatal,
      );
}

class LogErrorParams extends Equatable {

  const LogErrorParams({
    required this.error,
    this.stackTrace,
    this.reason,
    this.fatal = false,
  });
  final Object error;
  final StackTrace? stackTrace;
  final String? reason;
  final bool fatal;
  @override
  List<Object?> get props => [error, stackTrace, reason, fatal];
}
