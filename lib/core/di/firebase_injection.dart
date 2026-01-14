import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_task_app/core/firebase/firebase_initializer.dart';
import 'package:flutter_task_app/core/firebase/services/firebase_analytics_service.dart';
import 'package:flutter_task_app/core/firebase/services/firebase_crashlytics_service.dart';
import 'package:flutter_task_app/core/firebase/services/firebase_performance_service.dart';
import 'package:flutter_task_app/core/firebase/services/firebase_remote_config_service.dart';
import 'package:flutter_task_app/features/firebase/data/datasources/firebase_analytics_data_source.dart';
import 'package:flutter_task_app/features/firebase/data/datasources/firebase_crashlytics_data_source.dart';
import 'package:flutter_task_app/features/firebase/data/datasources/firebase_performance_data_source.dart';
import 'package:flutter_task_app/features/firebase/data/datasources/firebase_remote_config_data_source.dart';
import 'package:flutter_task_app/features/firebase/data/repositories/firebase_repository_impl.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/log_analytics_event_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/log_screen_view_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/set_user_properties_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/crashlytics/log_error_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/crashlytics/log_message_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/crashlytics/set_custom_key_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/performance/add_trace_metric_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/performance/start_trace_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/performance/stop_trace_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/remote_config/fetch_remote_config_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/remote_config/get_all_config_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/remote_config/get_config_value_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==================== Firebase Initialization ====================
  // Initialize Firebase (must be done before registering services)
  await FirebaseInitializer.initialize();

  // ==================== External Dependencies (Firebase SDK) ====================
  // Firebase instances are singletons managed by Firebase SDK
  sl.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);

  sl.registerLazySingleton<FirebaseCrashlytics>(
    () => FirebaseCrashlytics.instance,
  );

  sl.registerLazySingleton<FirebasePerformance>(
    () => FirebasePerformance.instance,
  );

  sl.registerLazySingleton<FirebaseRemoteConfig>(
    () => FirebaseRemoteConfig.instance,
  );

  // ==================== Core Services ====================

  // Analytics Service
  sl.registerLazySingleton<FirebaseAnalyticsService>(
    () => FirebaseAnalyticsServiceImpl(sl()),
  );

  // Crashlytics Service
  sl.registerLazySingleton<FirebaseCrashlyticsService>(
    () => FirebaseCrashlyticsServiceImpl(sl()),
  );

  // Performance Service
  sl.registerLazySingleton<FirebasePerformanceService>(
    () => FirebasePerformanceServiceImpl(sl()),
  );

  // Remote Config Service
  sl.registerLazySingleton<FirebaseRemoteConfigService>(
    () => FirebaseRemoteConfigServiceImpl(sl()),
  );

  // ==================== Data Sources ====================

  // Analytics Data Source
  sl.registerLazySingleton<FirebaseAnalyticsDataSource>(
    () => FirebaseAnalyticsDataSourceImpl(analyticsService: sl()),
  );

  // Crashlytics Data Source
  sl.registerLazySingleton<FirebaseCrashlyticsDataSource>(
    () => FirebaseCrashlyticsDataSourceImpl(crashlyticsService: sl()),
  );

  // Performance Data Source
  sl.registerLazySingleton<FirebasePerformanceDataSource>(
    () => FirebasePerformanceDataSourceImpl(performanceService: sl()),
  );

  // Remote Config Data Source
  sl.registerLazySingleton<FirebaseRemoteConfigDataSource>(
    () => FirebaseRemoteConfigDataSourceImpl(remoteConfigService: sl()),
  );
  // ==================== Repository ====================

  sl.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(
      analyticsDataSource: sl(),
      crashlyticsDataSource: sl(),
      performanceDataSource: sl(),
      remoteConfigDataSource: sl(),
    ),
  );

  // ==================== Use Cases - Analytics ====================
  sl.registerLazySingleton(() => LogAnalyticsEventUseCase(sl()));
  sl.registerLazySingleton(() => LogScreenViewUseCase(sl()));
  sl.registerLazySingleton(() => SetUserPropertiesUseCase(sl()));

  // ==================== Use Cases - Crashlytics ====================

  sl.registerLazySingleton(() => LogErrorUseCase(sl()));
  sl.registerLazySingleton(() => LogMessageUseCase(sl()));
  sl.registerLazySingleton(() => SetCustomKeyUseCase(sl()));
  // ==================== Use Cases - Performance ====================

  sl.registerLazySingleton(() => StartTraceUseCase(sl()));
  sl.registerLazySingleton(() => StopTraceUseCase(sl()));
  sl.registerLazySingleton(() => AddTraceMetricUseCase(sl()));

  // ==================== Use Cases - Remote Config ====================

  sl.registerLazySingleton(() => FetchRemoteConfig(sl()));
  sl.registerLazySingleton(() => GetConfigValueUseCase(sl()));
  sl.registerLazySingleton(() => GetAllConfigUseCase(sl()));
}

/// Reset all Firebase registrations (for testing)
Future<void> reset() async {
  await sl.reset();
  // FirebaseInitializer.reset();
}
