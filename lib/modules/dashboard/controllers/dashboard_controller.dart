import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class DashboardController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  void logout() {
    _authController.logout();
  }
}
