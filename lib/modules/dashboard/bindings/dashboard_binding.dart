import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../meal_plan/services/meal_plan_service.dart';
import '../../progress/controllers/progress_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Register ProgressController first since DashboardController depends on it
    Get.lazyPut<ProgressController>(() => ProgressController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    // Register meal plan service for dashboard
    Get.lazyPut<MealPlanService>(() => MealPlanService());
  }
}
