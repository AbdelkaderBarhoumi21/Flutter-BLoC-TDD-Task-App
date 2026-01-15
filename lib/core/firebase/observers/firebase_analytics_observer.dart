import 'package:flutter/material.dart';
import 'package:flutter_task_app/core/di/firebase_injection.dart'
    as firebase_di;
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/log_analytics_event_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/analytics/log_screen_view_usecase.dart';

class FirebaseAnalyticsObserver extends NavigatorObserver {
  FirebaseAnalyticsObserver({required this.analytics});
  final LogAnalyticsEventUseCase analytics;

  void _sendScreenView(PageRoute<dynamic> route) {
    final screenName = route.settings.name ?? 'Unknown';
    if (screenName != 'Unknown') {
      // Screen Class to help Distinguishing navigation types if (MaterialPageRoute,CupertinoPageRoute,FadePageRoute,PageRoute)
      firebase_di.sl<LogScreenViewUseCase>()(
        LogScreenViewParams(
          screenName: screenName,
          screenClass: route.runtimeType.toString(),
        ),
      );
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}
