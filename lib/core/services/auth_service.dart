import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../exceptions/api_exception.dart';
import 'api_service.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final _storage = const FlutterSecureStorage();

  // Observable variables
  final RxBool isAuthenticated = false.obs;
  final RxString authToken = ''.obs;
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;

  @override
  Future<AuthService> init() async {
    // Check for existing token on app start
    await checkAuthStatus();
    return this;
  }

  /// Get stored Sanctum token
  Future<String?> getAuthToken() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      authToken.value = token ?? '';
      return token;
    } catch (e) {
      print('❌ AuthService.getAuthToken error: $e');
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isUserAuthenticated() async {
    try {
      final token = await getAuthToken();
      if (token == null || token.isEmpty) {
        isAuthenticated.value = false;
        return false;
      }

      // Verify token with backend
      try {
        final response = await _apiService.get('/user/profile');
        userData.value = response['user'] ?? response['data'] ?? {};
        isAuthenticated.value = true;
        return true;
      } catch (e) {
        // Token is invalid, clear it
        await logout();
        return false;
      }
    } catch (e) {
      print('❌ AuthService.isUserAuthenticated error: $e');
      isAuthenticated.value = false;
      return false;
    }
  }

  /// Check authentication status without API call
  Future<bool> checkAuthStatus() async {
    try {
      final token = await getAuthToken();
      final hasToken = token != null && token.isNotEmpty;
      isAuthenticated.value = hasToken;
      return hasToken;
    } catch (e) {
      print('❌ AuthService.checkAuthStatus error: $e');
      isAuthenticated.value = false;
      return false;
    }
  }

  /// Login user with email and password
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🔐 AuthService: Attempting login for $email');

      final data = {
        'email': email,
        'password': password,
      };

      final response = await _apiService.post('/login', data: data);

      // Store token
      final token = response['token'] ?? response['access_token'];
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
        authToken.value = token;
        isAuthenticated.value = true;

        // Store user data
        userData.value = response['user'] ?? response['data'] ?? {};

        print('✅ AuthService: Login successful');
      } else {
        throw ApiException('No token received from server');
      }

      return response;
    } on ApiException catch (e) {
      print('❌ AuthService.login API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AuthService.login unexpected error: $e');
      throw ApiException('Login failed: $e');
    }
  }

  /// Register new user
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      print('🔐 AuthService: Attempting registration');

      final response = await _apiService.post('/register', data: userData);

      // Store token if provided
      final token = response['token'] ?? response['access_token'];
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
        authToken.value = token;
        isAuthenticated.value = true;

        // Store user data
        this.userData.value = response['user'] ?? response['data'] ?? {};

        print('✅ AuthService: Registration successful');
      }

      return response;
    } on ApiException catch (e) {
      print('❌ AuthService.register API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AuthService.register unexpected error: $e');
      throw ApiException('Registration failed: $e');
    }
  }

  /// Logout user and clear tokens
  Future<void> logout() async {
    try {
      print('🔐 AuthService: Logging out user');

      // Call logout endpoint if authenticated
      if (isAuthenticated.value) {
        try {
          await _apiService.post('/logout', data: {});
        } catch (e) {
          // Continue with logout even if API call fails
          print(
              '⚠️ AuthService: Logout API call failed, continuing with local logout');
        }
      }

      // Clear stored data
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_data');

      // Reset observable variables
      authToken.value = '';
      isAuthenticated.value = false;
      userData.clear();

      print('✅ AuthService: Logout completed');
    } catch (e) {
      print('❌ AuthService.logout error: $e');
      // Force logout even if there's an error
      authToken.value = '';
      isAuthenticated.value = false;
      userData.clear();
    }
  }

  /// Refresh authentication token
  Future<bool> refreshToken() async {
    try {
      print('🔐 AuthService: Refreshing token');

      final response = await _apiService.post('/refresh', data: {});

      final token = response['token'] ?? response['access_token'];
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
        authToken.value = token;
        isAuthenticated.value = true;

        print('✅ AuthService: Token refreshed successfully');
        return true;
      } else {
        throw ApiException('No new token received');
      }
    } on ApiException catch (e) {
      print('❌ AuthService.refreshToken API error: ${e.message}');
      // If refresh fails, logout user
      await logout();
      return false;
    } catch (e) {
      print('❌ AuthService.refreshToken unexpected error: $e');
      await logout();
      return false;
    }
  }

  /// Get current user data
  Map<String, dynamic> getCurrentUser() {
    return Map<String, dynamic>.from(userData);
  }

  /// Update user data
  Future<void> updateUserData(Map<String, dynamic> newData) async {
    try {
      final response = await _apiService.put('/user/profile', data: newData);

      // Update stored user data
      userData.value = response['user'] ?? response['data'] ?? {};

      print('✅ AuthService: User data updated successfully');
    } on ApiException catch (e) {
      print('❌ AuthService.updateUserData API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AuthService.updateUserData unexpected error: $e');
      throw ApiException('Failed to update user data: $e');
    }
  }

  /// Change password
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      print('🔐 AuthService: Changing password');

      final data = {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      };

      await _apiService.put('/user/password', data: data);

      print('✅ AuthService: Password changed successfully');
    } on ApiException catch (e) {
      print('❌ AuthService.changePassword API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AuthService.changePassword unexpected error: $e');
      throw ApiException('Failed to change password: $e');
    }
  }

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    try {
      print('🔐 AuthService: Requesting password reset for $email');

      final data = {'email': email};
      await _apiService.post('/password/email', data: data);

      print('✅ AuthService: Password reset email sent');
    } on ApiException catch (e) {
      print('❌ AuthService.requestPasswordReset API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AuthService.requestPasswordReset unexpected error: $e');
      throw ApiException('Failed to request password reset: $e');
    }
  }

  /// Reset password with token
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      print('🔐 AuthService: Resetting password');

      final data = {
        'token': token,
        'email': userData['email'] ?? '',
        'password': newPassword,
        'password_confirmation': newPassword,
      };

      await _apiService.post('/password/reset', data: data);

      print('✅ AuthService: Password reset successfully');
    } on ApiException catch (e) {
      print('❌ AuthService.resetPassword API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AuthService.resetPassword unexpected error: $e');
      throw ApiException('Failed to reset password: $e');
    }
  }
}
