import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/error/failures.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';
import 'package:flutter_task_app/features/task/domain/repositories/task_repository.dart';
import 'package:flutter_task_app/features/task/domain/usecases/update_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late UpdateTask useCase;
  late MockTaskRepository mockTaskRepository;
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
    useCase = UpdateTask(mockTaskRepository);
  });

  group('Update Task', () {
    test('should update task when title is valid', () async {
      when(
        mockTaskRepository.updateTask(any),
      ).thenAnswer((_) async => Right(tTask));

      final result = await useCase(UpdateTaskParams(taskEntity: tTask));

      expect(result, Right(tTask));
      verify(mockTaskRepository.updateTask(tTask)).called(1);
    });

    test('should return ValidationFailure when title is too short', () async {
      final invalidTask = tTask.copyWith(title: 'A');


       
      final result = await useCase(UpdateTaskParams(taskEntity: invalidTask));


      //! fold and expect both are the same but with different approach 
      expect(result, isA<Left<Failure, TaskEntity>>());
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should return failure'),
      );
      verifyZeroInteractions(mockTaskRepository);
    });
  });
}
