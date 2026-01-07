import 'package:equatable/equatable.dart';

class AnalyticsEventEntity extends Equatable {
  const AnalyticsEventEntity({required this.name, required this.parameters});
  final String name;
  final Map<String, Object?>? parameters;

  @override
  List<Object?> get props => [name, parameters];
}

