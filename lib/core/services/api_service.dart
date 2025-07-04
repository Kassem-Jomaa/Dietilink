import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../exceptions/api_exception.dart';
import '../../modules/progress/utils/api_response_logger.dart';

class ApiService extends getx.GetxService {
  late Dio _dio;
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'https://dietilink.syscomdemos.com/api/v1';

  Future<ApiService> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('\n🌐 API Request:');
        print('URL: ${options.uri}');
        print('Method: ${options.method}');
        print('Headers: ${options.headers}');
        print('Data: ${options.data}');

        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('\n✅ API Response:');
        print('Status Code: ${response.statusCode}');
        print('Headers: ${response.headers}');
        print('Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('\n❌ API Error:');
        print('Error Type: ${e.type}');
        print('Error Message: ${e.message}');
        print('Error Response: ${e.response?.data}');
        print('Error Status Code: ${e.response?.statusCode}');
        return handler.next(e);
      },
    ));

    return this;
  }

  Map<String, dynamic> _handleResponse(Response response, [String? endpoint]) {
    // Ensure response data is a Map
    if (response.data is! Map<String, dynamic>) {
      throw ApiException(
        'Invalid response format',
        statusCode: response.statusCode,
      );
    }

    final data = response.data as Map<String, dynamic>;

    // Log response for type analysis (only in debug mode)
    if (endpoint != null) {
      data.logApiResponse(endpoint);
      data.testCriticalFields();
    }

    // Check if the API response indicates success or failure
    // API always returns HTTP 200, so we need to check the 'success' field
    if (data.containsKey('success') && data['success'] == false) {
      throw ApiException(
        data['message'] ?? 'An error occurred',
        statusCode: response.statusCode,
        errors: data['errors'] is Map<String, dynamic>
            ? data['errors'] as Map<String, dynamic>
            : null,
      );
    }

    return data;
  }

  void _handleDioError(DioException e) {
    // Use the enhanced ApiException.fromDioException factory
    throw ApiException.fromDioException(e);
  }

  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response, 'GET $path');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return _handleResponse(response, 'POST $path');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return _handleResponse(response, 'PUT $path');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return _handleResponse(response, 'DELETE $path');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postMultipart(
    String path,
    Map<String, dynamic> fields, {
    List<MapEntry<String, File>>? files,
  }) async {
    try {
      final formData = FormData();

      // Add fields
      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      // Add files with proper field names for progress images
      if (files != null) {
        for (final file in files) {
          formData.files.add(MapEntry(
            file.key,
            await MultipartFile.fromFile(
              file.value.path,
              filename: file.value.path.split('/').last,
            ),
          ));
        }
      }

      final response = await _dio.post(
        path,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return _handleResponse(response, 'POST $path');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> putMultipart(
    String path,
    Map<String, dynamic> fields, {
    List<MapEntry<String, File>>? files,
  }) async {
    try {
      final formData = FormData();

      // Add fields
      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      // Add files with proper field names for progress images
      if (files != null) {
        for (final file in files) {
          formData.files.add(MapEntry(
            file.key,
            await MultipartFile.fromFile(
              file.value.path,
              filename: file.value.path.split('/').last,
            ),
          ));
        }
      }

      final response = await _dio.put(
        path,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return _handleResponse(response, 'PUT $path');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }
}

/// Safe parsing utilities for handling mixed API response types
class SafeParsing {
  /// Parse string with fallback to empty string
  static String parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  /// Parse nullable string
  static String? parseStringNullable(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    final str = value.toString();
    return str.isEmpty ? null : str;
  }

  /// Parse int with fallback to 0
  static int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed ?? 0;
    }
    return 0;
  }

  /// Parse double with fallback to 0.0
  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed ?? 0.0;
    }
    return 0.0;
  }

  /// Parse boolean with fallback to false
  static bool parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value != 0;
    return false;
  }
}
