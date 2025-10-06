import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import 'package:finance_tracker/core/config/api_config.dart';

class DioConfig {
  DioConfig._();

  // Singleton instance
  static Dio? _instance;

  // Gets the singleton Dio instance (creates if not exists)
  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio();

    dio.options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );

    // Add interceptors for logging (useful for debugging)
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, logPrint: (object) => debugPrint('Dio: $object')),
    );

    return dio;
  }

  // Resets the singleton instance (useful for testing)
  static void resetInstance() {
    _instance?.close();
    _instance = null;
  }
}
