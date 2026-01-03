import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task_app/core/error/firebase_exceptions.dart';

abstract class FirebasePerformanceService {
  /// Start a custom trace
  Future<Trace> startTrace(String name);

  /// Stop a trace
  Future<void> stopTrace(Trace trace);

  /// Add metric to a trace
  Future<void> setTraceMetric(Trace trace, String metricName, int value);

  /// Increment a trace metric
  Future<void> incrementTraceMetric(Trace trace, String metricName, int value);

  /// Add attribute to a trace
  Future<void> setTraceAttribute(Trace trace, String key, String value);

  /// Create HTTP metric
  HttpMetric newHttpMetric(String url, HttpMethod httpMethod);

  /// Set performance collection enabled/disabled
  Future<void> setPerformanceCollectionEnabled({bool enabled});

  /// Check if performance collection is enabled
  Future<bool> isPerformanceCollectionEnabled();
}

class FirebasePerformanceServiceImpl implements FirebasePerformanceService {
  const FirebasePerformanceServiceImpl(this._performance);
  final FirebasePerformance _performance;
  @override
  Future<Trace> startTrace(String name) async {
    try {
      final trace = _performance.newTrace(name);
      await trace.start();
      if (kDebugMode) {
        debugPrint('Performance Trace Started: $name');
      }

      return trace;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Performance startTrace failed: $e');
      }
      throw FirebasePerformanceException(
        'Failed to start trace: $name',
        e.toString(),
      );
    }
  }

  @override
  Future<void> stopTrace(Trace trace) async {
    try {
      await trace.stop();
      if (kDebugMode) {
        debugPrint('Performance Trace Stopped');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Performance stopTrace failed: $e');
      }
      throw FirebasePerformanceException('Failed to stop trace', e.toString());
    }
  }

  @override
  Future<void> setTraceMetric(Trace trace, String metricName, int value) async {
    try {
      trace.setMetric(metricName, value);

      if (kDebugMode) {
        debugPrint('Performance Metric: $metricName = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Performance setTraceMetric failed: $e');
      }
      throw FirebasePerformanceException(
        'Failed to set trace metric',
        e.toString(),
      );
    }
  }

  @override
  Future<void> incrementTraceMetric(
    Trace trace,
    String metricName,
    int value,
  ) async {
    try {
      trace.incrementMetric(metricName, value);

      if (kDebugMode) {
        debugPrint('Performance Metric Incremented: $metricName += $value');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Performance incrementTraceMetric failed: $e');
      }
      throw FirebasePerformanceException(
        'Failed to increment trace metric',
        e.toString(),
      );
    }
  }

  @override
  Future<void> setTraceAttribute(Trace trace, String key, String value) async {
    try {
      trace.putAttribute(key, value);

      if (kDebugMode) {
        debugPrint('Performance Attribute: $key = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Performance setTraceAttribute failed: $e');
      }
      throw FirebasePerformanceException(
        'Failed to set trace attribute',
        e.toString(),
      );
    }
  }

  @override
  HttpMetric newHttpMetric(String url, HttpMethod httpMethod) {
    try {
      final metric = _performance.newHttpMetric(url, httpMethod);

      if (kDebugMode) {
        debugPrint('HTTP Metric Created: ${httpMethod.name} $url');
      }

      return metric;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Performance newHttpMetric failed: $e');
      }
      throw FirebasePerformanceException(
        'Failed to create HTTP metric',
        e.toString(),
      );
    }
  }

  @override
  Future<void> setPerformanceCollectionEnabled({bool enabled = false}) async {
    try {
      await _performance.setPerformanceCollectionEnabled(enabled);

      if (kDebugMode) {
        debugPrint(
          'Performance collection ${enabled ? 'enabled' : 'disabled'}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Performance setPerformanceCollectionEnabled failed: $e');
      }
      throw FirebasePerformanceException(
        'Failed to set performance collection',
        e.toString(),
      );
    }
  }

  @override
  Future<bool> isPerformanceCollectionEnabled() async {
    try {
      return _performance.isPerformanceCollectionEnabled();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Performance isPerformanceCollectionEnabled failed: $e');
      }
      throw FirebasePerformanceException(
        'Failed to check performance collection',
        e.toString(),
      );
    }
  }
}
