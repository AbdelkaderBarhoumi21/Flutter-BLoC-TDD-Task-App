import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/usecases/usescase.dart';
import 'package:flutter_task_app/core/utils/constants/app_analytics_events.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/analytics_event_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/log_analytics_event_usecase.dart';
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
  }) : super(const TaskInitial()) {
    on<LoadTaskEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }
  final LogAnalyticsEventUseCase logAnalyticsEventUseCase;
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  Future<void> _onLoadTasks(
    LoadTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    final result = await getTasks(const NoParams());
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(TaskLoaded(tasks)),
    );
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    final result = await addTask(AddTaskParams(taskEntity: event.task));
    result.fold(
      (failure) {
        // Log error event
        logAnalyticsEventUseCase(
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
        emit(TaskError(failure.message));
      },
      (_) {
        // Log success event
        logAnalyticsEventUseCase(
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
