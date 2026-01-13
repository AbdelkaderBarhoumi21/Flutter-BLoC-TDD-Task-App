import 'package:flutter_task_app/core/error/failures.dart';

/// Base failure class for Firebase operations
abstract class FirebaseFailure extends Failure {
  const FirebaseFailure(super.message, [this.code]);
  final String? code;

  @override
  List<Object> get props => [message, code ?? ''];
}

/// Failure when Analytics operation fails
class AnalyticsFailure extends FirebaseFailure {
  const AnalyticsFailure([
    super.message = 'Analytics operation failed',
    super.code,
  ]);
}

/// Failure when Crashlytics operation fails
class CrashlyticsFailure extends FirebaseFailure {
  const CrashlyticsFailure([
    super.message = 'Crashlytics operation failed',
    super.code,
  ]);
}

/// Failure when Performance monitoring operation fails
class PerformanceFailure extends FirebaseFailure {
  const PerformanceFailure([
    super.message = 'Performance monitoring operation failed',
    super.code,
  ]);
}

/// Failure when Remote Config operation fails
class RemoteConfigFailure extends FirebaseFailure {
  const RemoteConfigFailure([
    super.message = 'Remote Config operation failed',
    super.code,
  ]);
}

/// Failure when Firebase initialization fails
class FirebaseInitializationFailure extends FirebaseFailure {
  const FirebaseInitializationFailure([
    super.message = 'Firebase initialization failed',
    super.code,
  ]);
}
