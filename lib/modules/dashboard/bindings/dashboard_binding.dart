import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../meal_plan/services/meal_plan_service.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    // Register meal plan service for dashboard
    Get.lazyPut<MealPlanService>(() => MealPlanService());
  }
}
