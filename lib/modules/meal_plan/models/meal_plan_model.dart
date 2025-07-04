import '../../../core/exceptions/api_exception.dart';
import '../../../core/utils/safe_parsing.dart';

class FoodItem {
  final String name;
  final String category;
  final double? calories;
  final String portion;
  final String unit;

  FoodItem({
    required this.name,
    required this.category,
    this.calories,
    required this.portion,
    required this.unit,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 FoodItem.fromJson: Starting parse...');
      final foodItemData = json['food_item'] ?? json;
      print(
          '📋 FoodItem.fromJson: foodItemData keys: ${foodItemData.keys.toList()}');

      // Handle category parsing - can be object or string
      String categoryName = '';
      final categoryData = foodItemData['category'];
      print('📋 FoodItem.fromJson: categoryData = $categoryData');

      if (categoryData is Map<String, dynamic>) {
        categoryName = SafeParsing.parseString(categoryData['name']);
        print('📋 FoodItem.fromJson: Category from object: $categoryName');
      } else {
        categoryName = SafeParsing.parseString(categoryData);
        print('📋 FoodItem.fromJson: Category from string: $categoryName');
      }

      final result = FoodItem(
        name: SafeParsing.parseString(foodItemData['name']),
        category: categoryName,
        calories: foodItemData['calories'] != null
            ? SafeParsing.parseDouble(foodItemData['calories'])
            : null,
        // Use portion_size from the item level (not food_item level)
        portion: SafeParsing.parseString(
            json['portion_size'] ?? foodItemData['portion_size']),
        unit: SafeParsing.parseString(foodItemData['unit']),
      );

      print('✅ FoodItem.fromJson: Successfully parsed: ${result.name}');
      return result;
    } catch (e) {
      print('❌ FoodItem.fromJson error: $e');
      print('❌ JSON data: $json');
      throw ApiException('Failed to parse FoodItem: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'calories': calories,
      'portion': portion,
      'unit': unit,
    };
  }
}

class MealOption {
  final int id;
  final int order;
  final int optionNumber;
  final String title;
  final String? description;
  final String? note;
  final double estimatedCalories;
  final int itemsCount;
  final List<FoodItem> foodItems;

  MealOption({
    required this.id,
    required this.order,
    required this.optionNumber,
    required this.title,
    this.description,
    this.note,
    required this.estimatedCalories,
    required this.itemsCount,
    required this.foodItems,
  });

  factory MealOption.fromJson(Map<String, dynamic> json) {
    try {
      return MealOption(
        id: SafeParsing.parseInt(json['id']),
        order: SafeParsing.parseInt(json['order']),
        optionNumber: SafeParsing.parseInt(json['option_number']),
        title: SafeParsing.parseString(json['title']),
        description: SafeParsing.parseStringNullable(json['description']),
        note: SafeParsing.parseStringNullable(json['note']),
        estimatedCalories: SafeParsing.parseDouble(json['estimated_calories']),
        itemsCount: SafeParsing.parseInt(json['items_count']),
        foodItems: (json['items'] as List?)
                ?.map((item) => FoodItem.fromJson(item))
                .toList() ??
            [],
      );
    } catch (e) {
      throw ApiException('Failed to parse MealOption: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order,
      'option_number': optionNumber,
      'title': title,
      'description': description,
      'note': note,
      'estimated_calories': estimatedCalories,
      'items_count': itemsCount,
      'items': foodItems.map((item) => item.toJson()).toList(),
    };
  }
}

class MealType {
  final String type;
  final String title;
  final String description;
  final int optionsCount;
  final List<MealOption> options;

  MealType({
    required this.type,
    required this.title,
    required this.description,
    required this.optionsCount,
    required this.options,
  });

