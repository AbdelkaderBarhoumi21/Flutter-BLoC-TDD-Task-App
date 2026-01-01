
import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/error/failures.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';
import 'package:flutter_task_app/features/task/domain/repositories/task_repository.dart';
import 'package:flutter_task_app/features/task/domain/usecases/get_task_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_task_by_id_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository mockTaskRepository;
  late GetTaskById useCase;
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
    useCase = GetTaskById(mockTaskRepository);
  });

  group('GetTaskById', () {
    test('Should return Validation failure when id is empty', () async {
      // Act
      final result = await useCase(const GetTaskByIdParams(''));
      // Assert
      expect(result, const Left(ValidationFailure('Task ID cannot be empty')));

      //Verify
      verifyZeroInteractions(mockTaskRepository);
    });

    test('should get task by id from repository', () async {
      // Arrange
      when(
        mockTaskRepository.getTaskById('1'),
      ).thenAnswer((_) async => Right(tTask));

      // Act

      final result = await useCase(const GetTaskByIdParams('1'));

      // Assert
      expect(result, Right(tTask));

      // Verify
      verify(mockTaskRepository.getTaskById('1')).called(1);
      verifyNoMoreInteractions(mockTaskRepository);
    });
  });
}
