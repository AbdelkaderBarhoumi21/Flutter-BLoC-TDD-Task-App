import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/core/utils/constants/app_analytics_events.dart';
import 'package:flutter_task_app/core/utils/constants/app_config_keys.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/analytics_event_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/log_analytics_event_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/crashlytics/log_error_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/crashlytics/log_message_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/crashlytics/set_custom_key_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/performance/add_trace_metric_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/performance/start_trace_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/performance/stop_trace_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/remote_config/get_config_value_usecase.dart';
import 'package:flutter_task_app/features/task/domain/usecases/add_task.dart';
import 'package:flutter_task_app/features/task/domain/usecases/delete_task.dart';
import 'package:flutter_task_app/features/task/domain/usecases/get_tasks.dart';
import 'package:flutter_task_app/features/task/domain/usecases/update_task.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.logAnalyticsEventUseCase,
    required this.logErrorUseCase,
    required this.logMessageUseCase,
    required this.setCustomKeyUseCase,
    required this.startTraceUseCase,
    required this.stopTraceUseCase,
    required this.addTraceMetricUseCase,
    required this.getConfigValueUseCase,
  }) : super(const TaskInitial()) {
    on<LoadTaskEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }
  // Firebase Analytics
  final LogAnalyticsEventUseCase logAnalyticsEventUseCase;

  // Firebase Crashlytics
  final LogErrorUseCase logErrorUseCase;
  final LogMessageUseCase logMessageUseCase;
  final SetCustomKeyUseCase setCustomKeyUseCase;

  // Firebase Performance
  final StartTraceUseCase startTraceUseCase;
  final StopTraceUseCase stopTraceUseCase;
  final AddTraceMetricUseCase addTraceMetricUseCase;

  // Remote config
  final GetConfigValueUseCase getConfigValueUseCase;

  // Task use case
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  Future<void> _onLoadTasks(
    LoadTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    // Log breadcrumb  =>  events/actions that happened before a crash or error occurred. to helps you understand what the user was doing
    await logMessageUseCase(const LogMessageParams(message: 'Loading tasks'));

    // Start performance trace
    final traceResult = await startTraceUseCase(
      const StartTraceParams(name: 'load_tasks'),
    );

    emit(const TaskLoading());

    // Get max tasks from remote config
    final maxTasksResult = await getConfigValueUseCase(
      const GetConfigValueParams(key: AppConfigKeys.maxTasksPerUser),
    );
    final maxTasks = maxTasksResult.fold((f) => 100, (v) => v as int);

    // Set Crashlytics context
    await setCustomKeyUseCase(
      SetCustomKeyParams(key: 'max_tasks', value: maxTasks),
    );
    final result = await getTasks(const NoParams());
    await result.fold<Future<void>>(
      (failure) async {
        // Log error
        await logErrorUseCase(
          LogErrorParams(error: failure, reason: 'Failed to load tasks'),
        );
        // Log analytics
        await logAnalyticsEventUseCase(
          LogAnalyticsEventParams(
            event: AnalyticsEventEntity(
              name: AppAnalyticsEvents.errorOccurred,
              parameters: {
                'error_type': 'load_tasks_failed',
                'error_message': failure.message,
              },
            ),
          ),
        );
        // Stop trace
        if (traceResult.isRight()) {
          final trace = traceResult.getOrElse(() => throw Exception());
          await stopTraceUseCase(StopTraceParams(trace: trace));
        }

        if (emit.isDone) {
          return;
        }
        emit(TaskError(failure.message));
      },
      (tasks) async {
        // Add metric to trace
        if (traceResult.isRight()) {
          final trace = traceResult.getOrElse(() => throw Exception());
          await addTraceMetricUseCase(
            AddTraceMetricParams(
              trace: trace,
              metricName: 'tasks_loaded',
              value: tasks.length,
            ),
          );
          await stopTraceUseCase(StopTraceParams(trace: trace));
        }
        // Log analytics
        await logAnalyticsEventUseCase(
          LogAnalyticsEventParams(
            event: AnalyticsEventEntity(
              name: 'tasks_loaded',
              parameters: {'task_count': tasks.length},
            ),
          ),
        );
        if (emit.isDone) {
          return;
        }
        emit(TaskLoaded(tasks));
      },
    );
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    // Log breadcrumb
    await logMessageUseCase(
      LogMessageParams(message: 'Adding task: ${event.task.title}'),
    );
    // Start trace
    final traceResult = await startTraceUseCase(
      const StartTraceParams(name: 'add_task'),
    );

    emit(const TaskLoading());
    final result = await addTask(AddTaskParams(taskEntity: event.task));
    await result.fold<Future<void>>(
      (failure) async {
        // Log error
        await logErrorUseCase(
          LogErrorParams(error: failure, reason: 'Failed to add task'),
        );
        // Log error event
        await logAnalyticsEventUseCase(
          LogAnalyticsEventParams(
            event: AnalyticsEventEntity(
              name: AppAnalyticsEvents.errorOccurred,
              parameters: {
                AppAnalyticsParameters.errorType: 'add_task_failed',
                AppAnalyticsParameters.errorMessage: failure.message,
              },
            ),
          ),
        );
        // Stop trace
        if (traceResult.isRight()) {
          final trace = traceResult.getOrElse(() => throw Exception());
          await stopTraceUseCase(StopTraceParams(trace: trace));
        }
        if (emit.isDone) {
          return;
        }
        emit(TaskError(failure.message));
      },
      (_) async {
        // Log success event
        await logAnalyticsEventUseCase(
          LogAnalyticsEventParams(
            event: AnalyticsEventEntity(
              name: AppAnalyticsEvents.taskAdded,
              parameters: {
                AppAnalyticsParameters.taskId: event.task.id,
                AppAnalyticsParameters.taskPriority: event.task.priority.name,
                AppAnalyticsParameters.taskStatus: event.task.status.name,
                AppAnalyticsParameters.timestamp: DateTime.now()
                    .toIso8601String(),
              },
            ),
          ),
        );
        if (emit.isDone) {
          return;
        }
        emit(const TaskOperationSuccess('Task added successfully'));
        add(const LoadTaskEvent());
      },
    );
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    final result = await updateTask(UpdateTaskParams(taskEntity: event.task));
    result.fold((failure) => emit(TaskError(failure.message)), (_) {
      emit(const TaskOperationSuccess('Task updated successfully'));
      add(const LoadTaskEvent());
    });
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    final result = await deleteTask(DeleteTaskParams(id: event.taskId));
    result.fold((failure) => emit(TaskError(failure.message)), (_) {
      emit(const TaskOperationSuccess('Task deleted successfully'));
      add(const LoadTaskEvent());
    });
  }
}
