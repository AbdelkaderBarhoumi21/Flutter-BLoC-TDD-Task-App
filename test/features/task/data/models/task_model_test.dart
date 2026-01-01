import 'dart:convert';

import 'package:flutter_task_app/features/task/data/models/task_model.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  final tTaskModel = TaskModel(
    id: '1',
    title: 'Test Task',
    description: 'Test Description',
    priority: TaskPriority.high,
    status: TaskStatus.pending,
    createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
  );

  test('Should be a subclass of task entity', () {
    expect(tTaskModel, isA<TaskEntity>());
  });

  group('FromJson', () {
    test('Should return a valid model when json is valid', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('task.json')) as Map<String, dynamic>;
      // Act
      final result = TaskModel.fromJson(jsonMap);

      // Assert
      expect(result, tTaskModel);
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing proper data', () {
      // Act
      final result = tTaskModel.toJson();
      final expectedMap = {
        'id': '1',
        'title': 'Test Task',
        'description': 'Test Description',
        'priority': 'high',
        'status': 'pending',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'completedAt': null,
      };

      // Assert
      expect(result, expectedMap);
    });
  });
}
