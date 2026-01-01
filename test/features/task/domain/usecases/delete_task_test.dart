import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/error/failures.dart';
import 'package:flutter_task_app/features/task/domain/repositories/task_repository.dart';
import 'package:flutter_task_app/features/task/domain/usecases/delete_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late DeleteTask usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = DeleteTask(mockRepository);
  });
  group('Delete task ', () {
    test('should return ValidationFailure when id is empty', () async {
      final result = await usecase(const DeleteTaskParams(id: ''));

      expect(result, const Left(ValidationFailure('Task ID cannot be empty')));
      verifyZeroInteractions(mockRepository);
    });

    test('should delete task via repository when id is valid', () async {
      when(
        mockRepository.deleteTask('1'),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(const DeleteTaskParams(id: '1'));

      expect(result, const Right(null));
      verify(mockRepository.deleteTask('1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
