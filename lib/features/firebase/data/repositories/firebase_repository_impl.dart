import 'package:dartz/dartz.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task_app/core/error/firebase_exceptions.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/features/firebase/data/datasources/firebase_analytics_data_source.dart';
import 'package:flutter_task_app/features/firebase/data/datasources/firebase_crashlytics_data_source.dart';
import 'package:flutter_task_app/features/firebase/data/datasources/firebase_performance_data_source.dart';
import 'package:flutter_task_app/features/firebase/data/datasources/firebase_remote_config_data_source.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/analytics_event_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/app_config_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/performance_trace_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';


/// Implementation of Firebase Repository
class FirebaseRepositoryImpl implements FirebaseRepository {

  FirebaseRepositoryImpl({
    required this.analyticsDataSource,
    required this.crashlyticsDataSource,
    required this.performanceDataSource,
    required this.remoteConfigDataSource,
  });
  final FirebaseAnalyticsDataSource analyticsDataSource;
  final FirebaseCrashlyticsDataSource crashlyticsDataSource;
  final FirebasePerformanceDataSource performanceDataSource;
  final FirebaseRemoteConfigDataSource remoteConfigDataSource;

  // ==================== Analytics ====================

  @override
  Future<Either<FirebaseFailure, Unit>> logEvent(AnalyticsEventEntity event) async {
    try {
      await analyticsDataSource.logEvent(event);
      return const Right(unit);
    } on FirebaseAnalyticsException catch (e) {
      if (kDebugMode) {
        print('Analytics error: ${e.message}');
      }
      return Left(AnalyticsFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected analytics error: $e');
      }
      return Left(AnalyticsFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await analyticsDataSource.logScreenView(screenName, screenClass);
      return const Right(unit);
    } on FirebaseAnalyticsException catch (e) {
      if (kDebugMode) {
        print('Analytics screen view error: ${e.message}');
      }
      return Left(AnalyticsFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected analytics screen view error: $e');
      }
      return Left(AnalyticsFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await analyticsDataSource.setUserProperty(name, value);
      return const Right(unit);
    } on FirebaseAnalyticsException catch (e) {
      if (kDebugMode) {
        print('Analytics user property error: ${e.message}');
      }
      return Left(AnalyticsFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected analytics user property error: $e');
      }
      return Left(AnalyticsFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> setUserId(String? userId) async {
    try {
      await analyticsDataSource.setUserId(userId);
      return const Right(unit);
    } on FirebaseAnalyticsException catch (e) {
      if (kDebugMode) {
        print('Analytics user ID error: ${e.message}');
      }
      return Left(AnalyticsFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected analytics user ID error: $e');
      }
      return Left(AnalyticsFailure('Unexpected error: $e'));
    }
  }

  // ==================== Crashlytics ====================

  @override
  Future<Either<FirebaseFailure, Unit>> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    try {
      await crashlyticsDataSource.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
      return const Right(unit);
    } on FirebaseCrashlyticsException catch (e) {
      if (kDebugMode) {
        print('Crashlytics error: ${e.message}');
      }
      return Left(CrashlyticsFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected crashlytics error: $e');
      }
      return Left(CrashlyticsFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> log(String message) async {
    try {
      await crashlyticsDataSource.log(message);
      return const Right(unit);
    } on FirebaseCrashlyticsException catch (e) {
      if (kDebugMode) {
        print('Crashlytics log error: ${e.message}');
      }
      return Left(CrashlyticsFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected crashlytics log error: $e');
      }
      return Left(CrashlyticsFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> setCustomKey(
    String key,
    Object value,
  ) async {
    try {
      await crashlyticsDataSource.setCustomKey(key, value);
      return const Right(unit);
    } on FirebaseCrashlyticsException catch (e) {
      if (kDebugMode) {
        print('Crashlytics custom key error: ${e.message}');
      }
      return Left(CrashlyticsFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected crashlytics custom key error: $e');
      }
      return Left(CrashlyticsFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> setUserIdentifier(
    String identifier,
  ) async {
    try {
      await crashlyticsDataSource.setUserIdentifier(identifier);
      return const Right(unit);
    } on FirebaseCrashlyticsException catch (e) {
      if (kDebugMode) {
        print('Crashlytics user identifier error: ${e.message}');
      }
      return Left(CrashlyticsFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected crashlytics user identifier error: $e');
      }
      return Left(CrashlyticsFailure('Unexpected error: $e'));
    }
  }

  // ==================== Performance ====================

  @override
  Future<Either<FirebaseFailure, PerformanceTraceEntity>> startTrace(
    String name,
  ) async {
    try {
      final trace = await performanceDataSource.startTrace(name);
      return Right(trace);
    } on FirebasePerformanceException catch (e) {
      if (kDebugMode) {
        print('Performance start trace error: ${e.message}');
      }
      return Left(PerformanceFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected performance start trace error: $e');
      }
      return Left(PerformanceFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> stopTrace(PerformanceTraceEntity trace) async {
    try {
      await performanceDataSource.stopTrace(trace);
      return const Right(unit);
    } on FirebasePerformanceException catch (e) {
      if (kDebugMode) {
        print('Performance stop trace error: ${e.message}');
      }
      return Left(PerformanceFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected performance stop trace error: $e');
      }
      return Left(PerformanceFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> addTraceMetric(
    PerformanceTraceEntity trace,
    String metricName,
    int value,
  ) async {
    try {
      await performanceDataSource.addTraceMetric(trace, metricName, value);
      return const Right(unit);
    } on FirebasePerformanceException catch (e) {
      if (kDebugMode) {
        print('Performance add metric error: ${e.message}');
      }
      return Left(PerformanceFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected performance add metric error: $e');
      }
      return Left(PerformanceFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> addTraceAttribute(
    PerformanceTraceEntity trace,
    String key,
    String value,
  ) async {
    try {
      await performanceDataSource.addTraceAttribute(trace, key, value);
      return const Right(unit);
    } on FirebasePerformanceException catch (e) {
      if (kDebugMode) {
        print('Performance add attribute error: ${e.message}');
      }
      return Left(PerformanceFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected performance add attribute error: $e');
      }
      return Left(PerformanceFailure('Unexpected error: $e'));
    }
  }

  @override
  Either<FirebaseFailure, HttpMetric> createHttpMetric(
    String url,
    HttpMethod method,
  ) {
    try {
      final metric = performanceDataSource.createHttpMetric(url, method);
      return Right(metric);
    } on FirebasePerformanceException catch (e) {
      if (kDebugMode) {
        print('Performance create HTTP metric error: ${e.message}');
      }
      return Left(PerformanceFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected performance create HTTP metric error: $e');
      }
      return Left(PerformanceFailure('Unexpected error: $e'));
    }
  }

  // ==================== Remote Config ====================

  @override
  Future<Either<FirebaseFailure, bool>> fetchAndActivateConfig() async {
    try {
      final activated = await remoteConfigDataSource.fetchAndActivate();
      return Right(activated);
    } on FirebaseRemoteConfigException catch (e) {
      if (kDebugMode) {
        print('Remote Config fetch error: ${e.message}');
      }
      return Left(RemoteConfigFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Remote Config fetch error: $e');
      }
      return Left(RemoteConfigFailure('Unexpected error: $e'));
    }
  }

  @override
  Either<FirebaseFailure, dynamic> getConfigValue(String key) {
    try {
      final value = remoteConfigDataSource.getValue(key);
      return Right(value);
    } on FirebaseRemoteConfigException catch (e) {
      if (kDebugMode) {
        print('Remote Config get value error: ${e.message}');
      }
      return Left(RemoteConfigFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Remote Config get value error: $e');
      }
      return Left(RemoteConfigFailure('Unexpected error: $e'));
    }
  }

  @override
  Either<FirebaseFailure, AppConfigEntity> getAllConfig() {
    try {
      final config = remoteConfigDataSource.getAllValues();
      return Right(config);
    } on FirebaseRemoteConfigException catch (e) {
      if (kDebugMode) {
        print('Remote Config get all error: ${e.message}');
      }
      return Left(RemoteConfigFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Remote Config get all error: $e');
      }
      return Left(RemoteConfigFailure('Unexpected error: $e'));
    }
  }

  @override
  Either<FirebaseFailure, bool> getBoolConfig(String key) {
    try {
      final value = remoteConfigDataSource.getBool(key);
      return Right(value);
    } on FirebaseRemoteConfigException catch (e) {
      if (kDebugMode) {
        print('Remote Config get bool error: ${e.message}');
      }
      return Left(RemoteConfigFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Remote Config get bool error: $e');
      }
      return Left(RemoteConfigFailure('Unexpected error: $e'));
    }
  }

  @override
  Either<FirebaseFailure, int> getIntConfig(String key) {
    try {
      final value = remoteConfigDataSource.getInt(key);
      return Right(value);
    } on FirebaseRemoteConfigException catch (e) {
      if (kDebugMode) {
        print('Remote Config get int error: ${e.message}');
      }
      return Left(RemoteConfigFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Remote Config get int error: $e');
      }
      return Left(RemoteConfigFailure('Unexpected error: $e'));
    }
  }

  @override
  Either<FirebaseFailure, String> getStringConfig(String key) {
    try {
      final value = remoteConfigDataSource.getString(key);
      return Right(value);
    } on FirebaseRemoteConfigException catch (e) {
      if (kDebugMode) {
        print('Remote Config get string error: ${e.message}');
      }
      return Left(RemoteConfigFailure(e.message, e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Remote Config get string error: $e');
      }
      return Left(RemoteConfigFailure('Unexpected error: $e'));
    }
  }
}
