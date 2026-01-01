import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/error/failures.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';
import 'package:flutter_task_app/features/task/domain/repositories/task_repository.dart';
import 'package:flutter_task_app/features/task/domain/usecases/add_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository mockTaskRepository;
  late AddTask useCase;
  final tTask = TaskEntity(
    id: '1',
    title: 'Test Task',
    description: 'Test Description',
    priority: TaskPriority.high,
    status: TaskStatus.pending,
    createdAt: DateTime(2024),
  );
  setUp(() {
    mockTaskRepository = MockTaskRepository();
    useCase = AddTask(mockTaskRepository);
  });

  group('AddTask', () {
    test('Should return Task when title is valid', () async {
      // Arrange

      when(
        mockTaskRepository.addTask(any),
      ).thenAnswer((_) async => Right(tTask));

      // Act
      final result = await useCase(AddTaskParams(taskEntity: tTask));
      // Assert
      expect(result, Right(tTask));
      // Verify
      verify(mockTaskRepository.addTask(tTask)).called(1);
      verifyNoMoreInteractions(mockTaskRepository);
    });

    test('Should return validation error when title is too short', () async {
      final invalidTask = tTask.copyWith(title: 'AB');
      // Act
      final result = await useCase(AddTaskParams(taskEntity: invalidTask));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should return failure'),
      );
      verifyZeroInteractions(mockTaskRepository);
    });
  });
}
