import 'package:get/get.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
import '../services/theme_service.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // Register services
    Get.lazyPut<SettingsService>(
      () => SettingsService(),
      fenix: true,
    );

    Get.lazyPut<NotificationService>(
      () => NotificationService(),
      fenix: true,
    );

    Get.lazyPut<ThemeService>(
      () => ThemeService(),
      fenix: true,
    );

    // Register controller
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
      fenix: true,
    );
  }
}
