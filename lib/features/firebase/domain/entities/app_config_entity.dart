import 'package:equatable/equatable.dart';

class AppConfigEntity extends Equatable {
  const AppConfigEntity(this.values);
  final Map<String, dynamic> values;

  /// Get value by key with type safety
  T? getValue<T>(String key) {
    final value = values[key];
    if (value is T) {
      return value;
    }
    return null;
  }

  /// Get value with default
  T getValueOrDefault<T>(String key, T defaultValue) => getValue<T>(key) ?? defaultValue;
  @override
  List<Object?> get props => [values];
}
