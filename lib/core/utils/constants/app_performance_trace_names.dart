/// Predefined trace names
class AppPerformanceTraceNames {
  // Data operations
  static const String fetchTasks = 'fetch_tasks';
  static const String addTask = 'add_task';
  static const String updateTask = 'update_task';
  static const String deleteTask = 'delete_task';
  
  // Screen rendering
  static const String homeScreenLoad = 'home_screen_load';
  static const String taskDetailScreenLoad = 'task_detail_screen_load';
  static const String settingsScreenLoad = 'settings_screen_load';
  
  // Authentication
  static const String userLogin = 'user_login';
  static const String userSignup = 'user_signup';
  
  // Cache operations
  static const String cacheRead = 'cache_read';
  static const String cacheWrite = 'cache_write';
}