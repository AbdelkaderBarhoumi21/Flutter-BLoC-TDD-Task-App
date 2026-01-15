import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/error/exceptions.dart';
import 'package:flutter_task_app/core/error/failures.dart';
import 'package:flutter_task_app/core/network/network_info.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/crashlytics/log_error_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/crashlytics/set_custom_key_usecase.dart';
import 'package:flutter_task_app/features/task/data/datasources/task_local_data_source.dart';
import 'package:flutter_task_app/features/task/data/datasources/task_remote_data_source.dart';
import 'package:flutter_task_app/features/task/data/models/task_model.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';
import 'package:flutter_task_app/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl({
    required this.networkInfo,
    required this.taskLocalDataSource,
    required this.taskRemoteDataSource,
    required this.setCustomKeyUseCase,
    required this.logErrorUseCase,
  });
  final TaskRemoteDataSource taskRemoteDataSource;
  final TaskLocalDataSource taskLocalDataSource;
  final NetworkInfo networkInfo;
  final SetCustomKeyUseCase setCustomKeyUseCase;
  final LogErrorUseCase logErrorUseCase;
  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    if (await networkInfo.isConnected) {
      try {
        // Set additional context
        await setCustomKeyUseCase(
          const SetCustomKeyParams(key: 'operation', value: 'get_tasks'),
        );
        final remoteTasks = await taskRemoteDataSource.getTasks();
        await taskLocalDataSource.cacheTasks(remoteTasks);
        return Right(remoteTasks);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return left(NetworkFailure(e.message));
      } catch (e, stackTrace) {
        // Log error with context
        await logErrorUseCase(
          LogErrorParams(
            error: e,
            stackTrace: stackTrace,
            reason: 'Failed to fetch task from remote data source',
          ),
        );
        // Set additional context
        await setCustomKeyUseCase(
          SetCustomKeyParams(
            key: 'error_timestamp',
            value: DateTime.now().toIso8601String(),
          ),
        );
        return Left(UnexpectedFailure(e.toString()));
      }
    } else {
      try {
        final localTasks = await taskLocalDataSource.getCachedTasks();
        return Right(localTasks);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskById(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Cannot fetch task without internet'));
    }
    try {
      final task = await taskRemoteDataSource.getTaskById(id);
      return Right(task);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return left(NetworkFailure(e.message));
    } catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> addTask(TaskEntity task) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Cannot add task without internet'));
    }
    try {
      final result = await taskRemoteDataSource.addTask(
        TaskModel.fromEntity(task),
      );
      await _updateCacheSafe();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Cannot update task without internet'));
    }
    try {
      final result = await taskRemoteDataSource.updateTask(
        TaskModel.fromEntity(task),
      );
      await _updateCacheSafe();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Cannot delete task without internet'));
    }
    try {
      await taskRemoteDataSource.deleteTask(id);
      await _updateCacheSafe();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<void> _updateCacheSafe() async {
    try {
      final tasks = await taskRemoteDataSource.getTasks();
      await taskLocalDataSource.cacheTasks(tasks);
    } catch (_) {
      // cache refresh is best-effort
    }
  }
}
