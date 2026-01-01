import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';
import 'package:flutter_task_app/features/task/domain/repositories/task_repository.dart';
import 'package:flutter_task_app/features/task/domain/usecases/get_tasks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_tasks_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository mockTaskRepository;
  late GetTasks getTasks;

  final tTasks = [
    TaskEntity(
      id: '1',
      title: 'Test Task',
      description: 'Test Description',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      createdAt: DateTime(2024),
    ),
  ];

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    getTasks = GetTasks(mockTaskRepository);
  });

  test('should get tasks from the repository', () async {
    // Arrange
    when(mockTaskRepository.getTasks()).thenAnswer((_) async => Right(tTasks));

    // Act

    final result = await getTasks(const NoParams());

    //Assert
    expect(result, Right(tTasks));
    // Verify

    verify(mockTaskRepository.getTasks()).called(1);
    verifyNoMoreInteractions(mockTaskRepository);
  });
}
