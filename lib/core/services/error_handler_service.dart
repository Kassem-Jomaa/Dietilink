import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../exceptions/api_exception.dart';
import '../theme/app_theme.dart';

/// Error Handler Service
///
/// Provides centralized error handling for the app
class ErrorHandlerService extends GetxService {
  /// Handle API errors with user-friendly messages
  static void handleApiError(dynamic error, {String? context}) {
    String message = 'An unexpected error occurred';
    String title = 'Error';
    Color backgroundColor = AppTheme.error;
    IconData icon = Icons.error_outline;

    if (error is ApiException) {
      switch (error.statusCode) {
        case 400:
          title = 'Invalid Request';
          message = error.message;
          backgroundColor = AppTheme.warning;
          icon = Icons.warning_amber;
          break;
        case 401:
          title = 'Authentication Required';
          message = 'Please log in again to continue';
          backgroundColor = AppTheme.warning;
          icon = Icons.lock_outline;
          break;
        case 403:
          title = 'Access Denied';
          message = 'You don\'t have permission to perform this action';
          backgroundColor = AppTheme.error;
          icon = Icons.block;
          break;
        case 404:
          title = 'Not Found';
          message = 'The requested resource was not found';
          backgroundColor = AppTheme.warning;
          icon = Icons.search_off;
          break;
        case 409:
          title = 'Conflict';
          message =
              'This slot is no longer available. Please choose another time.';
          backgroundColor = AppTheme.warning;
          icon = Icons.schedule;
          break;
        case 422:
          title = 'Validation Error';
          message = error.message;
          backgroundColor = AppTheme.warning;
          icon = Icons.edit_off;
          break;
        case 500:
        case 502:
        case 503:
          title = 'Server Error';
          message =
              'Our servers are experiencing issues. Please try again later.';
          backgroundColor = AppTheme.error;
          icon = Icons.cloud_off;
          break;
        default:
          title = 'Network Error';
          message = error.message;
          backgroundColor = AppTheme.error;
          icon = Icons.wifi_off;
      }
    } else if (error.toString().contains('timeout')) {
      title = 'Request Timeout';
      message =
          'The request took too long. Please check your connection and try again.';
      backgroundColor = AppTheme.warning;
      icon = Icons.timer_off;
    } else if (error.toString().contains('connection')) {
      title = 'No Internet Connection';
      message = 'Please check your internet connection and try again.';
      backgroundColor = AppTheme.error;
      icon = Icons.wifi_off;
    }

    _showErrorSnackbar(title, message, backgroundColor, icon);
  }

  /// Handle specific appointment booking errors
  static void handleAppointmentError(dynamic error) {
    if (error.toString().contains('slot already booked') ||
        error.toString().contains('already taken')) {
      _showErrorSnackbar(
        'Slot Unavailable',
        'This time slot has already been booked. Please choose another time.',
        AppTheme.warning,
        Icons.schedule,
      );
    } else if (error.toString().contains('invalid appointment type')) {
      _showErrorSnackbar(
        'Invalid Appointment Type',
        'The selected appointment type is not available.',
        AppTheme.warning,
        Icons.category_outlined,
      );
    } else if (error.toString().contains('dietitian unavailable')) {
      _showErrorSnackbar(
        'Dietitian Unavailable',
        'The selected dietitian is not available at this time.',
        AppTheme.warning,
        Icons.person_off,
      );
    } else {
      handleApiError(error, context: 'appointment booking');
    }
  }

  /// Handle authentication errors
  static void handleAuthError(dynamic error) {
    if (error.toString().contains('invalid credentials') ||
        error.toString().contains('wrong password')) {
      _showErrorSnackbar(
        'Invalid Credentials',
        'Please check your username and password and try again.',
        AppTheme.warning,
        Icons.lock_outline,
      );
    } else if (error.toString().contains('token expired')) {
      _showErrorSnackbar(
        'Session Expired',
        'Your session has expired. Please log in again.',
        AppTheme.warning,
        Icons.timer_off,
      );
    } else {
      handleApiError(error, context: 'authentication');
    }
  }

  /// Handle validation errors
  static void handleValidationError(Map<String, dynamic> errors) {
    String message = 'Please check your input and try again.';

    if (errors.containsKey('appointment_date')) {
      message = 'Please select a valid appointment date.';
    } else if (errors.containsKey('start_time')) {
      message = 'Please select a valid time slot.';
    } else if (errors.containsKey('appointment_type_id')) {
      message = 'Please select an appointment type.';
    } else if (errors.containsKey('notes')) {
      message = 'Notes cannot exceed 500 characters.';
    }

    _showErrorSnackbar(
      'Validation Error',
      message,
      AppTheme.warning,
      Icons.edit_off,
    );
  }

  /// Show success message
  static void showSuccess(String message, {String title = 'Success'}) {
    _showSnackbar(
      title,
      message,
      AppTheme.success,
      Icons.check_circle,
    );
  }

  /// Show info message
  static void showInfo(String message, {String title = 'Info'}) {
    _showSnackbar(
      title,
      message,
      AppTheme.skyBlue,
      Icons.info_outline,
    );
  }

  /// Show warning message
  static void showWarning(String message, {String title = 'Warning'}) {
    _showSnackbar(
      title,
      message,
      AppTheme.warning,
      Icons.warning_amber,
    );
  }

  /// Show error snackbar
  static void _showErrorSnackbar(
    String title,
    String message,
    Color backgroundColor,
    IconData icon,
  ) {
    _showSnackbar(title, message, backgroundColor, icon);
  }

  /// Show snackbar with custom styling
  static void _showSnackbar(
    String title,
    String message,
    Color backgroundColor,
    IconData icon,
  ) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor.withValues(alpha: 0.95),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      icon: Icon(icon, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      snackStyle: SnackStyle.FLOATING,
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color confirmColor = AppTheme.error,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show loading dialog
  static void showLoadingDialog({String message = 'Loading...'}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Show bottom sheet with error details
  static void showErrorDetails(String error, {String? title}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: AppTheme.error),
                const SizedBox(width: 8),
                Text(
                  title ?? 'Error Details',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
