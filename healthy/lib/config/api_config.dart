class ApiConfig {
  // Base URLs
  static const String baseUrl = 'https://dietilink.syscomdemos.com/api/v1';
  static const String chatbotBaseUrl =
      'https://dietilink.syscomdemos.com/api/v1';

  // Authentication endpoints
  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
  static const String logoutEndpoint = '/logout';
  static const String refreshEndpoint = '/refresh';
  static const String userProfileEndpoint = '/user/profile';
  static const String changePasswordEndpoint = '/user/password';
  static const String passwordResetEmailEndpoint = '/password/email';
  static const String passwordResetEndpoint = '/password/reset';

  // Chatbot endpoints
  static const String chatEndpoint = '/chat';
  static const String chatHistoryEndpoint = '/chat/history';
  static const String nutritionAdviceEndpoint = '/nutrition/advice';
  static const String nutritionMealPlanEndpoint = '/nutrition/meal-plan';
  static const String modelInfoEndpoint = '/chat/model-info';
  static const String modelUpdatesEndpoint = '/chat/model-updates';

  // Appointment endpoints
  static const String appointmentTypesEndpoint = '/appointment-types';
  static const String dietitianEndpoint = '/dietitian';
  static const String availabilitySlotsEndpoint = '/availability/slots';
  static const String availabilityDateRangeEndpoint =
      '/availability/date-range';
  static const String availabilityCheckSlotEndpoint =
      '/availability/check-slot';
  static const String appointmentsEndpoint = '/appointments';
  static const String nextAppointmentEndpoint = '/appointments/next';
  static const String appointmentStatisticsEndpoint =
      '/appointments/statistics';
  static const String cancelAppointmentEndpoint =
      '/appointments'; // POST /appointments/{id}/cancel

  // Progress tracking endpoints
  static const String progressEndpoint = '/progress';
  static const String progressHistoryEndpoint = '/progress/history';
  static const String progressDetailEndpoint = '/progress';

  // Profile endpoints
  static const String profileEndpoint = '/profile';
  static const String bmiEndpoint = '/bmi';
  static const String patientEndpoint = '/patient';

  // Meal plan endpoints
  static const String mealPlanCurrentEndpoint = '/meal-plan/current';
  static const String mealPlansEndpoint = '/meal-plans';
  static const String mealPlanSelectOptionEndpoint = '/meal-plans';
  static const String mealPlanStatsEndpoint = '/meal-plans';

  // API Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeout settings
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Retry settings
  static const int maxRetries = 3;
  static const int retryDelay = 1000; // 1 second

  // Pagination settings
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File upload settings
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp',
  ];

  // Chat settings
  static const int maxMessageLength = 1000;
  static const int typingIndicatorDelay = 500; // milliseconds

  // Error messages
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String unauthorizedErrorMessage =
      'Unauthorized. Please log in again.';
  static const String forbiddenErrorMessage = 'Access denied.';
  static const String notFoundErrorMessage = 'Resource not found.';
  static const String validationErrorMessage =
      'Please check your input and try again.';

  /// Get full URL for an endpoint
  static String getUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }

  /// Get chatbot URL for an endpoint
  static String getChatbotUrl(String endpoint) {
    return '$chatbotBaseUrl$endpoint';
  }

  /// Get headers with authentication token
  static Map<String, String> getAuthHeaders(String token) {
    return {
      ...defaultHeaders,
      'Authorization': 'Bearer $token',
    };
  }

  /// Get headers for multipart requests
  static Map<String, String> getMultipartHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  /// Validate file type
  static bool isValidImageType(String mimeType) {
    return allowedImageTypes.contains(mimeType.toLowerCase());
  }

  /// Validate file size
  static bool isValidFileSize(int sizeInBytes) {
    return sizeInBytes <= maxFileSize;
  }

  /// Get error message for status code
  static String getErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return validationErrorMessage;
      case 401:
        return unauthorizedErrorMessage;
      case 403:
        return forbiddenErrorMessage;
      case 404:
        return notFoundErrorMessage;
      case 500:
      case 502:
      case 503:
        return serverErrorMessage;
      default:
        return networkErrorMessage;
    }
  }

  /// Get retry delay with exponential backoff
  static int getRetryDelay(int attempt) {
    return retryDelay * (attempt + 1);
  }
}
