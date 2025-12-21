class AppConstants {
  // API
  static const String baseUrl = 'https://api.example.com';
  static const Duration connectTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String tasksKey = 'CACHED_TASKS';

  // Validation
  static const int minTitleLength = 3;
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
}
