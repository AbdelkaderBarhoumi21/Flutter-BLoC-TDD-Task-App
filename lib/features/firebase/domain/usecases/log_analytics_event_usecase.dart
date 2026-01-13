import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/analytics_event_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';

/// Use case for logging analytics events
class LogAnalyticsEventUseCase
    implements UseCase<Unit, LogAnalyticsEventParams> {
  LogAnalyticsEventUseCase(this.repository);
  final FirebaseRepository repository;

  @override
  Future<Either<FirebaseFailure, Unit>> call(
    LogAnalyticsEventParams params,
  ) async {
    // Validate event name
    if (params.event.name.isEmpty) {
      return const Left(AnalyticsFailure('Event name cannot be empty'));
    }

    // Validate event name length (max 40 characters)
    if (params.event.name.length > 40) {
      return const Left(
        AnalyticsFailure('Event name must be 40 characters or less'),
      );
    }

    // Validate parameters count (max 25 parameters)
    if (params.event.parameters != null &&
        params.event.parameters!.length > 25) {
      return const Left(
        AnalyticsFailure('Events can have at most 25 parameters'),
      );
    }

    return await repository.logEvent(params.event);
  }
}

class LogAnalyticsEventParams extends Equatable {
  const LogAnalyticsEventParams({required this.event});
  final AnalyticsEventEntity event;

  @override
  List<Object?> get props => [event];
}
