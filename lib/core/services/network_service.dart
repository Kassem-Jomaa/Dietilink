import 'dart:io';
import 'package:dio/dio.dart';
import '../../config/api_config.dart';

/// Network Service
///
/// Handles network connectivity checks and provides better error handling
class NetworkService {
  final Dio _dio;

  NetworkService(this._dio);

  /// Check if device has internet connectivity
  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Check if API server is reachable
  Future<bool> isApiServerReachable() async {
    try {
      final response = await _dio.get(
        '${ApiConfig.baseUrl}/health',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Get detailed error message based on error type
  String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return 'No internet connection. Please check your network and try again.';
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet speed and try again.';
        case DioExceptionType.receiveTimeout:
          return 'Request timeout. The server is taking too long to respond.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          return ApiConfig.getErrorMessage(statusCode ?? 500);
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.unknown:
          return 'An unexpected error occurred. Please try again.';
        default:
          return 'Network error. Please check your connection and try again.';
      }
    }

    if (error is SocketException) {
      return 'No internet connection. Please check your network and try again.';
    }

    return 'An unexpected error occurred. Please try again.';
  }

  /// Check if error is retryable
  bool isRetryableError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return true;
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          // Retry on server errors (5xx) but not client errors (4xx)
          return statusCode != null && statusCode >= 500;
        default:
          return false;
      }
    }

    if (error is SocketException) {
      return true;
    }

    return false;
  }

  /// Get retry delay for exponential backoff
  Duration getRetryDelay(int attempt) {
    final delay = ApiConfig.getRetryDelay(attempt);
    return Duration(milliseconds: delay);
  }
}
