import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/di/firebase_injection.dart'
    as firebase_di;
import 'package:flutter_task_app/core/utils/functions/app_functions.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/log_screen_view_usecase.dart';
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
  @override
  void initState() {
    _logScreenView();
    super.initState();
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
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