  factory MealType.fromJson(Map<String, dynamic> json) {
    try {
      return MealType(
        type: SafeParsing.parseString(json['type']),
        title: SafeParsing.parseString(json['title']),
        description: SafeParsing.parseString(json['description']),
        optionsCount: SafeParsing.parseInt(json['options_count']),
        options: (json['options'] as List?)
                ?.map((item) => MealOption.fromJson(item))
                .toList() ??
            [],
      );
    } catch (e) {
      throw ApiException('Failed to parse MealType: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'description': description,
      'options_count': optionsCount,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }
}

class MealPlanStatistics {
  final int totalMealTypes;
  final int totalOptions;
  final int totalFoodItems;
  final String estimatedCaloriesRange;

  MealPlanStatistics({
    required this.totalMealTypes,
    required this.totalOptions,
    required this.totalFoodItems,
    required this.estimatedCaloriesRange,
  });

  factory MealPlanStatistics.fromJson(Map<String, dynamic> json) {
    try {
      return MealPlanStatistics(
        totalMealTypes: SafeParsing.parseInt(json['total_meal_types']),
        totalOptions: SafeParsing.parseInt(json['total_options']),
        totalFoodItems: SafeParsing.parseInt(json['total_food_items']),
        estimatedCaloriesRange:
            SafeParsing.parseString(json['estimated_calories_range']),
      );
    } catch (e) {
      throw ApiException('Failed to parse MealPlanStatistics: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'total_meal_types': totalMealTypes,
      'total_options': totalOptions,
      'total_food_items': totalFoodItems,
      'estimated_calories_range': estimatedCaloriesRange,
    };
  }
}

class MealPlan {
  final int id;
  final String name;
  final String status;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final MealPlanStatistics statistics;
  final List<MealType> meals;

  MealPlan({
    required this.id,
    required this.name,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.statistics,
    required this.meals,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 MealPlan.fromJson: Starting parse...');
      final mealPlan = json['meal_plan'] ?? json;
      print('📋 MealPlan.fromJson: mealPlan data exists: ${mealPlan != null}');
      print('📋 MealPlan.fromJson: mealPlan keys: ${mealPlan.keys.toList()}');

      // Sort meals by time of day
      const mealOrder = {
        'breakfast': 1,
        'snack_1': 2,
        'lunch': 3,
        'snack_2': 4,
        'dinner': 5,
      };

      print('🔍 MealPlan.fromJson: Parsing meals...');
      final mealsList = (mealPlan['meals'] as List?)
              ?.map((meal) => MealType.fromJson(meal))
              .toList() ??
          [];
      print('📊 MealPlan.fromJson: Parsed ${mealsList.length} meals');

      // Sort meals by predefined order
      mealsList.sort((a, b) {
        final orderA = mealOrder[a.type.toLowerCase()] ?? 999;
        final orderB = mealOrder[b.type.toLowerCase()] ?? 999;
        return orderA.compareTo(orderB);
      });

      print('🔍 MealPlan.fromJson: Parsing statistics...');
      final statistics = MealPlanStatistics.fromJson(mealPlan['statistics']);
      print('📊 MealPlan.fromJson: Statistics parsed successfully');

      final result = MealPlan(
        id: SafeParsing.parseInt(mealPlan['id']),
        name: SafeParsing.parseString(mealPlan['name']),
        status: SafeParsing.parseString(mealPlan['status']),
        notes: SafeParsing.parseStringNullable(mealPlan['notes']),
        createdAt: SafeParsing.parseString(mealPlan['created_at']),
        updatedAt: SafeParsing.parseString(mealPlan['updated_at']),
        statistics: statistics,
        meals: mealsList,
      );

      print(
          '✅ MealPlan.fromJson: Successfully parsed meal plan: ${result.name}');
      return result;
    } catch (e) {
      print('❌ MealPlan.fromJson error: $e');
      print('❌ JSON data: $json');
      throw ApiException('Failed to parse MealPlan: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'statistics': statistics.toJson(),
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }

  // Helper methods
  int get totalMealTypes => statistics.totalMealTypes;

  int get totalMealOptions => statistics.totalOptions;

  double get calorieRange =>
      SafeParsing.parseDouble(statistics.estimatedCaloriesRange);

  double get totalEstimatedCalories {
    return meals.fold(0.0, (sum, meal) {
      return sum +
          meal.options.fold(0.0, (mealSum, option) {
            return mealSum + option.estimatedCalories;
          });
    });
  }
}
