import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../../../core/exceptions/api_exception.dart';
import '../models/progress_model.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class ProgressController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Observable variables
  final isLoading = false.obs;
  final isLoadingHistory = false.obs;
  final isLoadingStatistics = false.obs;
  final isCreating = false.obs;
  final isUpdating = false.obs;
  final isDeleting = false.obs;

  final progressHistory = Rxn<ProgressHistory>();
  final latestProgress = Rxn<ProgressEntry>();
  final progressStatistics = Rxn<ProgressStatistics>();
  final selectedImages = <File>[].obs;

  // Pagination
  final currentPage = 1.obs;
  final perPage = 20.obs;

  // File validation constants
  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB in bytes
  static const int maxImageCount = 5;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  // Load initial data
  Future<void> loadInitialData() async {
    await Future.wait([
      getProgressHistory(),
      getLatestProgress(),
      getProgressStatistics(),
    ]);
  }

  // Enhanced error handling
  void _handleError(dynamic error, [String? context]) {
    if (error is ApiException) {
      // Handle API exceptions with enhanced logic
      if (error.isUnauthorized) {
        _handleAuthenticationError();
      } else if (error.isForbidden) {
        _showErrorSnackbar('Permission Error', error.message);
      } else if (error.isNotFound) {
        _showErrorSnackbar('Not Found', error.message);
      } else if (error.isValidationError) {
        _showValidationErrors(error.errors);
      } else if (error.isNetworkError) {
        _handleNetworkError(error);
      } else {
        _showErrorSnackbar('Error', error.message);
      }
    } else if (error is DioException) {
      // Handle DioException that wasn't caught by ApiService
      _handleError(ApiException.fromDioException(error), context);
    } else {
      // Handle other types of errors
      final contextMsg = context != null ? ' while $context' : '';
      _showErrorSnackbar(
        'Unexpected Error',
        'An error occurred$contextMsg. Please try again.',
      );

      // Log the error for debugging
      print('Unexpected error in ProgressController: $error');
    }
  }

  void _handleAuthenticationError() {
    Get.snackbar(
      'Session Expired',
      'Please log in again',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 4),
    );
    // Redirect to login after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/login');
    });
  }

  void _handleNetworkError(ApiException error) {
    String title = 'Connection Error';
    String message = error.message;

    if (error.isTimeout) {
      title = 'Request Timeout';
      message =
          'The request timed out. Please check your connection and try again.';
    } else if (error.isConnectionError) {
      title = 'No Internet';
      message = 'Please check your internet connection and try again.';
    }

    _showErrorSnackbar(title, message);
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 4),
    );
  }

  // Show validation errors
  void _showValidationErrors(Map<String, dynamic>? errors) {
    if (errors == null) return;

    final errorMessages = <String>[];
    errors.forEach((field, messages) {
      if (messages is List) {
        for (final message in messages) {
          errorMessages.add('$field: $message');
        }
      }
    });

    Get.dialog(
      AlertDialog(
        title: const Text('Validation Error'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errorMessages
              .map(
                (msg) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('• $msg'),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // File validation methods
  bool _isValidImageFile(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    return allowedExtensions.contains(extension);
  }

  Future<bool> _isValidFileSize(File file) async {
    try {
      final fileSize = await file.length();
      return fileSize <= maxFileSize;
    } catch (e) {
      return false;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Get progress history with pagination
  Future<void> getProgressHistory({int? page, int? limit}) async {
    try {
      isLoadingHistory.value = true;

      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['per_page'] = limit.toString();

      final response =
          await _apiService.get('/progress', queryParameters: queryParams);

      progressHistory.value = ProgressHistory.fromJson(response['data']);
      currentPage.value = progressHistory.value!.pagination.currentPage;
    } catch (e) {
      _handleError(e, 'loading progress history');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // Get latest progress entry
  Future<void> getLatestProgress() async {
    Map<String, dynamic>? response;
    try {
      isLoading.value = true;

      response = await _apiService.get('/progress/latest');

      // Debug: Print the raw response to identify the issue
      print('🔍 Latest Progress Response: ${response['data']}');

      latestProgress.value =
          ProgressEntry.fromJson(response['data']['progress_entry']);
    } catch (e) {
      print('❌ Error parsing latest progress: $e');
      print('📊 Response data: ${response?['data']}');
      _handleError(e, 'loading latest progress');
    } finally {
      isLoading.value = false;
    }
  }

  // Get progress statistics
  Future<void> getProgressStatistics() async {
    try {
      isLoadingStatistics.value = true;

      final response = await _apiService.get('/progress/statistics');

      progressStatistics.value =
          ProgressStatistics.fromJson(response['data']['statistics']);
    } catch (e) {
      _handleError(e, 'loading progress statistics');
    } finally {
      isLoadingStatistics.value = false;
    }
  }

  // Get specific progress entry (accepts both string and int IDs)
  Future<ProgressEntry?> getProgressEntry(dynamic id) async {
    try {
      isLoading.value = true;

      final response = await _apiService.get('/progress/$id');

      return ProgressEntry.fromJson(response['data']['progress_entry']);
    } catch (e) {
      _handleError(e, 'loading progress entry');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Create progress entry with enhanced file validation
  Future<bool> createProgressEntry({
    required double weight,
    required String measurementDate,
    String? notes,
    double? chest,
    double? leftArm,
    double? rightArm,
    double? waist,
    double? hips,
    double? leftThigh,
    double? rightThigh,
    double? fatMass,
    double? muscleMass,
    List<File>? images,
  }) async {
    try {
      isCreating.value = true;

      // Validate images before upload
      if (images != null && images.isNotEmpty) {
        final validationResult = await _validateImages(images);
        if (!validationResult) {
          return false;
        }
      }

      final formData = <String, dynamic>{
        'weight': weight.toString(),
        'measurement_date': measurementDate,
      };

      if (notes != null) formData['notes'] = notes;
      if (chest != null) formData['chest'] = chest.toString();
      if (leftArm != null) formData['left_arm'] = leftArm.toString();
      if (rightArm != null) formData['right_arm'] = rightArm.toString();
      if (waist != null) formData['waist'] = waist.toString();
      if (hips != null) formData['hips'] = hips.toString();
      if (leftThigh != null) formData['left_thigh'] = leftThigh.toString();
      if (rightThigh != null) formData['right_thigh'] = rightThigh.toString();
      if (fatMass != null) formData['fat_mass'] = fatMass.toString();
      if (muscleMass != null) formData['muscle_mass'] = muscleMass.toString();

      // Prepare files for upload using the correct field name pattern
      List<MapEntry<String, File>>? fileList;
      if (images != null && images.isNotEmpty) {
        fileList = images
            .asMap()
            .entries
            .map((entry) => MapEntry(
                  'progress_images[]', // Using array notation as shown in API docs
                  entry.value,
                ))
            .toList();
      }

      final response = await _apiService.postMultipart(
        '/progress',
        formData,
        files: fileList,
      );

      Get.snackbar(
        'Success',
        'Progress entry created successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      await loadInitialData(); // Refresh data

      // Notify dashboard to refresh
      try {
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.refreshDashboard();
      } catch (e) {
        print('❌ Failed to refresh dashboard: $e');
      }

      selectedImages.clear();
      return true;
    } catch (e) {
      _handleError(e, 'creating progress entry');
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  // Validate images according to API guidelines
  Future<bool> _validateImages(List<File> images) async {
    // Check count
    if (images.length > maxImageCount) {
      Get.snackbar(
        'Too Many Images',
        'Maximum $maxImageCount images allowed per entry',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    // Check each image
    for (int i = 0; i < images.length; i++) {
      final image = images[i];

      // Check file format
      if (!_isValidImageFile(image)) {
        Get.snackbar(
          'Invalid File Format',
          'Image ${i + 1}: Only JPEG, PNG, JPG, and WEBP formats are allowed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return false;
      }

      // Check file size
      if (!await _isValidFileSize(image)) {
        final fileSize = await image.length();
        Get.snackbar(
          'File Too Large',
          'Image ${i + 1}: Size ${_formatFileSize(fileSize)} exceeds 5MB limit',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return false;
      }
    }

    return true;
  }

  // Update progress entry (accepts both string and int IDs)
  Future<bool> updateProgressEntry({
    required dynamic id, // Changed to dynamic for flexibility
    required double weight,
    required String measurementDate,
    String? notes,
    double? chest,
    double? leftArm,
    double? rightArm,
    double? waist,
    double? hips,
    double? leftThigh,
    double? rightThigh,
    double? fatMass,
    double? muscleMass,
    List<File>? newImages,
    List<dynamic>? deleteImageIds, // Changed to dynamic for flexibility
  }) async {
    try {
      isUpdating.value = true;

      // Validate new images if provided
      if (newImages != null && newImages.isNotEmpty) {
        final validationResult = await _validateImages(newImages);
        if (!validationResult) {
          return false;
        }
      }

      final formData = <String, dynamic>{
        'weight': weight.toString(),
        'measurement_date': measurementDate,
      };

      if (notes != null) formData['notes'] = notes;
      if (chest != null) formData['chest'] = chest.toString();
      if (leftArm != null) formData['left_arm'] = leftArm.toString();
      if (rightArm != null) formData['right_arm'] = rightArm.toString();
      if (waist != null) formData['waist'] = waist.toString();
      if (hips != null) formData['hips'] = hips.toString();
      if (leftThigh != null) formData['left_thigh'] = leftThigh.toString();
      if (rightThigh != null) formData['right_thigh'] = rightThigh.toString();
      if (fatMass != null) formData['fat_mass'] = fatMass.toString();
      if (muscleMass != null) formData['muscle_mass'] = muscleMass.toString();

      // Add image IDs to delete (handle both string and int IDs)
      if (deleteImageIds != null && deleteImageIds.isNotEmpty) {
        for (int i = 0; i < deleteImageIds.length; i++) {
          formData['delete_images[$i]'] = deleteImageIds[i].toString();
        }
      }

      // Prepare new files for upload
      List<MapEntry<String, File>>? fileList;
      if (newImages != null && newImages.isNotEmpty) {
        fileList = newImages
            .asMap()
            .entries
            .map((entry) => MapEntry(
                  'progress_images[]',
                  entry.value,
                ))
            .toList();
      }

      final response = await _apiService.putMultipart(
        '/progress/$id',
        formData,
        files: fileList,
      );

      Get.snackbar(
        'Success',
        'Progress entry updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      await loadInitialData(); // Refresh data

      // Notify dashboard to refresh
      try {
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.refreshDashboard();
      } catch (e) {
        print('❌ Failed to refresh dashboard: $e');
      }

      return true;
    } catch (e) {
      _handleError(e, 'updating progress entry');
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // Delete progress entry
  Future<bool> deleteProgressEntry(dynamic id) async {
    try {
      isDeleting.value = true;

      final response = await _apiService.delete('/progress/$id');

      Get.snackbar(
        'Success',
        'Progress entry deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      await loadInitialData(); // Refresh data

      // Notify dashboard to refresh
      try {
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.refreshDashboard();
      } catch (e) {
        print('❌ Failed to refresh dashboard: $e');
      }

      return true;
    } catch (e) {
      _handleError(e, 'deleting progress entry');
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  // Delete progress image
  Future<bool> deleteProgressImage(dynamic progressId, dynamic imageId) async {
    try {
      final response =
          await _apiService.delete('/progress/$progressId/images/$imageId');

      Get.snackbar(
        'Success',
        'Progress image deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      await loadInitialData(); // Refresh data
      return true;
    } catch (e) {
      _handleError(e, 'deleting progress image');
      return false;
    }
  }

  // Enhanced image picker methods with validation
  Future<void> pickImages() async {
    try {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        final newImages = pickedFiles.map((xFile) => File(xFile.path)).toList();

        // Check total count
        final totalImages = selectedImages.length + newImages.length;
        if (totalImages > maxImageCount) {
          Get.snackbar(
            'Too Many Images',
            'Maximum $maxImageCount images allowed. You can add ${maxImageCount - selectedImages.length} more.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
          );
          final availableSlots = maxImageCount - selectedImages.length;
          if (availableSlots > 0) {
            final validImages = await _filterValidImages(
                newImages.take(availableSlots).toList());
            selectedImages.addAll(validImages);
          }
        } else {
          final validImages = await _filterValidImages(newImages);
          selectedImages.addAll(validImages);
        }
      }
    } catch (e) {
      _handleError(e, 'picking images');
    }
  }

  Future<void> pickSingleImage() async {
    try {
      if (selectedImages.length >= maxImageCount) {
        Get.snackbar(
          'Maximum Images Reached',
          'Maximum $maxImageCount images allowed per entry',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final image = File(pickedFile.path);
        final validImages = await _filterValidImages([image]);
        selectedImages.addAll(validImages);
      }
    } catch (e) {
      _handleError(e, 'picking image');
    }
  }

  Future<void> takePhoto() async {
    try {
      if (selectedImages.length >= maxImageCount) {
        Get.snackbar(
          'Maximum Images Reached',
          'Maximum $maxImageCount images allowed per entry',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        final image = File(pickedFile.path);
        final validImages = await _filterValidImages([image]);
        selectedImages.addAll(validImages);
      }
    } catch (e) {
      _handleError(e, 'taking photo');
    }
  }

  // Filter out invalid images and show appropriate messages
  Future<List<File>> _filterValidImages(List<File> images) async {
    final validImages = <File>[];

    for (final image in images) {
      // Check format
      if (!_isValidImageFile(image)) {
        Get.snackbar(
          'Invalid Format',
          'Skipped ${image.path.split('/').last}: Only JPEG, PNG, JPG, and WEBP formats are allowed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        continue;
      }

      // Check size
      if (!await _isValidFileSize(image)) {
        final fileSize = await image.length();
        Get.snackbar(
          'File Too Large',
          'Skipped ${image.path.split('/').last}: Size ${_formatFileSize(fileSize)} exceeds 5MB limit',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        continue;
      }

      validImages.add(image);
    }

    return validImages;
  }

  // Remove selected image
  void removeSelectedImage(int index) {
    if (index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  // Clear selected images
  void clearSelectedImages() {
    selectedImages.clear();
  }

  // Load more entries (pagination)
  Future<void> loadMoreEntries() async {
    if (progressHistory.value?.pagination.hasNextPage == true &&
        !isLoadingHistory.value) {
      await getProgressHistory(page: currentPage.value + 1);
    }
  }

  // Refresh all data
  Future<void> refreshData() async {
    await loadInitialData();
  }
}
