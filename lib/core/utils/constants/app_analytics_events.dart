/// Predefined analytics events
class AppAnalyticsEvents {
  // Screen views
  static const String screenView = 'screen_view';
  
  // Task events
  static const String taskAdded = 'task_added';
  static const String taskUpdated = 'task_updated';
  static const String taskDeleted = 'task_deleted';
  static const String taskCompleted = 'task_completed';
  static const String taskMarkedPending = 'task_marked_pending';
  
  // User events
  static const String userLogin = 'user_login';
  static const String userLogout = 'user_logout';
  static const String userSignup = 'user_signup';
  
  // App events
  static const String appOpened = 'app_opened';
  static const String appClosed = 'app_closed';
  static const String settingsChanged = 'settings_changed';
  
  // Error events
  static const String errorOccurred = 'error_occurred';
  static const String crashDetected = 'crash_detected';
}

/// Predefined analytics parameters
class AppAnalyticsParameters {
  static const String screenName = 'screen_name';
  static const String screenClass = 'screen_class';
  static const String taskId = 'task_id';
  static const String taskPriority = 'task_priority';
  static const String taskStatus = 'task_status';
  static const String errorType = 'error_type';
  static const String errorMessage = 'error_message';
  static const String userId = 'user_id';
  static const String timestamp = 'timestamp';
}
