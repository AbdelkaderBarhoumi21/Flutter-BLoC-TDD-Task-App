import 'dart:convert';

import 'package:flutter_task_app/core/error/exceptions.dart';
import 'package:flutter_task_app/features/task/data/datasources/task_remote_data_source.dart';
import 'package:flutter_task_app/features/task/data/models/task_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixtures_reader.dart';
import 'task_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late TaskRemoteDataSourceImpl dataSource;
  late TaskModel tTaskModel;

  setUp(() {
    mockClient = MockClient();
    dataSource = TaskRemoteDataSourceImpl(client: mockClient);
    tTaskModel = TaskModel.fromJson(
      json.decode(fixture('task.json')) as Map<String, dynamic>,
    );
  });

  group('getTasks', () {
    test('should return List<TaskModel> when the response code is 200',
        () async {
      final jsonString = fixture('task_list.json');
      when(
        mockClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response(jsonString, 200));

      final result = await dataSource.getTasks();

      expect(result, equals([tTaskModel]));
      verify(
        mockClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).called(1);
    });

    test('should throw ServerException when the response code is not 200',
        () async {
      when(
        mockClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 500));

      final call = dataSource.getTasks;

      expect(call, throwsA(isA<ServerException>()));
    });

    test('should throw NetworkException on client error', () async {
      when(
        mockClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenThrow(http.ClientException('Network error'));

      final call = dataSource.getTasks;

      expect(call, throwsA(isA<NetworkException>()));
    });
  });

  group('getTaskById', () {
    test('should return TaskModel when the response code is 200', () async {
      final jsonString = fixture('task.json');
      when(
        mockClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response(jsonString, 200));

      final result = await dataSource.getTaskById('1');

      expect(result, equals(tTaskModel));
      verify(
        mockClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).called(1);
    });

    test('should throw ServerException when the response code is 404',
        () async {
      when(
        mockClient.get(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response('Not found', 404));

      final call= dataSource.getTaskById('1');

      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('addTask', () {
    test('should return TaskModel when the response code is 201', () async {
      final jsonString = fixture('task.json');
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(jsonString, 201));

      final result = await dataSource.addTask(tTaskModel);

      expect(result, equals(tTaskModel));
      verify(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).called(1);
    });
  });

  group('updateTask', () {
    test('should return TaskModel when the response code is 200', () async {
      final jsonString = fixture('task.json');
      when(
        mockClient.put(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(jsonString, 200));

      final result = await dataSource.updateTask(tTaskModel);

      expect(result, equals(tTaskModel));
      verify(
        mockClient.put(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).called(1);
    });
  });

  group('deleteTask', () {
    test('should return void when the response code is 204', () async {
      when(
        mockClient.delete(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response('', 204));

      await dataSource.deleteTask('1');

      verify(
        mockClient.delete(
          any,
          headers: anyNamed('headers'),
        ),
      ).called(1);
    });
  });
}
