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
      print('\n🚀 Initializing app...');
      await _authController.checkAuthStatus();

      print('Auth status: ${_authController.isAuthenticated.value}');

      if (_authController.isAuthenticated.value) {
        print('✅ User is authenticated, navigating to dashboard');
        Get.offAllNamed('/dashboard');
      } else {
        print('❌ User is not authenticated, navigating to login');
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print('❌ Error during app initialization: $e');
      // In case of error, navigate to login
      Get.offAllNamed('/login');
    } finally {
      isLoading.value = false;
    }
  }
}
