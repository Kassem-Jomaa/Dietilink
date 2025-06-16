import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  Future<Response<dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      print('GET Request Error: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      print('POST Request Error: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      print('PUT Request Error: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> postMultipart(String path,
      {required FormData data}) async {
    try {
      return await _dio.post(
        path,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } catch (e) {
      print('Multipart POST Request Error: $e');
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
