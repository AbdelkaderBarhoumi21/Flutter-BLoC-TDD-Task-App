
import 'package:flutter_task_app/core/firebase/services/firebase_analytics_service.dart';
import 'package:flutter_task_app/features/firebase/domain/entities/analytics_event_entity.dart';

/// Contract for Analytics data source
abstract class FirebaseAnalyticsDataSource {
  Future<void> logEvent(AnalyticsEventEntity event);
  Future<void> logScreenView(String screenName, String? screenClass);
  Future<void> setUserProperty(String name, String value);
  Future<void> setUserId(String? userId);
}

/// Implementation of Analytics data source
class FirebaseAnalyticsDataSourceImpl implements FirebaseAnalyticsDataSource {

  FirebaseAnalyticsDataSourceImpl({required this.analyticsService});
  final FirebaseAnalyticsService analyticsService;

  @override
  Future<void> logEvent(AnalyticsEventEntity event) async {
    await analyticsService.logEvent(
      name: event.name,
      parameters: event.parameters,
    );
  }

  @override
  Future<void> logScreenView(String screenName, String? screenClass) async {
    await analyticsService.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    await analyticsService.setUserProperty(
      name: name,
      value: value,
    );
  }

  @override
  Future<void> setUserId(String? userId) async {
    await analyticsService.setUserId(userId);
  }
}
