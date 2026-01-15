import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/di/firebase_injection.dart'
    as firebase_di;
import 'package:flutter_task_app/core/di/injection_container.dart' as di;
import 'package:flutter_task_app/features/task/presentation/bloc/task_bloc.dart';
import 'package:flutter_task_app/features/task/presentation/bloc/task_event.dart';
import 'package:flutter_task_app/features/task/presentation/pages/task_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Clean Architecture Task App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
    ),
    navigatorObservers: [
      FirebaseAnalyticsObserver(analytics: firebase_di.sl<FirebaseAnalytics>()),
    ],
    home: BlocProvider(
      create: (_) => di.sl<TaskBloc>()..add(const LoadTaskEvent()),
      child: const TaskPage(),
    ),
  );
}
