import 'package:get/get.dart';
import '../services/chatbot_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/exceptions/api_exception.dart';
import '../models/chat_message.dart';
import '../models/chat_response.dart';
import '../../../services/nutrition_chatbot_service.dart';

class ChatbotController extends GetxController {
  final ChatbotService _chatbotService = Get.find<ChatbotService>();
  final NutritionChatbotService _nutritionService = NutritionChatbotService();
  final AuthService _authService = Get.find<AuthService>();

  // Observable variables
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;
  final RxString error = ''.obs;
  final RxString currentMessage = ''.obs;
  final RxBool isConnected = true.obs;
  final RxBool isPythonServerAvailable = false.obs;

  // Chat session management
  String? _sessionId;
  final RxBool hasUnreadMessages = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkPythonServer();
    _setupWelcomeMessage();
    _loadUserChatHistory(); // Load existing chat history
  }

  /// Check if Python server is available
  Future<void> _checkPythonServer() async {
    try {
      final isAvailable = await _chatbotService.checkServerHealth();
      isPythonServerAvailable.value = isAvailable;
      print('ChatbotController: Python server check completed');
    } catch (e) {
      print('ChatbotController: Python server check failed: $e');
      isPythonServerAvailable.value = false;
    }
  }

  /// Send a message to the chatbot
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    try {
      print('ChatbotController: Sending message: "$message"');

      // Add user message to chat
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: message,
        isUser: true,
        timestamp: DateTime.now(),
        senderName: 'You',
      );
      messages.add(userMessage);
      print(
          'ChatbotController: User message added. Total messages: ${messages.length}');

      // Get response from Python server
      final response = await _chatbotService.sendMessage(message);
      print('ChatbotController: Python API response: ${response.response}');

      // Add bot response to chat
      final botMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        message: response.response,
        isUser: false,
        timestamp: DateTime.now(),
        senderName: 'Assistant',
      );
      messages.add(botMessage);
      print(
          'ChatbotController: Bot message added. Total messages: ${messages.length}');
    } catch (e) {
      print('ChatbotController: Error getting response: $e');

      // Add error message to chat
      final errorMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        message: 'Failed to get response: $e',
        isUser: false,
        timestamp: DateTime.now(),
        senderName: 'System',
      );
      messages.add(errorMessage);
      print(
          'ChatbotController: Error message added. Total messages: ${messages.length}');
    }
  }

  /// Send a quick reply
  Future<void> sendQuickReply(String reply) async {
    // Check for special actions
    if (reply.toLowerCase().contains('test python server')) {
      await testPythonServer();
    } else if (reply.toLowerCase().contains('refresh python server')) {
      await refreshPythonServer();
    } else if (reply.toLowerCase().contains('python nutrition advice')) {
      await getPythonNutritionAdvice();
    } else if (reply.toLowerCase().contains('python meal plan')) {
      await generatePythonMealPlan();
    } else if (reply.toLowerCase().contains('python model version')) {
      await checkPythonModelVersion();
    } else {
      // Regular message
      await sendMessage(reply);
    }
  }

  /// Get nutrition advice
  Future<void> getNutritionAdvice({
    String? userContext,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      print('ChatbotController: Getting nutrition advice...');

      final response = await _chatbotService.getNutritionAdvice(
        userContext: userContext,
        preferences: preferences,
      );

      final adviceMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: _formatNutritionAdvice(response),
        isUser: false,
        timestamp: DateTime.now(),
        senderName: 'Assistant',
      );

      messages.add(adviceMessage);
      print('ChatbotController: Nutrition advice received');
    } on ApiException catch (e) {
      print('ChatbotController.getNutritionAdvice API error: ${e.message}');
      _addErrorMessage('Failed to get nutrition advice: ${e.message}');
    } catch (e) {
      print('ChatbotController.getNutritionAdvice unexpected error: $e');
      _addErrorMessage('Failed to get nutrition advice: $e');
    }
  }

  /// Generate a meal plan
  Future<void> generateMealPlan({
    Map<String, dynamic>? requirements,
    String? dietaryRestrictions,
    int? days,
  }) async {
    try {
      print('ChatbotController: Generating meal plan...');

      final response = await _chatbotService.generateMealPlan(
        requirements: requirements,
        dietaryRestrictions: dietaryRestrictions,
        days: days,
      );

      final mealPlanMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: _formatMealPlan(response),
        isUser: false,
        timestamp: DateTime.now(),
        senderName: 'Assistant',
      );

      messages.add(mealPlanMessage);
      print('ChatbotController: Meal plan generated');
    } on ApiException catch (e) {
      print('ChatbotController.generateMealPlan API error: ${e.message}');
      _addErrorMessage('Failed to generate meal plan: ${e.message}');
    } catch (e) {
      print('ChatbotController.generateMealPlan unexpected error: $e');
      _addErrorMessage('Failed to generate meal plan: $e');
    }
  }

  /// Book an appointment
  Future<void> bookAppointment({
    required DateTime dateTime,
    String? reason,
    String? notes,
  }) async {
    try {
      print('ChatbotController: Booking appointment...');

      final response = await _chatbotService.bookAppointment(
        dateTime: dateTime,
        reason: reason,
        notes: notes,
      );

      final appointmentMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: _formatAppointmentBooking(response),
        isUser: false,
        timestamp: DateTime.now(),
        senderName: 'Assistant',
      );

      messages.add(appointmentMessage);
      print('ChatbotController: Appointment booked');
    } on ApiException catch (e) {
      print('ChatbotController.bookAppointment API error: ${e.message}');
      _addErrorMessage('Failed to book appointment: ${e.message}');
    } catch (e) {
      print('ChatbotController.bookAppointment unexpected error: $e');
      _addErrorMessage('Failed to book appointment: $e');
    }
  }

  /// Clear chat history
  Future<void> clearChat() async {
    try {
      print('ChatbotController: Clearing chat...');

      await _chatbotService.clearChatHistory();
      messages.clear();
      _setupWelcomeMessage();

      print('ChatbotController: Chat cleared');
    } on ApiException catch (e) {
      print('ChatbotController.clearChat API error: ${e.message}');
      _addErrorMessage('Failed to clear chat: ${e.message}');
    } catch (e) {
      print('ChatbotController.clearChat unexpected error: $e');
      _addErrorMessage('Failed to clear chat: $e');
    }
  }

  /// Show typing indicator
  void _showTypingIndicator() {
    isTyping.value = true;

    // Remove any existing typing indicator
    messages.removeWhere((msg) => msg.isTyping);

    // Add typing indicator
    final typingMessage = ChatMessage.typing(senderName: 'Assistant');
    messages.add(typingMessage);
  }

  /// Hide typing indicator
  void _hideTypingIndicator() {
    isTyping.value = false;
    messages.removeWhere((msg) => msg.isTyping);
  }

  /// Setup welcome message
  void _setupWelcomeMessage() {
    // Only show welcome message if there are no existing messages
    if (messages.isEmpty) {
      final welcomeMessage = ChatMessage.bot(
        message:
            'Hello! I\'m your AI health assistant. I can help you with nutrition advice, meal planning, and wellness guidance. What would you like to know today?',
        senderName: 'Assistant',
        quickReplies: [
          {'text': 'Get nutrition advice', 'action': 'nutrition_advice'},
          {'text': 'Help with meal planning', 'action': 'meal_plan'},
          {'text': 'General health tips', 'action': 'health_tips'},
          {'text': 'Track my progress', 'action': 'track_progress'},
        ],
      );
      messages.add(welcomeMessage);
    }
  }

  /// Update current message text
  void updateCurrentMessage(String text) {
    currentMessage.value = text;
  }

  /// Check if user can send message
  bool get canSendMessage {
    return currentMessage.value.trim().isNotEmpty &&
        !isLoading.value &&
        !isTyping.value;
  }

  /// Get latest message
  ChatMessage? get latestMessage {
    return messages.isNotEmpty ? messages.last : null;
  }

  /// Get unread message count
  int get unreadCount {
    return messages.where((msg) => !msg.isUser && !msg.isTyping).length;
  }

  /// Mark messages as read
  void markAsRead() {
    hasUnreadMessages.value = false;
  }

  /// Handle connection status
  void updateConnectionStatus(bool connected) {
    isConnected.value = connected;
    if (!connected) {
      error.value = 'Connection lost. Please check your internet connection.';
    }
  }

  /// Retry last failed operation
  Future<void> retryLastOperation() async {
    if (error.value.isNotEmpty) {
      error.value = '';
    }
  }

  /// Check AI model version
  Future<void> checkModelVersion() async {
    try {
      print('ChatbotController: Checking model version...');

      final response = await _chatbotService.checkModelVersion();

      if (response['version'] != null) {
        final versionMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: 'AI Model Version Info\n\n'
              'Current Version: ${response['version']}\n'
              'Model Type: ${response['model_type'] ?? 'Unknown'}\n'
              'Last Updated: ${response['last_updated'] ?? 'Unknown'}\n'
              'Status: ${response['status'] ?? 'Active'}',
          isUser: false,
          timestamp: DateTime.now(),
          senderName: 'System',
        );

        messages.add(versionMessage);
      }

      print('ChatbotController: Model version checked');
    } on ApiException catch (e) {
      print('ChatbotController.checkModelVersion API error: ${e.message}');
      _addErrorMessage('Failed to check model version: ${e.message}');
    } catch (e) {
      print('ChatbotController.checkModelVersion unexpected error: $e');
      _addErrorMessage('Failed to check model version: $e');
    }
  }

  /// Get model update status
  Future<void> getModelUpdateStatus() async {
    try {
      print('ChatbotController: Getting model update status...');

      final response = await _chatbotService.getModelUpdateStatus();

      if (response['updates'] != null) {
        final updates = response['updates'] as List;
        String updateMessage = 'AI Model Updates\n\n';

        if (updates.isEmpty) {
          updateMessage += 'No updates available. Your AI model is up to date!';
        } else {
          updateMessage += 'Available Updates:\n';
          for (final update in updates) {
            updateMessage +=
                '• ${update['version']} - ${update['description']}\n';
          }
        }

        final updateStatusMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: updateMessage,
          isUser: false,
          timestamp: DateTime.now(),
          senderName: 'System',
        );

        messages.add(updateStatusMessage);
      }

      print('ChatbotController: Model update status retrieved');
    } on ApiException catch (e) {
      print('ChatbotController.getModelUpdateStatus API error: ${e.message}');
      _addErrorMessage('Failed to get model update status: ${e.message}');
    } catch (e) {
      print('ChatbotController.getModelUpdateStatus unexpected error: $e');
      _addErrorMessage('Failed to get model update status: $e');
    }
  }

  // ===== Python Nutrition Service Methods =====

  /// Test Python nutrition server connection
  Future<void> testPythonServer() async {
    try {
      isLoading.value = true;
      error.value = '';

      print('🐍 ChatbotController: Testing Python server connection...');

      final testResult = await _nutritionService.testConnection();

      String statusMessage = '🔗 **Python Nutrition Server Test**\n\n';

      if (testResult['connected'] == true) {
        statusMessage += '✅ **Server Status:** Connected\n';
        statusMessage += '✅ **Health Check:** Passed\n';
        statusMessage += '✅ **Test Message:** Sent\n';
        statusMessage += '✅ **Response:** Received\n\n';
        statusMessage += '🎉 Python nutrition server is working perfectly!';

        isPythonServerAvailable.value = true;
      } else {
        statusMessage += '❌ **Server Status:** Disconnected\n';
        statusMessage += '❌ **Health Check:** Failed\n';
        statusMessage += '❌ **Test Message:** Failed\n';
        statusMessage += '❌ **Response:** None\n\n';
        statusMessage +=
            '💡 **Error:** ${testResult['error'] ?? 'Unknown error'}\n\n';
        statusMessage += '🔧 **Troubleshooting:**\n';
        statusMessage +=
            '• Make sure Python server is running on localhost:8000\n';
        statusMessage += '• Check if the server is accessible\n';
        statusMessage += '• Verify the API endpoints are correct';

        isPythonServerAvailable.value = false;
      }

      final testMessage = ChatMessage.bot(
        message: statusMessage,
        senderName: 'System',
        metadata: {'python_server_test': testResult},
      );

      messages.add(testMessage);
      print('✅ ChatbotController: Python server test completed');
    } catch (e) {
      print('❌ ChatbotController.testPythonServer error: $e');
      error.value = 'Failed to test Python server: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Get nutrition advice from Python service
  Future<void> getPythonNutritionAdvice({
    String? userContext,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      if (!isPythonServerAvailable.value) {
        error.value = 'Python nutrition server is not available';
        return;
      }

      isLoading.value = true;
      error.value = '';

      print('🥗 ChatbotController: Getting Python nutrition advice...');

      final response = await _nutritionService.getNutritionAdvice(
        userContext: userContext,
        preferences: preferences,
      );

      final adviceMessage = ChatMessage.bot(
        message: response.message,
        senderName: 'Nutrition Assistant',
        metadata: response.metadata,
        quickReplies: response.quickReplies,
      );

      messages.add(adviceMessage);
      print('✅ ChatbotController: Python nutrition advice received');
    } catch (e) {
      print('❌ ChatbotController.getPythonNutritionAdvice error: $e');
      error.value = 'Failed to get nutrition advice: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Generate meal plan using Python service
  Future<void> generatePythonMealPlan({
    Map<String, dynamic>? requirements,
    String? dietaryRestrictions,
    int? days,
  }) async {
    try {
      if (!isPythonServerAvailable.value) {
        error.value = 'Python nutrition server is not available';
        return;
      }

      isLoading.value = true;
      error.value = '';

      print('🍽️ ChatbotController: Generating Python meal plan...');

      final response = await _nutritionService.generateMealPlan(
        requirements: requirements,
        dietaryRestrictions: dietaryRestrictions,
        days: days,
      );

      final mealPlanMessage = ChatMessage.bot(
        message: response.message,
        senderName: 'Meal Planner',
        metadata: response.metadata,
        quickReplies: response.quickReplies,
      );

      messages.add(mealPlanMessage);
      print('✅ ChatbotController: Python meal plan generated');
    } catch (e) {
      print('❌ ChatbotController.generatePythonMealPlan error: $e');
      error.value = 'Failed to generate meal plan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Check Python model version
  Future<void> checkPythonModelVersion() async {
    try {
      if (!isPythonServerAvailable.value) {
        error.value = 'Python nutrition server is not available';
        return;
      }

      isLoading.value = true;
      error.value = '';

      print('🔍 ChatbotController: Checking Python model version...');

      final response = await _nutritionService.checkModelVersion();

      String versionMessage = '🤖 **Python AI Model Version**\n\n';
      versionMessage += '**Version:** ${response['version'] ?? 'Unknown'}\n';
      versionMessage +=
          '**Model Type:** ${response['model_type'] ?? 'Unknown'}\n';
      versionMessage +=
          '**Last Updated:** ${response['last_updated'] ?? 'Unknown'}\n';
      versionMessage += '**Status:** ${response['status'] ?? 'Active'}\n';

      final versionInfoMessage = ChatMessage.bot(
        message: versionMessage,
        senderName: 'System',
        metadata: {'python_model_info': response},
      );

      messages.add(versionInfoMessage);
      print('✅ ChatbotController: Python model version checked');
    } catch (e) {
      print('❌ ChatbotController.checkPythonModelVersion error: $e');
      error.value = 'Failed to check Python model version: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh Python server connection
  Future<void> refreshPythonServer() async {
    await _checkPythonServer();

    final statusMessage = ChatMessage.bot(
      message: isPythonServerAvailable.value
          ? '✅ Python nutrition server is now available!'
          : '❌ Python nutrition server is not available. Please check if the server is running on localhost:8000',
      senderName: 'System',
    );

    messages.add(statusMessage);
  }

  /// Load user's chat history from the backend
  Future<void> _loadUserChatHistory() async {
    try {
      print('ChatbotController: Loading user chat history...');
      final history = await _chatbotService.getUserChatHistory();

      if (history.isNotEmpty) {
        // Convert history to ChatMessage objects
        for (final msg in history) {
          final message = ChatMessage(
            id: msg['id']?.toString() ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            message: msg['message']?.toString() ?? '',
            isUser: msg['is_user'] == true || msg['sender'] == 'user',
            timestamp: msg['timestamp'] != null
                ? DateTime.parse(msg['timestamp'].toString())
                : DateTime.now(),
            senderName: msg['sender_name']?.toString() ??
                (msg['is_user'] == true ? 'You' : 'Assistant'),
          );
          messages.add(message);
        }
        print(
            'ChatbotController: Loaded ${history.length} messages from history');
      } else {
        print('ChatbotController: No chat history found');
      }
    } catch (e) {
      print('ChatbotController: Could not load chat history: $e');
      // Continue without history - this is not critical
    }
  }

  void _addErrorMessage(String message) {
    final errorMessage = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      message: message,
      isUser: false,
      timestamp: DateTime.now(),
      senderName: 'System',
    );
    messages.add(errorMessage);
    print(
        'ChatbotController: Error message added. Total messages: ${messages.length}');
  }

  String _formatNutritionAdvice(Map<String, dynamic> response) {
    if (response['message'] != null) {
      return response['message'].toString();
    }
    return 'Nutrition advice received successfully.';
  }

  String _formatMealPlan(Map<String, dynamic> response) {
    if (response['message'] != null) {
      return response['message'].toString();
    }
    return 'Meal plan generated successfully.';
  }

  String _formatAppointmentBooking(Map<String, dynamic> response) {
    if (response['message'] != null) {
      return response['message'].toString();
    }
    return 'Appointment booked successfully.';
  }
}
