import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/app_config_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';

/// Use case for getting all config values
class GetAllConfigUseCase implements UseCase<AppConfigEntity, NoParams> {

  const GetAllConfigUseCase(this.repository);
  final FirebaseRepository repository;

  @override
  Future<Either<FirebaseFailure, AppConfigEntity>> call(
    NoParams params,
  ) async => Future.value(repository.getAllConfig());
}
