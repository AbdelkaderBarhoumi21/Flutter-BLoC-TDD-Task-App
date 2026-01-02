import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task_app/core/error/firebase_exceptions.dart';
import 'package:flutter_task_app/firebase_options.dart';

class FirebaseInitializer {
  static bool _isInitialized = false;

  /// Initialize Firebase and all its services
  static Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      // Initialize firebase core
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      // Initialize Crashlytics
      await _initializeCrashlytics();
      // Initialize Remote Config
      await _initializeRemoteConfig();
      // Initialize Analytics (auto-initialized with Firebase.initializeApp)
      // Initialize Performance (auto-initialized with Firebase.initializeApp)
      _isInitialized = true;
      if (kDebugMode) {
        debugPrint('Firebase initialized successfully');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Firebase initialization failed: $e');
        debugPrint('stack trace : ${stackTrace.toString()}');
      }
      throw FirebaseInitializationException(
        'Failed to initialize Firebase: $e',
      );
    }
  }

  /// Initialize Firebase Crashlytics
  static Future<void> _initializeCrashlytics() async {
    try {
      // Pass all uncaught errors to Crashlytics
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      // Pass all uncaught asynchronous errors to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // Enable Crashlytics collection

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

      if (kDebugMode) {
        debugPrint('Crashlytics initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Crashlytics initialization failed: $e');
      }
      // Don't throw - Crashlytics is not critical => mean if not initialized the app work this service is not mandatory
    }
  }

  /// Initialize Firebase Remote Config
  static Future<void> _initializeRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      // Set configuration settings
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode
              ? Duration
                    .zero // No cache in debug
              : const Duration(hours: 1), // 1 hour cache in production
        ),
      );

      // Set default values
      await remoteConfig.setDefaults(const {
        'max_tasks_per_user': 100,
        'enable_notifications': true,
        'api_timeout_seconds': 30,
        'show_completed_tasks': true,
        'task_sync_interval_minutes': 15,
      });

      // Fetch and activate => this ensure fetch the last values and ensure that the last values are used => can use fetch and activate separately
      await remoteConfig.fetchAndActivate();
      if (kDebugMode) {
        debugPrint('Remote Config initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Remote Config initialization failed: $e');
      }
      // Don't throw - Remote Config is not critical
    }
  }

  static bool get isInitialized => _isInitialized;

  /// Reset initialization status (for testing)
  @visibleForTesting
  static void reset() {
    _isInitialized = false;
  }
}
