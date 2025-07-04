import 'package:get/get.dart';
import '../controllers/meal_plan_controller.dart';
import '../services/meal_plan_service.dart';

class MealPlanBinding extends Bindings {
  @override
  void dependencies() {
    // Register the service first
    Get.lazyPut<MealPlanService>(() => MealPlanService());
    // Then register the controller that depends on the service
    Get.lazyPut<MealPlanController>(() => MealPlanController());
  }
}
