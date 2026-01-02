import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task_app/core/error/firebase_exceptions.dart';

/// Abstract interface for Firebase Analytics operations
abstract class FirebaseAnalyticsService {
  /// Log a custom event
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  });

  /// Log screen view
  Future<void> logScreenView({required String screenName, String? screenClass});

  /// Set user property => User type , app_version , platform ...
  Future<void> setUserProperty({required String name, required String value});

  /// Set user ID => not email or password or some personnel info
  Future<void> setUserId(String? userId);

  /// Reset analytics data => if user logout for example
  Future<void> resetAnalyticsData();

  /// Set analytics collection enabled/disabled
  Future<void> setAnalyticsCollectionEnabled({bool enabled});
}

/// Implementation of Firebase Analytics Service
class FirebaseAnalyticsServiceImpl implements FirebaseAnalyticsService {
  FirebaseAnalyticsServiceImpl(this._analytics);
  final FirebaseAnalytics _analytics;
  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters as Map<String, Object>?,
      );
      if (kDebugMode) {
        debugPrint('Analytics Event: $name with params: $parameters');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Analytics logEvent failed: $e');
      }
      throw FirebaseAnalyticsException(
        'Failed to log event: $name',
        e.toString(),
      );
    }
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      if (kDebugMode) {
        debugPrint('Screen View: $screenName');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Analytics logScreenView failed: $e');
      }
      throw FirebaseAnalyticsException(
        'Failed to log screen view: $screenName',
        e.toString(),
      );
    }
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      if (kDebugMode) {
        debugPrint('User Property: $name = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Analytics setUserProperty failed: $e');
      }
      throw FirebaseAnalyticsException(
        'Failed to set user property: $name',
        e.toString(),
      );
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);

      if (kDebugMode) {
        debugPrint('User ID set: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Analytics setUserId failed: $e');
      }
      throw FirebaseAnalyticsException('Failed to set user ID', e.toString());
    }
  }

  @override
  Future<void> resetAnalyticsData() async {
    try {
      await _analytics.resetAnalyticsData();

      if (kDebugMode) {
        debugPrint('Analytics data reset');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Analytics resetAnalyticsData failed: $e');
      }
      throw FirebaseAnalyticsException(
        'Failed to reset analytics data',
        e.toString(),
      );
    }
  }

  @override
  Future<void> setAnalyticsCollectionEnabled({bool enabled = false}) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);

      if (kDebugMode) {
        debugPrint('Analytics collection ${enabled ? 'enabled' : 'disabled'}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Analytics setAnalyticsCollectionEnabled failed: $e');
      }
      throw FirebaseAnalyticsException(
        'Failed to set analytics collection',
        e.toString(),
      );
    }
  }
}
