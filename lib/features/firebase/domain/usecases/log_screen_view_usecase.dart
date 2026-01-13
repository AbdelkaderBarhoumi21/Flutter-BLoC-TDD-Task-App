import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';

class LogScreenViewUseCase implements UseCase<Unit, LogScreenViewParams> {
  const LogScreenViewUseCase(this.repository);
  final FirebaseRepository repository;

  Future<Either<FirebaseFailure, Unit>> call(LogScreenViewParams params) async {
    if (params.screenName.isEmpty) {
      return const Left(AnalyticsFailure('Screen name cannot be empty'));
    }
    return repository.logScreenView(
      screenName: params.screenName,
      screenClass: params.screenClass,
    );
  }
}

class LogScreenViewParams extends Equatable {
  const LogScreenViewParams({required this.screenName, this.screenClass});
  final String screenName;
  final String? screenClass;
  @override
  List<Object?> get props => [screenName, screenClass];
}
