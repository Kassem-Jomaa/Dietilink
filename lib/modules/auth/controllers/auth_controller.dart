import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final _storage = const FlutterSecureStorage();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isAuthenticated = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isCheckingAuth =
      false.obs; // Prevent multiple simultaneous auth checks

  // Test credentials
  final String testUsername = 'ahmad';
  final String testPassword = 'password';

  @override
  void onInit() {
    super.onInit();
    // Auth check is handled by SplashController
  }

  Future<void> checkAuthStatus() async {
    // Prevent multiple simultaneous auth checks
    if (isCheckingAuth.value) {
      print('🔍 Auth check already in progress, skipping...');
      return;
    }

    try {
      isCheckingAuth.value = true;
      print('\n🔍 Checking auth status...');
      final token = await _storage.read(key: 'auth_token');
      print('Token exists: ${token != null}');

      if (token != null) {
        try {
          print('Fetching user profile...');
          final response = await _apiService.get('/me');
          print('Profile response: $response');

          if (response.containsKey('data') && response['data'] != null) {
            final userData = response['data']['user'];
            if (userData != null) {
              currentUser.value = UserModel.fromJson(userData);
              isAuthenticated.value = true;
              print('Auth status: true');
              print('User: ${currentUser.value?.name}');
            } else {
              print('❌ No user data in response');
              await logout(shouldNavigate: false);
            }
          } else {
            print('❌ Invalid response format - no data field');
            await logout(shouldNavigate: false);
          }
        } catch (e) {
          print('Profile fetch error: $e');
          // If we can't fetch the profile, clear the token and logout
          // Don't navigate to login during auth check - let splash controller handle it
          await logout(shouldNavigate: false);
        }
      } else {
        print('No token found');
        isAuthenticated.value = false;
      }
    } catch (e) {
      print('Auth check error: $e');
      isAuthenticated.value = false;
      // Don't navigate to login during auth check - let splash controller handle it
      await logout(shouldNavigate: false);
    } finally {
      isCheckingAuth.value = false;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('\n🔑 Login Attempt:');
      print('Username: $username');

      final response = await _apiService.post('/login', data: {
        'username': username,
        'password': password,
      });

      print('\n📦 Login Response:');
      print('Response Data: $response');

      final token = response['data']['token'];
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
        print('\n✅ Token stored successfully');

        // Fetch user profile
        print('\n👤 Fetching user profile...');
        final profileResponse = await _apiService.get('/me');
        print('Profile Response: $profileResponse');

        final userData = profileResponse['data']['user'];
        currentUser.value = UserModel.fromJson(userData);
        isAuthenticated.value = true;
        print('\n✅ User profile loaded successfully');
        print('User: ${currentUser.value?.name}');
        return true;
      } else {
        print('\n❌ No token in response');
        errorMessage.value = 'Invalid response from server';
        return false;
      }
    } on DioException catch (e) {
      print('\n❌ DioException during login:');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');
      print('Error Response: ${e.response?.data}');
      print('Error Status Code: ${e.response?.statusCode}');

      errorMessage.value =
          e.response?.data['message'] ?? 'Network error occurred';
      return false;
    } catch (e) {
      print('\n❌ Unexpected error during login:');
      print('Error: $e');
      errorMessage.value = 'An unexpected error occurred';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout({bool shouldNavigate = true}) async {
    try {
      await _apiService.post('/logout');
    } catch (e) {
      print('Logout error: $e');
    } finally {
      await _storage.delete(key: 'auth_token');
      currentUser.value = null;
      isAuthenticated.value = false;
      // Only navigate to login if explicitly requested
      if (shouldNavigate) {
        Get.offAllNamed('/login');
      }
    }
  }

  Future<bool> refreshToken() async {
    try {
      final response = await _apiService.post('/refresh');
      final token = response['token'];
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
        return true;
      }
      return false;
    } catch (e) {
      print('Refresh token error: $e');
      return false;
    }
  }
}
