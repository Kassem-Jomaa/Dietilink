import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  final DioExceptionType? dioType;

  ApiException(
    this.message, {
    this.statusCode,
    this.errors,
    this.dioType,
  });

  @override
  String toString() => message;

  // Factory constructor for creating from DioException
  factory ApiException.fromDioException(DioException dioException) {
    String message = 'Network error occurred';
    int? statusCode;
    Map<String, dynamic>? errors;

    if (dioException.response != null) {
      statusCode = dioException.response!.statusCode;
      final responseData = dioException.response!.data;

      if (responseData is Map<String, dynamic>) {
        message = responseData['message'] ?? 'An error occurred';
        errors = responseData['errors'];
      }
    } else {
      // Handle different DioException types
      switch (dioException.type) {
        case DioExceptionType.connectionTimeout:
          message =
              'Connection timeout. Please check your internet connection.';
          break;
        case DioExceptionType.sendTimeout:
          message = 'Request timeout. Please try again.';
          break;
        case DioExceptionType.receiveTimeout:
          message = 'Response timeout. Please try again.';
          break;
        case DioExceptionType.badCertificate:
          message = 'Certificate error. Please check your connection.';
          break;
        case DioExceptionType.connectionError:
          message = 'No internet connection. Please check your network.';
          break;
        case DioExceptionType.cancel:
          message = 'Request was cancelled.';
          break;
        default:
          message = 'Network error: ${dioException.message}';
      }
    }

    return ApiException(
      message,
      statusCode: statusCode,
      errors: errors,
      dioType: dioException.type,
    );
  }

  // Helper methods for checking error types
  bool get isNetworkError => dioType != null;
  bool get isTimeout =>
      dioType == DioExceptionType.connectionTimeout ||
      dioType == DioExceptionType.receiveTimeout ||
      dioType == DioExceptionType.sendTimeout;
  bool get isConnectionError => dioType == DioExceptionType.connectionError;
  bool get isValidationError => statusCode == 422;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
}
