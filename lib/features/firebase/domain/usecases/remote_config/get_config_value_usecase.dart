import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';

/// Use case for getting a specific config value
class GetConfigValueUseCase implements UseCase<dynamic, GetConfigValueParams> {
  const GetConfigValueUseCase(this.repository);
  final FirebaseRepository repository;

  @override
  Future<Either<FirebaseFailure, dynamic>> call(
    GetConfigValueParams params,
  ) async {
    // Validate key
    if (params.key.isEmpty) {
      return const Left(RemoteConfigFailure('Config key cannot be empty'));
    }

    // Return synchronously since config values are cached
    return Future.value(repository.getConfigValue(params.key));
  }
}

class GetConfigValueParams extends Equatable {
  const GetConfigValueParams({required this.key});
  final String key;

  @override
  List<Object?> get props => [key];
}
