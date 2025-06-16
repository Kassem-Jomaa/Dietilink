import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../models/profile_model.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxMap<String, List<String>> validationErrors =
      RxMap<String, List<String>>({});

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      validationErrors.clear();

      print('\n👤 Loading profile...');
      final response = await _apiService.get('/profile');
      print('Profile Response: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        profile.value = ProfileModel.fromJson(response.data['data']);
        print('✅ Profile loaded successfully');
      } else {
        print('❌ Failed to load profile');
        errorMessage.value =
            response.data['message'] ?? 'Failed to load profile';
      }
    } catch (e) {
      print('❌ Error loading profile: $e');
      errorMessage.value = 'An error occurred while loading profile';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      validationErrors.clear();

      print('\n📝 Updating profile...');
      print('Update data: $data');

      final response = await _apiService.put('/profile', data: data);
      print('Update Response: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        profile.value = ProfileModel.fromJson(response.data['data']);
        print('✅ Profile updated successfully');
        return true;
      } else {
        print('❌ Failed to update profile');
        if (response.data['errors'] != null) {
          validationErrors.value = Map<String, List<String>>.from(response
              .data['errors']
              .map((key, value) => MapEntry(key, List<String>.from(value))));
        }
        errorMessage.value =
            response.data['message'] ?? 'Failed to update profile';
        return false;
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
      errorMessage.value = 'An error occurred while updating profile';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      validationErrors.clear();

      print('\n🔑 Changing password...');
      final response = await _apiService.post('/change-password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      });
      print('Password Change Response: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        print('✅ Password changed successfully');
        return true;
      } else {
        print('❌ Failed to change password');
        if (response.data['errors'] != null) {
          validationErrors.value = Map<String, List<String>>.from(response
              .data['errors']
              .map((key, value) => MapEntry(key, List<String>.from(value))));
        }
        errorMessage.value =
            response.data['message'] ?? 'Failed to change password';
        return false;
      }
    } catch (e) {
      print('❌ Error changing password: $e');
      errorMessage.value = 'An error occurred while changing password';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadBmi() async {
    try {
      print('\n📊 Loading BMI data...');
      final response = await _apiService.get('/bmi');
      print('BMI Response: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        if (profile.value != null) {
          profile.value = ProfileModel(
            user: profile.value!.user,
            patient: profile.value!.patient,
            bmi: BmiModel.fromJson(response.data['data']),
          );
          print('✅ BMI data loaded successfully');
        }
      } else {
        print('❌ Failed to load BMI data');
        errorMessage.value =
            response.data['message'] ?? 'Failed to load BMI data';
      }
    } catch (e) {
      print('❌ Error loading BMI data: $e');
      errorMessage.value = 'An error occurred while loading BMI data';
    }
  }
}
