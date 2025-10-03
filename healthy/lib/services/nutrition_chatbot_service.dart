import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../modules/chatbot/models/chat_response.dart';

/// Nutrition Chatbot Service for Python API Integration
///
/// This service connects to the Python FastAPI server running on localhost:8000
/// and provides nutrition advice, meal planning, and wellness guidance.
class NutritionChatbotService {
  static const String _baseUrl = 'http://localhost:8000';

  // API Endpoints
  static const String _healthEndpoint = '/health';
  static const String _chatEndpoint = '/chat';
  static const String _nutritionAdviceEndpoint = '/nutrition/advice';
  static const String _mealPlanEndpoint = '/meal-plan';
  static const String _modelInfoEndpoint = '/model/info';
  static const String _modelUpdatesEndpoint = '/model/updates';

  /// Check if the Python API server is running
  Future<bool> checkServerHealth() async {
    try {
      print('🏥 NutritionChatbotService: Checking server health...');

      final response = await http.get(
        Uri.parse('$_baseUrl$_healthEndpoint'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(
            '✅ NutritionChatbotService: Server is healthy - ${data['service']}');
        return true;
      } else {
        print(
            '❌ NutritionChatbotService: Server health check failed - ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ NutritionChatbotService: Server health check error - $e');
      return false;
    }
  }

  /// Send a message to the nutrition chatbot
  Future<ChatResponse> sendMessage(String message) async {
    try {
      print(
          '🤖 NutritionChatbotService: Sending message: ${message.substring(0, message.length > 50 ? 50 : message.length)}...');

      final response = await http
          .post(
            Uri.parse('$_baseUrl$_chatEndpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'message': message,
              'timestamp': DateTime.now().toIso8601String(),
              'language': _detectLanguage(message),
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ NutritionChatbotService: Message sent successfully');
        return ChatResponse.fromJson(data);
      } else {
        print(
            '❌ NutritionChatbotService: Send message failed - ${response.statusCode}');
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ NutritionChatbotService: Send message error - $e');
      throw Exception('Failed to send message: $e');
    }
  }

  /// Get nutrition advice
  Future<ChatResponse> getNutritionAdvice({
    String? userContext,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      print('🥗 NutritionChatbotService: Getting nutrition advice...');

      final Map<String, dynamic> requestData = {
        'timestamp': DateTime.now().toIso8601String(),
      };

      if (userContext != null) {
        requestData['user_context'] = userContext;
      }

      if (preferences != null) {
        requestData['preferences'] = preferences;
      }

      final response = await http
          .post(
            Uri.parse('$_baseUrl$_nutritionAdviceEndpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestData),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ NutritionChatbotService: Nutrition advice received');
        return ChatResponse.fromJson(data);
      } else {
        print(
            '❌ NutritionChatbotService: Nutrition advice failed - ${response.statusCode}');
        throw Exception(
            'Failed to get nutrition advice: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ NutritionChatbotService: Nutrition advice error - $e');
      throw Exception('Failed to get nutrition advice: $e');
    }
  }

  /// Generate meal plan
  Future<ChatResponse> generateMealPlan({
    Map<String, dynamic>? requirements,
    String? dietaryRestrictions,
    int? days,
  }) async {
    try {
      print('🍽️ NutritionChatbotService: Generating meal plan...');

      final Map<String, dynamic> requestData = {
        'timestamp': DateTime.now().toIso8601String(),
      };

      if (requirements != null) {
        requestData['requirements'] = requirements;
      }

      if (dietaryRestrictions != null) {
        requestData['dietary_restrictions'] = dietaryRestrictions;
      }

      if (days != null) {
        requestData['days'] = days;
      }

      final response = await http
          .post(
            Uri.parse('$_baseUrl$_mealPlanEndpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestData),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ NutritionChatbotService: Meal plan generated');
        return ChatResponse.fromJson(data);
      } else {
        print(
            '❌ NutritionChatbotService: Meal plan generation failed - ${response.statusCode}');
        throw Exception('Failed to generate meal plan: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ NutritionChatbotService: Meal plan generation error - $e');
      throw Exception('Failed to generate meal plan: $e');
    }
  }

  /// Check AI model version
  Future<Map<String, dynamic>> checkModelVersion() async {
    try {
      print('🔍 NutritionChatbotService: Checking model version...');

      final response = await http.get(
        Uri.parse('$_baseUrl$_modelInfoEndpoint'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ NutritionChatbotService: Model version info retrieved');
        return data;
      } else {
        print(
            '❌ NutritionChatbotService: Model version check failed - ${response.statusCode}');
        throw Exception(
            'Failed to check model version: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ NutritionChatbotService: Model version check error - $e');
      throw Exception('Failed to check model version: $e');
    }
  }

  /// Get model update status
  Future<Map<String, dynamic>> getModelUpdateStatus() async {
    try {
      print('🔄 NutritionChatbotService: Getting model update status...');

      final response = await http.get(
        Uri.parse('$_baseUrl$_modelUpdatesEndpoint'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ NutritionChatbotService: Model update status retrieved');
        return data;
      } else {
        print(
            '❌ NutritionChatbotService: Model update status failed - ${response.statusCode}');
        throw Exception(
            'Failed to get model update status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ NutritionChatbotService: Model update status error - $e');
      throw Exception('Failed to get model update status: $e');
    }
  }

  /// Detect language of the message
  String _detectLanguage(String message) {
    // Simple Arabic detection - check for Arabic characters
    final arabicRegex = RegExp(
        r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
    if (arabicRegex.hasMatch(message)) {
      return 'ar';
    }
    return 'en';
  }

  /// Test connection to the Python server
  Future<Map<String, dynamic>> testConnection() async {
    try {
      print('🔗 NutritionChatbotService: Testing connection...');

      final isHealthy = await checkServerHealth();

      if (isHealthy) {
        // Try a simple test message
        final testResponse = await sendMessage('Hello');

        return {
          'connected': true,
          'server_healthy': true,
          'test_message_sent': true,
          'response_received': testResponse.message.isNotEmpty,
        };
      } else {
        return {
          'connected': false,
          'server_healthy': false,
          'test_message_sent': false,
          'response_received': false,
          'error': 'Server is not healthy',
        };
      }
    } catch (e) {
      print('❌ NutritionChatbotService: Connection test failed - $e');
      return {
        'connected': false,
        'server_healthy': false,
        'test_message_sent': false,
        'response_received': false,
        'error': e.toString(),
      };
    }
  }
}
