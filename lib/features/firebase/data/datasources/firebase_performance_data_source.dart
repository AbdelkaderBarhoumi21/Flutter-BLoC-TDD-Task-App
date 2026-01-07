import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_task_app/core/firebase/services/firebase_performance_service.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/performance_trace_entity.dart';

/// Contract for Performance data source
abstract class FirebasePerformanceDataSource {
  Future<PerformanceTraceEntity> startTrace(String name);
  Future<void> stopTrace(PerformanceTraceEntity trace);
  Future<void> addTraceMetric(
    PerformanceTraceEntity trace,
    String metricName,
    int value,
  );
  Future<void> addTraceAttribute(
    PerformanceTraceEntity trace,
    String key,
    String value,
  );
  HttpMetric createHttpMetric(String url, HttpMethod method);
}

/// Implementation of Performance data source
class FirebasePerformanceDataSourceImpl
    implements FirebasePerformanceDataSource {
  const FirebasePerformanceDataSourceImpl(this.performanceService);
  final FirebasePerformanceService performanceService;

  @override
  Future<PerformanceTraceEntity> startTrace(String name) async {
    final trace = await performanceService.startTrace(name);

    return PerformanceTraceEntity(
      trace: trace,
      name: name,
      startTime: DateTime.now(),
    );
  }

  @override
  Future<void> stopTrace(PerformanceTraceEntity trace) async {
    await performanceService.stopTrace(trace.trace);
  }

  @override
  Future<void> addTraceMetric(
    PerformanceTraceEntity trace,
    String metricName,
    int value,
  ) async {
    await performanceService.setTraceMetric(trace.trace, metricName, value);
  }

  @override
  Future<void> addTraceAttribute(
    PerformanceTraceEntity trace,
    String key,
    String value,
  ) async {
    await performanceService.setTraceAttribute(trace.trace, key, value);
  }

  @override
  HttpMetric createHttpMetric(String url, HttpMethod method) =>
      performanceService.newHttpMetric(url, method);
}
