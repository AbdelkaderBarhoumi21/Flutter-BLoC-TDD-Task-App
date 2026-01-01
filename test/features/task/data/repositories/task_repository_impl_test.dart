import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/error/exceptions.dart';
import 'package:flutter_task_app/core/error/failures.dart';
import 'package:flutter_task_app/core/network/network_info.dart';
import 'package:flutter_task_app/features/task/data/datasources/task_local_data_source.dart';
import 'package:flutter_task_app/features/task/data/datasources/task_remote_data_source.dart';
import 'package:flutter_task_app/features/task/data/models/task_model.dart';
import 'package:flutter_task_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_repository_impl_test.mocks.dart';

@GenerateMocks([TaskRemoteDataSource, TaskLocalDataSource, NetworkInfo])
void main() {
  late MockTaskRemoteDataSource mockRemoteDataSource;
  late MockTaskLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late TaskRepositoryImpl repository;

  final tTaskModel = TaskModel(
    id: '1',
    title: 'Test Task',
    description: 'Test Description',
    priority: TaskPriority.high,
    status: TaskStatus.pending,
    createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
  );

  setUp(() {
    mockRemoteDataSource = MockTaskRemoteDataSource();
    mockLocalDataSource = MockTaskLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TaskRepositoryImpl(
      networkInfo: mockNetworkInfo,
      taskLocalDataSource: mockLocalDataSource,
      taskRemoteDataSource: mockRemoteDataSource,
    );
  });

  group('getTasks', () {
    test('should return remote tasks and cache them when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getTasks(),
      ).thenAnswer((_) async => [tTaskModel]);
      when(mockLocalDataSource.cacheTasks(any)).thenAnswer((_) async {});

      final result = await repository.getTasks();

      expect(result, isA<Right<Failure, List<TaskEntity>>>());
      final tasks = result.getOrElse(() => const <TaskEntity>[]);
      expect(tasks, equals([tTaskModel]));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.getTasks()).called(1);
      verify(mockLocalDataSource.cacheTasks([tTaskModel])).called(1);
    });

    test(
      'should return ServerFailure when remote throws ServerException',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.getTasks(),
        ).thenThrow(const ServerException('boom'));

        final result = await repository.getTasks();

        expect(result, const Left(ServerFailure('boom')));
      },
    );

    test('should return cached tasks when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        mockLocalDataSource.getCachedTasks(),
      ).thenAnswer((_) async => [tTaskModel]);

      final result = await repository.getTasks();

      expect(result, isA<Right<Failure, List<TaskEntity>>>());
      final tasks = result.getOrElse(() => const <TaskEntity>[]);
      expect(tasks, equals([tTaskModel]));
      verify(mockLocalDataSource.getCachedTasks()).called(1);
      verifyNever(mockRemoteDataSource.getTasks());
    });

    test(
      'should return CacheFailure when cache throws CacheException',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          mockLocalDataSource.getCachedTasks(),
        ).thenThrow(const CacheException());

        final result = await repository.getTasks();

        expect(result, const Left(CacheFailure()));
      },
    );
  });

  group('getTaskById', () {
    test('should return NetworkFailure when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getTaskById('1');

      expect(
        result,
        const Left(NetworkFailure('Cannot fetch task without internet')),
      );
    });

    test('should return task when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getTaskById('1'),
      ).thenAnswer((_) async => tTaskModel);

      final result = await repository.getTaskById('1');

      expect(result, Right(tTaskModel));
      verify(mockRemoteDataSource.getTaskById('1')).called(1);
    });

    test(
      'should return ServerFailure when remote throws ServerException',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.getTaskById('1'),
        ).thenThrow(const ServerException('boom'));

        final result = await repository.getTaskById('1');

        expect(result, const Left(ServerFailure('boom')));
      },
    );
  });

  group('addTask', () {
    test('should return NetworkFailure when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.addTask(tTaskModel);

      expect(
        result,
        const Left(NetworkFailure('Cannot add task without internet')),
      );
    });

    test('should add task and refresh cache when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.addTask(any),
      ).thenAnswer((_) async => tTaskModel);
      when(
        mockRemoteDataSource.getTasks(),
      ).thenAnswer((_) async => [tTaskModel]);
      when(mockLocalDataSource.cacheTasks(any)).thenAnswer((_) async {});

      final result = await repository.addTask(tTaskModel);

      expect(result, Right(tTaskModel));
      verify(mockRemoteDataSource.addTask(any)).called(1);
      verify(mockRemoteDataSource.getTasks()).called(1);
      verify(mockLocalDataSource.cacheTasks([tTaskModel])).called(1);
    });

    test(
      'should return NetworkFailure when remote throws NetworkException',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.addTask(any),
        ).thenThrow(const NetworkException());

        final result = await repository.addTask(tTaskModel);

        expect(result, const Left(NetworkFailure()));
      },
    );
  });

  group('updateTask', () {
    test('should return NetworkFailure when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.updateTask(tTaskModel);

      expect(
        result,
        const Left(NetworkFailure('Cannot update task without internet')),
      );
    });

    test('should update task and refresh cache when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.updateTask(any),
      ).thenAnswer((_) async => tTaskModel);
      when(
        mockRemoteDataSource.getTasks(),
      ).thenAnswer((_) async => [tTaskModel]);
      when(mockLocalDataSource.cacheTasks(any)).thenAnswer((_) async {});

      final result = await repository.updateTask(tTaskModel);

      expect(result, Right(tTaskModel));
      verify(mockRemoteDataSource.updateTask(any)).called(1);
      verify(mockRemoteDataSource.getTasks()).called(1);
      verify(mockLocalDataSource.cacheTasks([tTaskModel])).called(1);
    });
  });

  group('deleteTask', () {
    test('should return NetworkFailure when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.deleteTask('1');

      expect(
        result,
        const Left(NetworkFailure('Cannot delete task without internet')),
      );
    });

    test('should delete task and refresh cache when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.deleteTask('1')).thenAnswer((_) async {});
      when(
        mockRemoteDataSource.getTasks(),
      ).thenAnswer((_) async => [tTaskModel]);
      when(mockLocalDataSource.cacheTasks(any)).thenAnswer((_) async => null);

      final result = await repository.deleteTask('1');

      expect(result, const Right(null));
      verify(mockRemoteDataSource.deleteTask('1')).called(1);
      verify(mockRemoteDataSource.getTasks()).called(1);
      verify(mockLocalDataSource.cacheTasks([tTaskModel])).called(1);
    });
  });
}
