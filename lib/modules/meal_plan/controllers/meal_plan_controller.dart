import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/exceptions/api_exception.dart';
import '../../../core/widgets/error_message.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../models/meal_plan_model.dart';
import '../services/meal_plan_service.dart';

class MealPlanController extends GetxController {
  final MealPlanService _mealPlanService = Get.find<MealPlanService>();

  // Observable variables
  final Rx<MealPlan?> currentMealPlan = Rx<MealPlan?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxMap<String, int> selectedOptions = <String, int>{}.obs;

  // Statistics
  final RxInt totalMealTypes = 0.obs;
  final RxInt totalMealOptions = 0.obs;
  final RxDouble calorieRange = 0.0.obs;
  final RxDouble totalCalories = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentMealPlan();
  }

  /// Load the current meal plan
  Future<void> loadCurrentMealPlan() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔍 Loading current meal plan...');
      final mealPlan = await _mealPlanService.fetchCurrentPlan();
      print('📦 Received meal plan: ${mealPlan?.name ?? 'NULL'}');
      print('📊 Has meal plan: ${mealPlan != null}');

      currentMealPlan.value = mealPlan;

      if (mealPlan != null) {
        print(
            '✅ Meal plan loaded: ${mealPlan.name} with ${mealPlan.meals.length} meals');
        _updateStatistics(mealPlan);
      } else {
        print('⚠️ No meal plan found - clearing statistics');
        // Clear statistics if no meal plan
        totalMealTypes.value = 0;
        totalMealOptions.value = 0;
        calorieRange.value = 0.0;
        totalCalories.value = 0.0;
      }
    } on ApiException catch (e) {
      print('❌ API Exception: ${e.message}');
      errorMessage.value = e.message;
    } catch (e) {
      print('❌ Unexpected error in loadCurrentMealPlan: $e');
      print('❌ Error type: ${e.runtimeType}');
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
      print(
          '🔄 Loading complete. currentMealPlan.value = ${currentMealPlan.value?.name ?? 'NULL'}');
    }
  }

  /// Update statistics based on current meal plan
  void _updateStatistics(MealPlan mealPlan) {
    totalMealTypes.value = mealPlan.totalMealTypes;
    totalMealOptions.value = mealPlan.totalMealOptions;
    calorieRange.value = mealPlan.calorieRange;
    totalCalories.value = mealPlan.totalEstimatedCalories;
  }

  /// Select a meal option (UI-only for patients)
  Future<void> selectMealOption(String mealType, int optionNumber) async {
    try {
      if (currentMealPlan.value == null) {
        errorMessage.value = 'No active meal plan found';
        return;
      }

      // Update local selection only - no API call needed for patients
      selectedOptions[mealType] = optionNumber;

      Get.snackbar(
        'Success',
        'Meal option selected',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      errorMessage.value = 'Failed to select meal option';
      print('❌ MealPlanController.selectMealOption error: $e');
    }
  }

  /// Get selected option for a meal type
  int? getSelectedOption(String mealType) {
    return selectedOptions[mealType];
  }

  /// Check if an option is selected
  bool isOptionSelected(String mealType, int optionNumber) {
    return selectedOptions[mealType] == optionNumber;
  }

  /// Get status badge color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'draft':
        return Colors.orange;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  /// Get category color for food items
  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'protein':
        return Colors.red.shade300;
      case 'carbs':
        return Colors.orange.shade300;
      case 'fats':
        return Colors.yellow.shade300;
      case 'vegetables':
        return Colors.green.shade300;
      case 'fruits':
        return Colors.pink.shade300;
      case 'dairy':
        return Colors.blue.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  /// Refresh meal plan data
  Future<void> refreshMealPlan() async {
    await loadCurrentMealPlan();
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  /// Get total selected calories
  double get totalSelectedCalories {
    double total = 0.0;

    selectedOptions.forEach((mealType, optionNumber) {
      final meal = currentMealPlan.value?.meals
          .firstWhereOrNull((m) => m.type == mealType);

      if (meal != null) {
        final option = meal.options
            .firstWhereOrNull((o) => o.optionNumber == optionNumber);

        if (option != null) {
          total += option.estimatedCalories;
        }
      }
    });

    return total;
  }

  /// Check if all meals have selections
  bool get hasCompleteSelections {
    if (currentMealPlan.value == null) return false;

    final requiredMealTypes =
        currentMealPlan.value!.meals.map((m) => m.type).toSet();
    final selectedMealTypes = selectedOptions.keys.toSet();

    return requiredMealTypes.every((type) => selectedMealTypes.contains(type));
  }
}
