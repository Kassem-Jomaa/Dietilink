import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/meal_plan_controller.dart';
import '../models/meal_plan_model.dart';

class MealPlanView extends StatelessWidget {
  const MealPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MealPlanController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Meal Plan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.textPrimary),
            onPressed: () => controller.refreshMealPlan(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.violetBlue),
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadCurrentMealPlan(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.violetBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.currentMealPlan.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 64,
                  color: AppTheme.textMuted,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No meal plan assigned',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Contact your nutritionist to get a personalized meal plan',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return _buildMealPlanContent(context, controller);
      }),
    );
  }

  Widget _buildMealPlanContent(
      BuildContext context, MealPlanController controller) {
    final mealPlan = controller.currentMealPlan.value;
    if (mealPlan == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: controller.refreshMealPlan,
      color: AppTheme.violetBlue,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Meal Plan Dashboard
            _buildMealPlanDashboard(context, mealPlan, controller),
            const SizedBox(height: 24),

            // 2. Statistics Box
            _buildStatisticsBox(context, controller),
            const SizedBox(height: 24),

            // 3. Meal Type Sections
            ...mealPlan.meals
                .map((mealType) =>
                    _buildMealTypeSection(context, mealType, controller))
                .toList(),

            // 4. Summary Card
            if (controller.hasCompleteSelections)
              _buildSummaryCard(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildMealPlanDashboard(
      BuildContext context, MealPlan mealPlan, MealPlanController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.violetBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  mealPlan.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: controller
                      .getStatusColor(mealPlan.status)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  mealPlan.status.toUpperCase(),
                  style: TextStyle(
                    color: controller.getStatusColor(mealPlan.status),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (mealPlan.notes != null && mealPlan.notes?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.note,
                    size: 16,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mealPlan.notes ?? '',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatisticsBox(
      BuildContext context, MealPlanController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.tealCyan.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Meal Types',
                  controller.totalMealTypes.toString(),
                  Icons.restaurant,
                  AppTheme.violetBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Options',
                  controller.totalMealOptions.toString(),
                  Icons.list_alt,
                  AppTheme.tealCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Calorie Range',
                  '${controller.calorieRange.value.toStringAsFixed(0)} cal',
                  Icons.trending_up,
                  AppTheme.skyBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Total Calories',
                  '${controller.totalCalories.value.toStringAsFixed(0)} cal',
                  Icons.local_fire_department,
                  AppTheme.limeGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeSection(
      BuildContext context, MealType mealType, MealPlanController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            mealType.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppTheme.textPrimary,
            ),
          ),
          subtitle: Text(
            '${mealType.options.length} options available',
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 14,
            ),
          ),
          leading: Icon(
            _getMealTypeIcon(mealType.type),
            color: AppTheme.violetBlue,
            size: 24,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: mealType.options
                    .map((option) => _buildMealOptionCard(
                        context, option, mealType.type, controller))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealOptionCard(BuildContext context, MealOption option,
      String mealType, MealPlanController controller) {
    final isSelected =
        controller.isOptionSelected(mealType, option.optionNumber);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.violetBlue.withOpacity(0.1)
            : AppTheme.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppTheme.violetBlue : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Option ${option.optionNumber}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color:
                        isSelected ? AppTheme.violetBlue : AppTheme.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.limeGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${option.estimatedCalories.toStringAsFixed(0)} cal',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.limeGreen,
                  ),
                ),
              ),
            ],
          ),
          trailing: isSelected
              ? Icon(
                  Icons.check_circle,
                  color: AppTheme.violetBlue,
                  size: 20,
                )
              : null,
          onExpansionChanged: (expanded) {
            if (expanded) {
              controller.selectMealOption(mealType, option.optionNumber);
            }
          },
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildFoodItemsList(context, option.foodItems, controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItemsList(BuildContext context, List<FoodItem> foodItems,
      MealPlanController controller) {
    // Group food items by category
    final groupedItems = <String, List<FoodItem>>{};
    for (final item in foodItems) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    return Column(
      children: groupedItems.entries.map((entry) {
        final category = entry.key;
        final items = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: controller.getCategoryColor(category),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...items
                  .map((item) => _buildFoodItemTile(context, item))
                  .toList(),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFoodItemTile(BuildContext context, FoodItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${item.portion} ${item.unit}',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${item.calories?.toStringAsFixed(0) ?? '0'} cal',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.limeGreen,
                fontSize: 12,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, MealPlanController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.violetBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.violetBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppTheme.violetBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Daily Summary',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.violetBlue,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Selected Calories:',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${controller.totalSelectedCalories.toStringAsFixed(0)} cal',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.limeGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Meals Selected:',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${controller.selectedOptions.length}/${controller.totalMealTypes.value}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.violetBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getMealTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny;
      case 'lunch':
        return Icons.restaurant;
      case 'dinner':
        return Icons.nights_stay;
      case 'snack':
        return Icons.coffee;
      default:
        return Icons.restaurant_menu;
    }
  }
}
