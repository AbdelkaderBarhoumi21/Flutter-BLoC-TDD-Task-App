import 'package:flutter_task_app/features/task/data/models/task_model.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';
import 'package:flutter_test/flutter_test.dart';

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
    test('Should return a valid model when json is valid', () {});
  });
}
