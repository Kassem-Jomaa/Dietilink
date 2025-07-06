import 'package:get/get.dart';
import 'core/services/api_service.dart';
import 'modules/auth/controllers/auth_controller.dart';

/// Test file to debug login loop issues
class LoginLoopTest {
  static Future<void> testAuthFlow() async {
    print('\n🧪 Testing Authentication Flow...');

    try {
      // Initialize API service
      final apiService = ApiService();
      await apiService.init();

      // Initialize auth controller
      final authController = AuthController();

      // Test 1: Check initial auth status
      print('\n📋 Test 1: Initial Auth Status');
      await authController.checkAuthStatus();
      print('Is Authenticated: ${authController.isAuthenticated.value}');

      // Test 2: Try login with test credentials
      print('\n📋 Test 2: Login Test');
      final loginSuccess = await authController.login('ahmad', 'password');
      print('Login Success: $loginSuccess');
      print('Is Authenticated: ${authController.isAuthenticated.value}');

      // Test 3: Check auth status after login
      print('\n📋 Test 3: Auth Status After Login');
      await authController.checkAuthStatus();
      print('Is Authenticated: ${authController.isAuthenticated.value}');

      // Test 4: Test logout
      print('\n📋 Test 4: Logout Test');
      await authController.logout(shouldNavigate: false);
      print('Is Authenticated: ${authController.isAuthenticated.value}');

      print('\n✅ Authentication flow test completed');
    } catch (e) {
      print('\n❌ Authentication flow test failed: $e');
    }
  }

  static Future<void> testTokenStorage() async {
    print('\n🧪 Testing Token Storage...');

    try {
      final authController = AuthController();

      // Test token storage
      await authController.login('ahmad', 'password');

      // Check if token is stored by checking auth status
      await authController.checkAuthStatus();
      print('Auth status after login: ${authController.isAuthenticated.value}');

      // Test token retrieval
      await authController.checkAuthStatus();
      print(
          'Auth status after token check: ${authController.isAuthenticated.value}');
    } catch (e) {
      print('\n❌ Token storage test failed: $e');
    }
  }
}

/// Run this in main.dart temporarily to test the auth flow
void runLoginLoopTest() async {
  await LoginLoopTest.testAuthFlow();
  await LoginLoopTest.testTokenStorage();
}
