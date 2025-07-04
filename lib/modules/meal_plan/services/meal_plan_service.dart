import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/exceptions/api_exception.dart';
import '../../../core/services/api_service.dart';
import '../../progress/utils/api_response_logger.dart';
import '../models/meal_plan_model.dart';

class MealPlanService {
  final ApiService _apiService = Get.find<ApiService>();
  final String baseUrl = 'https://dietilink.syscomdemos.com/api/v1';

  /// Fetch current meal plan for the user
  Future<MealPlan?> fetchCurrentPlan() async {
    try {
      print('🔍 Service: Starting fetchCurrentPlan...');
      final response = await _apiService.get('/meal-plan/current');

      // Log response for debugging
      response.logApiResponse('GET /meal-plan/current');

      print('🔍 Service: Checking has_active_plan...');
      final hasActivePlan = response['data']?['has_active_plan'] == true;
      print('📋 Service: has_active_plan = $hasActivePlan');
      print(
          '📋 Service: has_active_plan raw value = ${response['data']?['has_active_plan']}');
      print(
          '📋 Service: has_active_plan type = ${response['data']?['has_active_plan']?.runtimeType}');

      if (hasActivePlan && response['data'] != null) {
        print('✅ Service: Parsing meal plan data...');
        try {
          final mealPlan = MealPlan.fromJson(response['data']);
          print('✅ Service: Successfully parsed meal plan: ${mealPlan.name}');
          return mealPlan;
        } catch (parseError) {
          print('❌ Service: Parsing error: $parseError');
          throw ApiException('Failed to parse meal plan data: $parseError');
        }
      } else {
        print('⚠️ Service: No active plan found');
        print('📋 Service: hasActivePlan = $hasActivePlan');
        print('📋 Service: data exists = ${response['data'] != null}');
        return null;
      }
    } on ApiException catch (e) {
      print('❌ MealPlanService.fetchCurrentPlan API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ MealPlanService.fetchCurrentPlan unexpected error: $e');
      print('❌ Error type: ${e.runtimeType}');
      throw ApiException('Failed to load meal plan: $e');
    }
  }

  /// Fetch meal plan by ID
  Future<MealPlan> fetchMealPlanById(String planId) async {
    try {
      final response = await _apiService.get('/meal-plan/$planId');

      // Log response for debugging
      response.logApiResponse('GET /meal-plan/$planId');

      return MealPlan.fromJson(response);
    } on ApiException catch (e) {
      print('❌ MealPlanService.fetchMealPlanById failed: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ MealPlanService.fetchMealPlanById unexpected error: $e');
      throw ApiException('Failed to load meal plan: $e');
    }
  }

  /// Get all meal plans for the user
  Future<List<MealPlan>> fetchAllMealPlans() async {
    try {
      final response = await _apiService.get('/meal-plans');

      // Log response for debugging
      response.logApiResponse('GET /meal-plans');

      final List<dynamic> plansData =
          response['meal_plans'] ?? response['data'] ?? [];
      return plansData.map((plan) => MealPlan.fromJson(plan)).toList();
    } on ApiException catch (e) {
      print('❌ MealPlanService.fetchAllMealPlans failed: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ MealPlanService.fetchAllMealPlans unexpected error: $e');
      throw ApiException('Failed to load meal plans: $e');
    }
  }

  /// Create a new meal plan
  Future<MealPlan> createMealPlan(Map<String, dynamic> planData) async {
    try {
      final response = await _apiService.post('/meal-plans', data: planData);

      // Log response for debugging
      response.logApiResponse('POST /meal-plans');

      return MealPlan.fromJson(response);
    } on ApiException catch (e) {
      print('❌ MealPlanService.createMealPlan failed: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ MealPlanService.createMealPlan unexpected error: $e');
      throw ApiException('Failed to create meal plan: $e');
    }
  }

  /// Update an existing meal plan
  Future<MealPlan> updateMealPlan(
      String planId, Map<String, dynamic> planData) async {
    try {
      final response =
          await _apiService.put('/meal-plans/$planId', data: planData);

      // Log response for debugging
      response.logApiResponse('PUT /meal-plans/$planId');

      return MealPlan.fromJson(response);
    } on ApiException catch (e) {
      print('❌ MealPlanService.updateMealPlan failed: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ MealPlanService.updateMealPlan unexpected error: $e');
      throw ApiException('Failed to update meal plan: $e');
    }
  }

  /// Delete a meal plan
  Future<void> deleteMealPlan(String planId) async {
    try {
      await _apiService.delete('/meal-plans/$planId');
      print('✅ Meal plan deleted successfully');
    } on ApiException catch (e) {
      print('❌ MealPlanService.deleteMealPlan failed: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ MealPlanService.deleteMealPlan unexpected error: $e');
      throw ApiException('Failed to delete meal plan: $e');
    }
  }

  /// Select a meal option
  Future<void> selectMealOption(
      String planId, String mealType, int optionNumber) async {
    try {
      final data = {
        'meal_type': mealType,
        'option_number': optionNumber,
      };

      final response = await _apiService
          .post('/meal-plans/$planId/select-option', data: data);

      // Log response for debugging
      response.logApiResponse('POST /meal-plans/$planId/select-option');

      print('✅ Meal option selected successfully');
    } on ApiException catch (e) {
      print('❌ MealPlanService.selectMealOption failed: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ MealPlanService.selectMealOption unexpected error: $e');
      throw ApiException('Failed to select meal option: $e');
    }
  }

  /// Get meal plan statistics
  Future<Map<String, dynamic>> getMealPlanStats(String planId) async {
    try {
      final response = await _apiService.get('/meal-plans/$planId/stats');

      // Log response for debugging
      response.logApiResponse('GET /meal-plans/$planId/stats');

      return response;
    } on ApiException catch (e) {
      print('❌ MealPlanService.getMealPlanStats failed: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ MealPlanService.getMealPlanStats unexpected error: $e');
      throw ApiException('Failed to get meal plan stats: $e');
    }
  }
}
