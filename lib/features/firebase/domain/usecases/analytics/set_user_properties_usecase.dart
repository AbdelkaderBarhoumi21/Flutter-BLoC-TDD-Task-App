import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';

/// Use case for setting user properties
class SetUserPropertiesUseCase implements UseCase<Unit, SetUserPropertiesParams> {
  const SetUserPropertiesUseCase(this.repository);
  final FirebaseRepository repository;

  @override
  Future<Either<FirebaseFailure, Unit>> call(
    SetUserPropertiesParams params,
  ) async {
    // Validate property name
    if (params.name.isEmpty) {
      return const Left(AnalyticsFailure('Property name cannot be empty'));
    }

    // Validate property name length (max 24 characters)
    if (params.name.length > 24) {
      return const Left(
        AnalyticsFailure('Property name must be 24 characters or less'),
      );
    }

    // Validate property value length (max 36 characters)
    if (params.value.length > 36) {
      return const Left(
        AnalyticsFailure('Property value must be 36 characters or less'),
      );
    }

    return await repository.setUserProperty(
      name: params.name,
      value: params.value,
    );
  }
}

class SetUserPropertiesParams extends Equatable {
  const SetUserPropertiesParams({required this.name, required this.value});
  final String name;
  final String value;

  @override
  List<Object?> get props => [name, value];
}
