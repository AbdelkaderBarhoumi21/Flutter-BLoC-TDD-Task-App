import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task_app/core/error/firebase_exceptions.dart';

abstract class FirebaseCrashlyticsService {
  /// Record an error
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  });

  /// Record a Flutter error
  Future<void> recordFlutterError(FlutterErrorDetails details);

  /// Log a message
  Future<void> log(String message);

  /// Set custom key
  Future<void> setCustomKey(String key, Object value);

  /// Set user identifier
  Future<void> setUserIdentifier(String identifier);

  /// Check if crash collection is enabled
  Future<bool> isCrashlyticsCollectionEnabled();

  /// Set crash collection enabled/disabled
  Future<void> setCrashlyticsCollectionEnabled({bool enabled});

  /// Force a crash (for testing)
  void crash();
}

class FirebaseCrashlyticsServiceImpl implements FirebaseCrashlyticsService {
  const FirebaseCrashlyticsServiceImpl(this._crashlytics);
  final FirebaseCrashlytics _crashlytics;
  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    try {
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );

      if (kDebugMode) {
        debugPrint('Crashlytics Error Recorded: $error');
        if (reason != null) debugPrint('Reason: $reason');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Crashlytics recordError failed: $e');
      }
      throw FirebaseCrashlyticsException(
        'Failed to record error',
        e.toString(),
      );
    }
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    try {
      await _crashlytics.recordFlutterError(details);
      if (kDebugMode) {
        debugPrint('Crashlytics Flutter Error Recorded: ${details.exception}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Crashlytics recordFlutterError failed: $e');
      }
      throw FirebaseCrashlyticsException(
        'Failed to record Flutter error',
        e.toString(),
      );
    }
  }

  @override
  Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);

      if (kDebugMode) {
        debugPrint('Crashlytics Log: $message');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Crashlytics log failed: $e');
      }
      throw FirebaseCrashlyticsException('Failed to log message', e.toString());
    }
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    try {
      await _crashlytics.setCustomKey(key, value);

      if (kDebugMode) {
        debugPrint('Crashlytics Custom Key: $key = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Crashlytics setCustomKey failed: $e');
      }
      throw FirebaseCrashlyticsException(
        'Failed to set custom key',
        e.toString(),
      );
    }
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    try {
      await _crashlytics.setUserIdentifier(identifier);

      if (kDebugMode) {
        debugPrint('Crashlytics User ID: $identifier');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Crashlytics setUserIdentifier failed: $e');
      }
      throw FirebaseCrashlyticsException(
        'Failed to set user identifier',
        e.toString(),
      );
    }
  }

  @override
  Future<bool> isCrashlyticsCollectionEnabled() async {
    try {
      return _crashlytics.isCrashlyticsCollectionEnabled;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Crashlytics isCrashlyticsCollectionEnabled failed: $e');
      }
      throw FirebaseCrashlyticsException(
        'Failed to check collection status',
        e.toString(),
      );
    }
  }

  @override
  Future<void> setCrashlyticsCollectionEnabled({bool enabled = false}) async {
    try {
      await _crashlytics.setCrashlyticsCollectionEnabled(enabled);

      if (kDebugMode) {
        debugPrint(
          'Crashlytics collection ${enabled ? 'enabled' : 'disabled'}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Crashlytics setCrashlyticsCollectionEnabled failed: $e');
      }
      throw FirebaseCrashlyticsException(
        'Failed to set collection status',
        e.toString(),
      );
    }
  }

  @override
  void crash() {
    if (kDebugMode) {
      debugPrint('Forcing crash for testing...');
    }
    _crashlytics.crash();
  }
}
