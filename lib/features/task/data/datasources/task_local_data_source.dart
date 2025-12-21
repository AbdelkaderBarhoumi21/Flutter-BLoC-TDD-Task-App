import 'dart:convert';

import 'package:flutter_task_app/core/error/exceptions.dart';
import 'package:flutter_task_app/core/utils/constants/app_constants.dart';
import 'package:flutter_task_app/features/task/data/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getCachedTasks();
  Future<void> cacheTasks(List<TaskModel> tasks);
  Future<void> clearCache();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {

  TaskLocalDataSourceImpl({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  @override
  Future<List<TaskModel>> getCachedTasks() async {
    final jsonString = sharedPreferences.getString(AppConstants.tasksKey);
    if (jsonString == null) {
      throw const CacheException('No cached tasks found');
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to parse cached tasks: $e');
    }
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    try {
      final jsonList = tasks.map((task) => task.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(AppConstants.tasksKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache tasks: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(AppConstants.tasksKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
