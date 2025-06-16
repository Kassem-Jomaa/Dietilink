import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class SplashController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    print('\n🚀 Initializing app...');
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('Checking auth status...');
      await _authController.checkAuthStatus();

      if (_authController.isAuthenticated.value) {
        print('User is authenticated, navigating to dashboard');
        Get.offAllNamed('/dashboard');
      } else {
        print('User is not authenticated, navigating to login');
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print('❌ Error initializing app: $e');
      Get.offAllNamed('/login');
    } finally {
      isLoading.value = false;
    }
  }
}
