import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class SplashController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _authController.checkAuthStatus();

      if (_authController.isAuthenticated.value) {
        Get.offAllNamed('/dashboard');
      } else {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.offAllNamed('/login');
    } finally {
      isLoading.value = false;
    }
  }
}
