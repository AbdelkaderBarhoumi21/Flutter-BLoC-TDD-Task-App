import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/di/firebase_injection.dart'
    as firebase_di;
import 'package:flutter_task_app/core/services/settings_service.dart';
import 'package:flutter_task_app/core/utils/functions/app_functions.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/performance_trace_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/log_screen_view_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/performance/start_trace_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/performance/stop_trace_usecase.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_bloc.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_state.dart';
import 'package:flutter_task_app/features/task/presentation/widgets/custom_task_item.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  PerformanceTraceEntity? _screenTrace;
  @override
  void initState() {
    _logScreenView();
    _startScreenTrace();
    unawaited(_logMaxTasksPerUser());
    super.initState();
  }

  @override
  void dispose() {
    _stopScreenTrace();
    super.dispose();
  }

  Future<void> _logScreenView() async {
    final logScreenView = firebase_di.sl<LogScreenViewUseCase>();
    await logScreenView(
      const LogScreenViewParams(
        screenName: 'TaskPage',
        screenClass: 'TaskListScreen',
      ),
    );
  }

  Future<void> _stopScreenTrace() async {
    if (_screenTrace != null) {
      final stopTrace = firebase_di.sl<StopTraceUseCase>();
      await stopTrace(StopTraceParams(trace: _screenTrace!));
      _screenTrace = null;
    }
  }

  Future<void> _startScreenTrace() async {
    final startTrace = firebase_di.sl<StartTraceUseCase>();
    final result = await startTrace(
      const StartTraceParams(name: 'task_page_load'),
    );
    result.fold(
      (failure) => debugPrint('Failed to start trace: ${failure.message}'),
      (trace) => _screenTrace = trace,
    );
  }

  Future<void> _logMaxTasksPerUser() async {
    final settings = SettingsService();
    final maxTasks = await settings.maxTasksPerUser;
    if (kDebugMode) {
      debugPrint('Remote Config max_tasks_per_user: $maxTasks');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Tasks'),
      actions: [
        IconButton(
          onPressed: () => context.read<TaskBloc>().add(const LoadTaskEvent()),
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskError) {
          _stopScreenTrace();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is TaskLoaded) {
          _stopScreenTrace();
        } else if (state is TaskOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (state is TaskLoaded) {
          if (state.tasks.isEmpty) {
            return const Center(child: Text('No tasks yet. Add one!'));
          }

          return ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];

              return CustomTaskItem(
                task: task,
                onTap: () => showTaskDialog(context, task: task),
                onDelete: () => confirmDelete(context, task.id),
              );
            },
          );
        }

        return const Center(
          child: Text('Pull to refresh or press refresh icon to load tasks'),
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => showTaskDialog(context),
      child: const Icon(Icons.add),
    ),
  );
}
