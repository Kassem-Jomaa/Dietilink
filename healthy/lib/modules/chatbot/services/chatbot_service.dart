import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/exceptions/api_exception.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_service.dart';

class ChatResponse {
  final String response;
  ChatResponse({required this.response});
  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      ChatResponse(response: json['response'] ?? json['message'] ?? '');
}

class ChatbotService {
  final ApiService _apiService = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();
  static const String baseUrl =
      "http://localhost:8000"; // or use 10.0.2.2 for Android emulator

  /// Get the current user ID for chat personalization
  String _getUserId() {
    try {
      final userData = _authService.userData.value;
      if (userData.isNotEmpty && userData['id'] != null) {
        return userData['id'].toString();
      }
    } catch (e) {
      print('ChatbotService: Could not get user ID: $e');
    }
    // Fallback to a device-specific ID or generate one
    return "user_${DateTime.now().millisecondsSinceEpoch}";
  }

  /// Send a message to the chatbot with user personalization
  Future<ChatResponse> sendMessage(String message) async {
    final userId = _getUserId();
    print('ChatbotService: Sending message with user_id: $userId');

    final url = Uri.parse('$baseUrl/chat');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'message': message,
        'user_id': userId,
      }),
    );
    final decodedBody = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      return ChatResponse.fromJson(jsonDecode(decodedBody));
    } else {
      throw Exception("Failed to get response: " + decodedBody);
    }
  }

  /// Get chat history for the current user from the new endpoint
  Future<List<Map<String, dynamic>>> getUserChatHistory() async {
    try {
      final userId = _getUserId();
      print('ChatbotService: Fetching chat history for user: $userId');

      final url = Uri.parse('$baseUrl/user/$userId/history');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      final decodedBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);
        final List<dynamic> historyData =
            data['messages'] ?? data['history'] ?? [];
        final List<Map<String, dynamic>> history =
            historyData.map((msg) => Map<String, dynamic>.from(msg)).toList();

        print(
            'ChatbotService: Retrieved ${history.length} messages for user $userId');
        return history;
      } else {
        throw Exception("Failed to get chat history: ${decodedBody}");
      }
    } catch (e) {
      print('ChatbotService.getUserChatHistory error: $e');
      throw ApiException('Failed to load chat history: $e');
    }
  }

  /// Get nutrition advice with meal plan context
  Future<Map<String, dynamic>> getNutritionAdvice({
    String? userContext,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      print('🤖 ChatbotService: Getting nutrition advice...');

      final data = <String, dynamic>{
        'timestamp': DateTime.now().toIso8601String(),
        'context': {
          'has_meal_plan': false,
        },
      };

      if (userContext != null) {
        data['user_context'] = userContext;
      }

      if (preferences != null) {
        data['preferences'] = preferences;
      }

      final response = await _apiService.post('/nutrition/advice', data: data);

      print('✅ ChatbotService: Nutrition advice received');
      return response;
    } on ApiException catch (e) {
      print('❌ ChatbotService.getNutritionAdvice API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ ChatbotService.getNutritionAdvice unexpected error: $e');
      throw ApiException('Failed to get nutrition advice: $e');
    }
  }

  /// Generate a meal plan via chatbot with current plan context
  Future<Map<String, dynamic>> generateMealPlan({
    Map<String, dynamic>? requirements,
    String? dietaryRestrictions,
    int? days,
  }) async {
    try {
      print('🤖 ChatbotService: Generating meal plan...');

      final data = <String, dynamic>{
        'timestamp': DateTime.now().toIso8601String(),
        'context': {
          'has_meal_plan': false,
        },
      };

      if (requirements != null) {
        data['requirements'] = requirements;
      }

      if (dietaryRestrictions != null) {
        data['dietary_restrictions'] = dietaryRestrictions;
      }

      if (days != null) {
        data['days'] = days;
      }

      final response =
          await _apiService.post('/nutrition/meal-plan', data: data);

      print('✅ ChatbotService: Meal plan generated successfully');
      return response;
    } on ApiException catch (e) {
      print('❌ ChatbotService.generateMealPlan API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ ChatbotService.generateMealPlan unexpected error: $e');
      throw ApiException('Failed to generate meal plan: $e');
    }
  }

  /// Get meal plan information for chatbot responses
  Future<Map<String, dynamic>> getMealPlanInfo() async {
    try {
      print('🤖 ChatbotService: Getting meal plan info...');
      return {
        'has_meal_plan': false,
        'message': 'No active meal plan found',
      };
    } catch (e) {
      print('❌ ChatbotService.getMealPlanInfo error: $e');
      return {
        'has_meal_plan': false,
        'error': 'Could not fetch meal plan information',
      };
    }
  }

  /// Book an appointment via chatbot
  Future<Map<String, dynamic>> bookAppointment({
    required DateTime dateTime,
    String? reason,
    String? notes,
  }) async {
    try {
      print('🤖 ChatbotService: Booking appointment...');

      final data = <String, dynamic>{
        'appointment_date': dateTime.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      if (reason != null) {
        data['reason'] = reason;
      }

      if (notes != null) {
        data['notes'] = notes;
      }

      final response = await _apiService.post('/appointments/book', data: data);

      print('✅ ChatbotService: Appointment booked successfully');
      return response;
    } on ApiException catch (e) {
      print('❌ ChatbotService.bookAppointment API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ ChatbotService.bookAppointment unexpected error: $e');
      throw ApiException('Failed to book appointment: $e');
    }
  }

  /// Get available appointment slots
  Future<List<DateTime>> getAvailableSlots({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      print('🤖 ChatbotService: Getting available slots...');

      final queryParameters = <String, dynamic>{};

      if (startDate != null) {
        queryParameters['start_date'] = startDate.toIso8601String();
      }

      if (endDate != null) {
        queryParameters['end_date'] = endDate.toIso8601String();
      }

      final response = await _apiService.get('/appointments/slots',
          queryParameters: queryParameters);

      final List<dynamic> slotsData =
          response['slots'] ?? response['data'] ?? [];
      final List<DateTime> slots =
          slotsData.map((slot) => DateTime.parse(slot.toString())).toList();

      print('✅ ChatbotService: Retrieved ${slots.length} available slots');
      return slots;
    } on ApiException catch (e) {
      print('❌ ChatbotService.getAvailableSlots API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ ChatbotService.getAvailableSlots unexpected error: $e');
      throw ApiException('Failed to get available slots: $e');
    }
  }

  /// Clear chat history
  Future<void> clearChatHistory() async {
    try {
      print('🤖 ChatbotService: Clearing chat history...');

      await _apiService.delete('/chat/history');

      print('✅ ChatbotService: Chat history cleared successfully');
    } on ApiException catch (e) {
      print('❌ ChatbotService.clearChatHistory API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ ChatbotService.clearChatHistory unexpected error: $e');
      throw ApiException('Failed to clear chat history: $e');
    }
  }

  /// Check AI model version and updates
  Future<Map<String, dynamic>> checkModelVersion() async {
    try {
      print('🤖 ChatbotService: Checking AI model version...');

      final response = await _apiService.get('/chat/model-info');

      print('✅ ChatbotService: Model version info retrieved');
      return response;
    } on ApiException catch (e) {
      print('❌ ChatbotService.checkModelVersion API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ ChatbotService.checkModelVersion unexpected error: $e');
      throw ApiException('Failed to check model version: $e');
    }
  }

  /// Get AI model update status
  Future<Map<String, dynamic>> getModelUpdateStatus() async {
    try {
      print('🤖 ChatbotService: Getting model update status...');

      final response = await _apiService.get('/chat/model-updates');

      print('✅ ChatbotService: Model update status retrieved');
      return response;
    } on ApiException catch (e) {
      print('❌ ChatbotService.getModelUpdateStatus API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ ChatbotService.getModelUpdateStatus unexpected error: $e');
      throw ApiException('Failed to get model update status: $e');
    }
  }

  /// Check if the Python server is healthy and available
  Future<bool> checkServerHealth() async {
    try {
      final url = Uri.parse('$baseUrl/health');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      final decodedBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);
        print(
            'ChatbotService: Server health check passed - ${data['service']}');
        return true;
      } else {
        print(
            'ChatbotService: Server health check failed - ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('ChatbotService: Server health check error - $e');
      return false;
    }
  }
}
