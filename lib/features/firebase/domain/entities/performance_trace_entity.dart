import 'package:equatable/equatable.dart';
import 'package:firebase_performance/firebase_performance.dart';

class PerformanceTraceEntity extends Equatable {
  const PerformanceTraceEntity({
    required this.trace,
    required this.name,
    required this.startTime,
  });
  final Trace trace;
  final String name;
  final DateTime startTime;
  @override
  List<Object?> get props => [name,startTime];
}
