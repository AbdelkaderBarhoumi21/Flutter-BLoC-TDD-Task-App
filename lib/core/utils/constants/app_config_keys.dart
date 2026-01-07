/// Predefined config keys
class AppConfigKeys {
  // Feature flags
  static const String enableNotifications = 'enable_notifications';
  static const String showCompletedTasks = 'show_completed_tasks';
  static const String enableDarkMode = 'enable_dark_mode';

  // Limits
  static const String maxTasksPerUser = 'max_tasks_per_user';
  static const String maxDescriptionLength = 'max_description_length';

  // Timeouts
  static const String apiTimeoutSeconds = 'api_timeout_seconds';
  static const String cacheDurationMinutes = 'cache_duration_minutes';
  static const String taskSyncIntervalMinutes = 'task_sync_interval_minutes';

  // URLs
  static const String apiBaseUrl = 'api_base_url';
  static const String supportEmail = 'support_email';
  static const String termsUrl = 'terms_url';
  static const String privacyUrl = 'privacy_url';
}
