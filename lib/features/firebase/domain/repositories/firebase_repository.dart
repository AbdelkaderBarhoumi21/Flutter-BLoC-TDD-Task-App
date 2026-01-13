import 'package:dartz/dartz.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/analytics_event_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/app_config_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/performance_trace_entity.dart';

/// Abstract repository for Firebase operations
/// This is the contract that the data layer must implement
abstract class FirebaseRepository {
  /// Log a custom analytics event
  Future<Either<FirebaseFailure, Unit>> logEvent(AnalyticsEventEntity event);

  /// Log a screen view
  Future<Either<FirebaseFailure, Unit>> logScreenView({
    required String screenName,
    String? screenClass,
  });

  /// Set user property
  Future<Either<FirebaseFailure, Unit>> setUserProperty({
    required String name,
    required String value,
  });

  /// Set user ID
  Future<Either<FirebaseFailure, Unit>> setUserId(String? userId);

  // ==================== Crashlytics ====================

  /// Record an error
  Future<Either<FirebaseFailure, Unit>> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  });

  /// Log a message for debugging
  Future<Either<FirebaseFailure, Unit>> log(String message);

  /// Set custom key for crash reports
  Future<Either<FirebaseFailure, Unit>> setCustomKey(String key, Object value);

  /// Set user identifier for crash reports)
  Future<Either<FirebaseFailure, Unit>> setUserIdentifier(String identifier);

  // ==================== Performance ====================

  /// Start a performance trace
  Future<Either<FirebaseFailure, PerformanceTraceEntity>> startTrace(
    String name,
  );

  /// Stop a performance trace
  Future<Either<FirebaseFailure, Unit>> stopTrace(PerformanceTraceEntity trace);

  /// Add trace metric
  Future<Either<FirebaseFailure, Unit>> addTraceMetric(
    PerformanceTraceEntity trace,
    String metricName,
    int value,
  );

  /// Add attribute to a trace
  Future<Either<FirebaseFailure, Unit>> addTraceAttribute(
    PerformanceTraceEntity trace,
    String key,
    String value,
  );

  /// Create HTTP metric
  Either<FirebaseFailure, HttpMetric> createHttpMetric(
    String url,
    HttpMethod method,
  );

  // ==================== Remote Config ====================
  /// Fetch and activate remote config
  Future<Either<FirebaseFailure, bool>> fetchAndActivateConfig();

  /// Get a config value by key
  Either<FirebaseFailure, dynamic> getConfigValue(String key);

  /// Get all config values
  Either<FirebaseFailure, AppConfigEntity> getAllConfig();

  /// Get boolean config value
  Either<FirebaseFailure, bool> getBoolConfig(String key);

  /// Get integer config value
  Either<FirebaseFailure, int> getIntConfig(String key);

  /// Get string config value
  Either<FirebaseFailure, String> getStringConfig(String key);
}
