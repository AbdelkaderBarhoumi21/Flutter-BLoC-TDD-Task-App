import 'dart:async';
import 'dart:convert';

import 'package:flutter_task_app/core/error/exceptions.dart';
import 'package:flutter_task_app/core/utils/constants/app_constants.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/performance/add_trace_metric_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/performance/start_trace_usecase.dart';
import 'package:flutter_task_app/features/firebase/domain/usecases/performance/stop_trace_usecase.dart';
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
  const TaskRemoteDataSourceImpl({
    required this.client,
    required this.startTraceUseCase,
    required this.stopTraceUseCase,
    required this.addTraceMetricUseCase,
  });
  final http.Client client;
  final StartTraceUseCase startTraceUseCase;
  final StopTraceUseCase stopTraceUseCase;
  final AddTraceMetricUseCase addTraceMetricUseCase;

  Uri _uri(String path) => Uri.parse('${AppConstants.baseUrl}$path');

  Map<String, String> get _headers => const {
    'Content-Type': 'application/json',
  };

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      // Start performance trace
      final traceResult = await startTraceUseCase(
        const StartTraceParams(name: 'fetch_tasks_api'),
      );
      final trace = traceResult.getOrElse(
        () => throw Exception('Failed to start trace'),
      ); // Get value if Right or throw exception if left and next line doesn't execute

      try {
        final startTime = DateTime.now();
        final endTime = DateTime.now();
        final duration = endTime.difference(startTime).inMilliseconds;

        final response = await client
            .get(_uri('/tasks'), headers: _headers)
            .timeout(AppConstants.connectTimeout);
        // Add metric
        await addTraceMetricUseCase(
          AddTraceMetricParams(
            trace: trace,
            metricName: 'response_time_ms',
            value: duration,
          ),
        );

        await addTraceMetricUseCase(
          AddTraceMetricParams(
            trace: trace,
            metricName: 'response_size_bytes',
            value: response.body.length,
          ),
        );
        // Stop trace
        await stopTraceUseCase(StopTraceParams(trace: trace));

        if (response.statusCode == 200) {
          final List<dynamic> jsonList =
              json.decode(response.body) as List<dynamic>;
          return jsonList
              .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        throw ServerException('Failed to load tasks: ${response.statusCode}');
      } catch (e) {
        // Stop trace on error
        await stopTraceUseCase(StopTraceParams(trace: trace));
        rethrow;
      }
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
