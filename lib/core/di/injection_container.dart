import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_task_app/core/network/network_info.dart';
import 'package:flutter_task_app/features/task/data/datasources/task_local_data_source.dart';
import 'package:flutter_task_app/features/task/data/datasources/task_remote_data_source.dart';
import 'package:flutter_task_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:flutter_task_app/features/task/domain/repositories/task_repository.dart';
import 'package:flutter_task_app/features/task/domain/usecases/add_task.dart';
import 'package:flutter_task_app/features/task/domain/usecases/delete_task.dart';
import 'package:flutter_task_app/features/task/domain/usecases/get_tasks.dart';
import 'package:flutter_task_app/features/task/domain/usecases/update_task.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Feature:Task
  sl.registerFactory(
    () => TaskBloc(
      getTasks: sl(),
      addTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
      logAnalyticsEventUseCase: sl(),
      logErrorUseCase: sl(),
      logMessageUseCase: sl(),
      setCustomKeyUseCase: sl(),
      startTraceUseCase: sl(),
      stopTraceUseCase: sl(),
      addTraceMetricUseCase: sl(),
      getConfigValueUseCase: sl()
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      networkInfo: sl(),
      taskLocalDataSource: sl(),
      taskRemoteDataSource: sl(),
      setCustomKeyUseCase: sl(),
      logErrorUseCase: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(
      client: sl(),
      startTraceUseCase: sl(),
      stopTraceUseCase: sl(),
      addTraceMetricUseCase: sl(),
    ),
  );
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(http.Client.new);
  sl.registerLazySingleton(Connectivity.new);
}
