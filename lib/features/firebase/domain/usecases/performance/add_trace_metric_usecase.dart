import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/core/error/firebase_failure.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/performance_trace_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';


/// Use case for adding metrics to a performance trace
class AddTraceMetricUseCase implements UseCase<Unit, AddTraceMetricParams> {

  const AddTraceMetricUseCase(this.repository);
  final FirebaseRepository repository;

  @override
  Future<Either<FirebaseFailure, Unit>> call(AddTraceMetricParams params) async {
    // Validate metric name
    if (params.metricName.isEmpty) {
      return const Left(PerformanceFailure('Metric name cannot be empty'));
    }

    // Validate value (must be non-negative)
    if (params.value < 0) {
      return const Left(PerformanceFailure('Metric value must be non-negative'));
    }

    return await repository.addTraceMetric(
      params.trace,
      params.metricName,
      params.value,
    );
  }
}

class AddTraceMetricParams extends Equatable {

  const AddTraceMetricParams({
    required this.trace,
    required this.metricName,
    required this.value,
  });
  final PerformanceTraceEntity trace;
  final String metricName;
  final int value;

  @override
  List<Object?> get props => [trace, metricName, value];
}
