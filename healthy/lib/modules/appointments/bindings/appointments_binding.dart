import 'package:get/get.dart';
import '../controllers/appointments_controller.dart';
import '../controllers/availability_controller.dart';
import '../services/appointments_service.dart';
import '../../../core/services/api_service.dart';

/// Appointments Binding
///
/// Handles dependency injection for the appointments module
class AppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    // Register API service first (if not already registered)
    if (!Get.isRegistered<ApiService>()) {
      Get.lazyPut<ApiService>(() => ApiService());
    }

    // Register appointments service
    Get.lazyPut<AppointmentsService>(
      () => AppointmentsService(Get.find<ApiService>()),
    );

    // Register main appointments controller
    Get.lazyPut<AppointmentsController>(
      () => AppointmentsController(Get.find<AppointmentsService>()),
    );

    // Don't register AvailabilityController here - it should be created when needed
    // This prevents initialization race conditions
  }
}
