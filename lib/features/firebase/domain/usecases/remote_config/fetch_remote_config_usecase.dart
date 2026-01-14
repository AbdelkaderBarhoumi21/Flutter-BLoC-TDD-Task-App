import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';

/// Use case for fetching and activating remote config
class FetchRemoteConfig implements UseCase<bool, FetchRemoteConfigParams> {
  const FetchRemoteConfig(this.repository);
  final FirebaseRepository repository;

  @override
  Future<Either<FirebaseFailure, bool>> call(
    FetchRemoteConfigParams params,
  ) async => await repository.fetchAndActivateConfig();
}

class FetchRemoteConfigParams extends Equatable {
  const FetchRemoteConfigParams();

  @override
  List<Object?> get props => [];
}
