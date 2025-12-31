import 'dart:async';
import 'dart:convert';

import 'package:flutter_task_app/core/error/exceptions.dart';
import 'package:flutter_task_app/core/utils/constants/app_constants.dart';
import 'package:flutter_task_app/features/task/data/models/task_model.dart';
import 'package:http/http.dart' as http;

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTaskById(String id);
  Future<TaskModel> addTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  const TaskRemoteDataSourceImpl({required this.client});
  final http.Client client;

  Uri _uri(String path) => Uri.parse('${AppConstants.baseUrl}$path');

  Map<String, String> get _headers => const {
    'Content-Type': 'application/json',
  };

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await client
          .get(_uri('/tasks'), headers: _headers)
          .timeout(AppConstants.connectTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            json.decode(response.body) as List<dynamic>;
        return jsonList
            .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ServerException('Failed to load tasks: ${response.statusCode}');
    } on http.ClientException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException('Request timed out');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    try {
      final response = await client
          .get(_uri('/tasks/$id'), headers: _headers)
          .timeout(AppConstants.connectTimeout);

      if (response.statusCode == 200) {
        return TaskModel.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      }
      if (response.statusCode == 404) {
        throw const ServerException('Task not found');
      }
      throw ServerException('Failed to load task: ${response.statusCode}');
    } on http.ClientException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException('Request timed out');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    try {
      final response = await client
          .post(
            _uri('/tasks'),
            headers: _headers,
            body: json.encode(task.toJson()),
          )
          .timeout(AppConstants.connectTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskModel.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      }
      throw ServerException('Failed to add task: ${response.statusCode}');
    } on http.ClientException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException('Request timed out');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await client
          .put(
            _uri('/tasks/${task.id}'),
            headers: _headers,
            body: json.encode(task.toJson()),
          )
          .timeout(AppConstants.connectTimeout);

      if (response.statusCode == 200) {
        return TaskModel.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      }
      if (response.statusCode == 404) {
        throw const ServerException('Task not found');
      }
      throw ServerException('Failed to update task: ${response.statusCode}');
    } on http.ClientException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException('Request timed out');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final response = await client
          .delete(_uri('/tasks/$id'), headers: _headers)
          .timeout(AppConstants.connectTimeout);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }
      if (response.statusCode == 404) {
        throw const ServerException('Task not found');
      }
      throw ServerException('Failed to delete task: ${response.statusCode}');
    } on http.ClientException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException('Request timed out');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
