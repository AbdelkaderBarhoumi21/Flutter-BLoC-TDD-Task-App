import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_task_app/core/di/firebase_injection.dart'
    as firebase_di;
import 'package:flutter_task_app/features/firebase/domain/usecases/crashlytics/log_error_usecase.dart';

class GlobalErrorHandler {
  static void initialize() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      // Add the error in the screen in debug model (red screen with error details)
      FlutterError.presentError(details);
      final logError = firebase_di.sl<LogErrorUseCase>();
      logError(
        LogErrorParams(
          error: details.exception,
          stackTrace: details.stack,
          reason: 'Flutter framework error',
        ),
      );
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      final logError = firebase_di.sl<LogErrorUseCase>();
      logError(
        LogErrorParams(
          error: error,
          stackTrace: stack,
          reason: 'Uncaught async error',
          fatal: true,
        ),
      );
      return true; // Tell => I deal with the error (error is logged in firebase and app continue execution )
    };
  }
}
