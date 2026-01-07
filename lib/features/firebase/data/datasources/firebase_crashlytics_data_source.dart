import 'package:flutter_task_app/core/firebase/services/firebase_crashlytics_service.dart';

/// Contract for Crashlytics data source
abstract class FirebaseCrashlyticsDataSource {
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  });
  Future<void> log(String message);
  Future<void> setCustomKey(String key, Object value);
  Future<void> setUserIdentifier(String identifier);
}

/// Implementation of Crashlytics data source
class FirebaseCrashlyticsDataSourceImpl implements FirebaseCrashlyticsDataSource {

  FirebaseCrashlyticsDataSourceImpl({required this.crashlyticsService});
  final FirebaseCrashlyticsService crashlyticsService;

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await crashlyticsService.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  @override
  Future<void> log(String message) async {
    await crashlyticsService.log(message);
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    await crashlyticsService.setCustomKey(key, value);
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    await crashlyticsService.setUserIdentifier(identifier);
  }
}
