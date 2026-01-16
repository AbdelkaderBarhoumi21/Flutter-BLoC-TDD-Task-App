import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_task_app/features/firebase/domain/repositories/firebase_repository.dart';
import 'package:http/http.dart' as http;

// What Firebase Performance sees:
// URL: https://api.example.com/auth/login
// Method: POST
// Request size: 52 bytes
// Response code: 200
// Response size: 87 bytes
// Duration: 342ms (calculated automatically)
// HttpMetric is a class from Firebase Performance Monitoring that tracks the performance of HTTP/HTTPS network requests.
// It's an object that collects metrics about a single HTTP request.
class PerformanceHttpMetricMonitoring {
  const PerformanceHttpMetricMonitoring({
    required this.client,
    required this.firebaseRepository,
  });
  final http.Client client;
  final FirebaseRepository firebaseRepository;

  Future<http.Response> get(Uri url) async {
    // Create http metric
    final metricResult = firebaseRepository.createHttpMetric(
      url.toString(),
      HttpMethod.Get,
    );
    if (metricResult.isLeft()) {
      // Metric creation failed, just make the request
      return await client.get(url);
    }

    final metric = metricResult.getOrElse(() => throw Exception());
    try {
      await metric.start();
      final response = await client.get(url);
      // Set reponse attributes
      metric.responsePayloadSize = response.contentLength;
      metric.httpResponseCode = response.statusCode;

      await metric.stop();
      return response;
    } catch (e) {
      await metric.stop();
      rethrow;
    }
  }

  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final metricResult = firebaseRepository.createHttpMetric(
      url.toString(),
      HttpMethod.Post,
    );

    if (metricResult.isLeft()) {
      return await client.post(url, headers: headers, body: body);
    }

    final metric = metricResult.getOrElse(() => throw Exception());

    try {
      await metric.start();

      // Set request size
      if (body != null) {
        if (body is String) {
          metric.requestPayloadSize = body.length;
        } else if (body is List<int>) {
          metric.requestPayloadSize = body.length;
        }
      }

      final response = await client.post(url, headers: headers, body: body);

      metric.responsePayloadSize = response.contentLength;
      metric.httpResponseCode = response.statusCode;

      await metric.stop();
      return response;
    } catch (e) {
      await metric.stop();
      rethrow;
    }
  }
}
