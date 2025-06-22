import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() => message;
}

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

  Map<String, dynamic> _handleResponse(Response response) {
    final data = response.data as Map<String, dynamic>;

    if (data['success'] == false) {
      throw ApiException(
        data['message'] ?? 'An error occurred',
        statusCode: response.statusCode,
        errors: data['errors'],
      );
    }

    return data;
  }

  void _handleDioError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data as Map<String, dynamic>;

      switch (e.response?.statusCode) {
        case 401:
          throw ApiException(
            data['message'] ?? 'Authentication required',
            statusCode: 401,
          );
        case 403:
          throw ApiException(
            data['message'] ?? 'Insufficient permissions',
            statusCode: 403,
          );
        case 404:
          throw ApiException(
            data['message'] ?? 'Resource not found',
            statusCode: 404,
          );
        case 422:
          throw ApiException(
            data['message'] ?? 'Validation failed',
            statusCode: 422,
            errors: data['errors'],
          );
        default:
          throw ApiException(
            data['message'] ?? 'An error occurred',
            statusCode: e.response?.statusCode,
            errors: data['errors'],
          );
      }
    } else {
      // Network or other errors
      String message = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Connection timeout';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        message = 'Receive timeout';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'No internet connection';
      }

      throw ApiException(message);
    }
  }

  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return _handleResponse(response);
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

      return _handleResponse(response);
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

      return _handleResponse(response);
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
