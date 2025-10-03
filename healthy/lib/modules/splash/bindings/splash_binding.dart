import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../core/services/api_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() async {
    // Initialize ApiService first
    await Get.putAsync(() => ApiService().init());
    // Then initialize AuthController
    Get.put(AuthController());
    // Finally initialize SplashController
    Get.put(SplashController());
  }
}
