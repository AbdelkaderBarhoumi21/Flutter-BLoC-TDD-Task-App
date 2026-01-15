import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_app/core/di/firebase_injection.dart'
    as firebase_di;
import 'package:flutter_task_app/core/di/injection_container.dart' as di;
import 'package:flutter_task_app/core/error/global_error_handler.dart';
import 'package:flutter_task_app/core/my_app/my_app.dart';
import 'package:flutter_task_app/core/utils/constants/app_analytics_events.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/analytics_event_entity.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/log_analytics_event_usecase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalErrorHandler.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
