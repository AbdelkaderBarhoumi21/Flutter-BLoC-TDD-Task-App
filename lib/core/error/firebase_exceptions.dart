///Exception Type → Failure Type
///FirebaseAnalyticsException → AnalyticsFailure
///FirebaseCrashlyticsException → CrashlyticsFailure
///FirebasePerformanceException → PerformanceFailure
///FirebaseRemoteConfigException → RemoteConfigFailure
///Other exceptions → Respective failure with "Unexpected error" message
abstract class AppFirebaseException implements Exception {
  const AppFirebaseException(this.message, [this.code]);
  final String message;
  final String? code;
  @override
  String toString() =>
      'AppFirebaseException: $message ${code != null ? '(code: $code)' : ''}';
}

/// Thrown when Firebase Analytics operation fails
class FirebaseAnalyticsException extends AppFirebaseException {
  const FirebaseAnalyticsException([
    super.message = 'Analytics operation failed',
    super.code,
  ]);
}

/// Thrown when Firebase Crashlytics operation fails
class FirebaseCrashlyticsException extends AppFirebaseException {
  const FirebaseCrashlyticsException([
    super.message = 'Crashlytics operation failed',
    super.code,
  ]);
}

/// Thrown when Firebase Performance operation fails
class FirebasePerformanceException extends AppFirebaseException {
  const FirebasePerformanceException([
    super.message = 'Performance monitoring operation failed',
    super.code,
  ]);
}

/// Thrown when Firebase Remote Config operation fails
class FirebaseRemoteConfigException extends AppFirebaseException {
  const FirebaseRemoteConfigException([
    super.message = 'Remote Config operation failed',
    super.code,
  ]);
}

/// Thrown when Firebase initialization fails
class FirebaseInitializationException extends AppFirebaseException {
  const FirebaseInitializationException([
    super.message = 'Firebase initialization failed',
    super.code,
  ]);
}
