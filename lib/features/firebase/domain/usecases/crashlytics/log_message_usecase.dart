import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';


/// Use case for logging messages to Crashlytics
class LogMessageUseCase implements UseCase<Unit, LogMessageParams> {

  const LogMessageUseCase(this.repository);
  final FirebaseRepository repository;

  @override
  Future<Either<FirebaseFailure, Unit>> call(LogMessageParams params) async {
    // Validate message
    if (params.message.isEmpty) {
      return const Left(CrashlyticsFailure('Message cannot be empty'));
    }

    return await repository.log(params.message);
  }
}

class LogMessageParams extends Equatable {

  const LogMessageParams({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
