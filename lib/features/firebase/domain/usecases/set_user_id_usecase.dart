import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';

/// Use case for setting user ID
class SetUserIdUseCase implements UseCase<Unit, SetUserIdParams> {
  const SetUserIdUseCase(this.repository);
  final FirebaseRepository repository;

  @override
  Future<Either<FirebaseFailure, Unit>> call(SetUserIdParams params) async {
    // Validate user id name
    if (params.userId!.isEmpty) {
      return const Left(AnalyticsFailure('User ID cannot be empty'));
    }

    // Validate user ID length (max 256 characters per Firebase guidelines)
    if (params.userId != null && params.userId!.length > 256) {
      return const Left(
        AnalyticsFailure('User ID must be 256 characters or less'),
      );
    }

    return await repository.setUserId(params.userId);
  }
}

class SetUserIdParams extends Equatable {
  const SetUserIdParams({this.userId});
  final String? userId;

  @override
  List<Object?> get props => [userId];
}
