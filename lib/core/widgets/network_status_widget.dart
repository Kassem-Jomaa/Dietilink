import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';

/// Network Status Widget
///
/// Shows network connection status and provides retry options
class NetworkStatusWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool isLoading;

  const NetworkStatusWidget({
    Key? key,
    this.errorMessage,
    this.onRetry,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null && !isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLoading
            ? AppTheme.primary.withValues(alpha: 0.1)
            : AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLoading
              ? AppTheme.primary.withValues(alpha: 0.3)
              : AppTheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  Icons.wifi_off,
                  color: AppTheme.error,
                  size: 20,
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isLoading
                      ? 'Checking network connection...'
                      : errorMessage ?? 'Network error',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: isLoading ? AppTheme.primary : AppTheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (errorMessage != null && onRetry != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Please check your internet connection and try again.',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.error,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Network Error Dialog
///
/// Shows a dialog with network error information and retry options
class NetworkErrorDialog extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onCancel;

  const NetworkErrorDialog({
    Key? key,
    required this.errorMessage,
    this.onRetry,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.wifi_off,
            color: AppTheme.error,
            size: 24,
          ),
          const SizedBox(width: 8),
          const Text('Network Error'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            errorMessage,
            style: Get.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Please check your internet connection and try again.',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
      actions: [
        if (onCancel != null)
          TextButton(
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
        if (onRetry != null)
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
      ],
    );
  }
}
