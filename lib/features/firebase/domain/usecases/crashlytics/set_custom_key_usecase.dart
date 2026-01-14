import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';

/// Use case for setting custom keys in Crashlytics
class SetCustomKeyUseCase implements UseCase<Unit, SetCustomKeyParams> {
  const SetCustomKeyUseCase(this.repository);
  final FirebaseRepository repository;

  @override
  Future<Either<FirebaseFailure, Unit>> call(SetCustomKeyParams params) async {
    // Validate key
    if (params.key.isEmpty) {
      return const Left(CrashlyticsFailure('Custom key cannot be empty'));
    }

    return await repository.setCustomKey(params.key, params.value);
  }
}

class SetCustomKeyParams extends Equatable {
  const SetCustomKeyParams({required this.key, required this.value});
  final String key;
  final Object value;

  @override
  List<Object?> get props => [key, value];
}
