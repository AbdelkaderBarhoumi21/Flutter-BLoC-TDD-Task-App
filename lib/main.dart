import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/di/firebase_injection.dart'
    as firebase_di;
import 'package:flutter_task_app/core/di/injection_container.dart' as di;
import 'package:flutter_task_app/core/utils/constants/app_analytics_events.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/analytics_event_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/log_analytics_event_usecase.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_bloc.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_task_app/features/task/presentation/pages/task_page.dart';
import 'package:flutter_task_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint(
      '===================Firebase initialized successfully====================',
    );
  } catch (e, stackTrace) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint(stackTrace.toString());
  }
  // Initialize dependency injection
  try {
    await di.init();
    await firebase_di.init();
    debugPrint(
      '=================Dependency injection initialized successfully=================',
    );
  } catch (e, stackTrace) {
    debugPrint(
      '=================Dependency injection failed: $e=================',
    );
    debugPrint(stackTrace.toString());
  }

  try {
    final logAnalyticsEvent = firebase_di.sl<LogAnalyticsEventUseCase>();
    await logAnalyticsEvent(
      LogAnalyticsEventParams(
        event: AnalyticsEventEntity(
          name: AppAnalyticsEvents.appOpened,
          parameters: {
            AppAnalyticsParameters.timestamp: DateTime.now().toIso8601String(),
          },
        ),
      ),
    );
  } catch (e) {
    debugPrint('Failed to log app opened event: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Clean Architecture Task App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
    home: BlocProvider(
      create: (_) => di.sl<TaskBloc>()..add(const LoadTaskEvent()),
      child: const TaskPage(),
    ),
  );
}
