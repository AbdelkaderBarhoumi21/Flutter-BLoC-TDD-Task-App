import 'dart:convert';

import 'package:flutter_task_app/core/error/exceptions.dart';
import 'package:flutter_task_app/core/utils/constants/app_constants.dart';
import 'package:flutter_task_app/features/task/data/datasources/task_local_data_source.dart';
import 'package:flutter_task_app/features/task/data/models/task_model.dart';
import 'package:flutter_task_app/features/task/domain/entities/task_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixtures_reader.dart';
import 'task_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late TaskLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;
  final tTaskModel = TaskModel(
    id: '1',
    title: 'Test Task',
    description: 'Test Description',
    priority: TaskPriority.high,
    status: TaskStatus.pending,
    createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
  );

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = TaskLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getCachedTasks', () {
    test('should return List<TaskModel> when there is cached data', () async {
      final jsonString = fixture('task_list.json');
      // Arrange
      when(
        mockSharedPreferences.getString(AppConstants.tasksKey),
      ).thenReturn(jsonString);

      // Act
      final result = await dataSource.getCachedTasks();

      // Assert
      expect(result, equals([tTaskModel]));

      // Verify
      verify(
        mockSharedPreferences.getString(AppConstants.tasksKey),
      ).called(1);
    });

    test('should throw CacheException when there is no cached data', () async {
      // Arrange
      when(
        mockSharedPreferences.getString(AppConstants.tasksKey),
      ).thenReturn(null);

      // Act
      final call = dataSource.getCachedTasks;

      // Assert
      expect(call, throwsA(isA<CacheException>()));
    });
  });
  group('cacheTasks', () {
    test('should call SharedPreferences to cache the data', () async {
      when(
        mockSharedPreferences.setString(any, any),
      ).thenAnswer((_) async => true);

      await dataSource.cacheTasks([tTaskModel]);

      final expectedJsonString = json.encode([tTaskModel.toJson()]);
      verify(
        mockSharedPreferences.setString(
          AppConstants.tasksKey,
          expectedJsonString,
        ),
      ).called(1);
    });
  });

  group('clearCache', () {
    test('should remove cache key', () async {
      when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

      await dataSource.clearCache();

      verify(
        mockSharedPreferences.remove(AppConstants.tasksKey),
      ).called(1);
    });
  });
}
