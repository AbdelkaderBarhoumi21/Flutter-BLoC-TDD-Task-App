import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/error/failures.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/log_analytics_event_usecase.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';
import 'package:flutter_task_app/features/task/domain/usecases/add_task.dart';
import 'package:flutter_task_app/features/task/domain/usecases/delete_task.dart';
import 'package:flutter_task_app/features/task/domain/usecases/get_tasks.dart';
import 'package:flutter_task_app/features/task/domain/usecases/update_task.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_bloc.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_bloc_test.mocks.dart';

@GenerateMocks([
  GetTasks,
  AddTask,
  UpdateTask,
  DeleteTask,
  LogAnalyticsEventUseCase,
])
void main() {
  late TaskBloc bloc;
  late MockGetTasks mockGetTasks;
  late MockAddTask mockAddTask;
  late MockUpdateTask mockUpdateTask;
  late MockDeleteTask mockDeleteTask;
  late MockLogAnalyticsEventUseCase mockLogAnalyticsEventUseCase;

  final tTask = TaskEntity(
    id: '1',
    title: 'Test Task',
    description: 'Test Description',
    priority: TaskPriority.high,
    status: TaskStatus.pending,
    createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
  );

  setUp(() {
    mockGetTasks = MockGetTasks();
    mockAddTask = MockAddTask();
    mockUpdateTask = MockUpdateTask();
    mockDeleteTask = MockDeleteTask();
    mockLogAnalyticsEventUseCase = MockLogAnalyticsEventUseCase();
    bloc = TaskBloc(
      getTasks: mockGetTasks,
      addTask: mockAddTask,
      updateTask: mockUpdateTask,
      deleteTask: mockDeleteTask,
      logAnalyticsEventUseCase: mockLogAnalyticsEventUseCase,
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  test('initial state should be TaskInitial', () {
    expect(bloc.state, const TaskInitial());
  });

  group('LoadTaskEvent', () {
    test(
      'should emit [TaskLoading, TaskLoaded] when getTasks succeeds',
      () async {
        when(mockGetTasks(any)).thenAnswer((_) async => Right([tTask]));

        final expectation = expectLater(
          bloc.stream,
          emitsInOrder([
            const TaskLoading(),
            TaskLoaded([tTask]),
          ]),
        );

        bloc.add(const LoadTaskEvent());
        await expectation;
      },
    );

    test('should emit [TaskLoading, TaskError] when getTasks fails', () async {
      when(
        mockGetTasks(any),
      ).thenAnswer((_) async => const Left(ServerFailure('boom')));

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([const TaskLoading(), const TaskError('boom')]),
      );

      bloc.add(const LoadTaskEvent());
      await expectation;
    });
  });

  group('AddTaskEvent', () {
    test('should emit success then reload tasks', () async {
      when(mockAddTask(any)).thenAnswer((_) async => Right(tTask));
      when(mockGetTasks(any)).thenAnswer((_) async => Right([tTask]));

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          const TaskLoading(),
          const TaskOperationSuccess('Task added successfully'),
          const TaskLoading(),
          TaskLoaded([tTask]),
        ]),
      );

      bloc.add(AddTaskEvent(tTask));
      await expectation;
    });
  });

  group('UpdateTaskEvent', () {
    test('should emit success then reload tasks', () async {
      when(mockUpdateTask(any)).thenAnswer((_) async => Right(tTask));
      when(mockGetTasks(any)).thenAnswer((_) async => Right([tTask]));

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          const TaskLoading(),
          const TaskOperationSuccess('Task updated successfully'),
          const TaskLoading(),
          TaskLoaded([tTask]),
        ]),
      );

      bloc.add(UpdateTaskEvent(tTask));
      await expectation;
    });
  });

  group('DeleteTaskEvent', () {
    test('should emit success then reload tasks', () async {
      when(mockDeleteTask(any)).thenAnswer((_) async => const Right(null));
      when(mockGetTasks(any)).thenAnswer((_) async => Right([tTask]));

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          const TaskLoading(),
          const TaskOperationSuccess('Task deleted successfully'),
          const TaskLoading(),
          TaskLoaded([tTask]),
        ]),
      );

      bloc.add(const DeleteTaskEvent('1'));
      await expectation;
    });
  });
}
