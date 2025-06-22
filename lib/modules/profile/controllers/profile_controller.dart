import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../models/profile_model.dart';
import '../../auth/models/user_model.dart';

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
    Map<String, dynamic>? response;
    try {
      isLoading.value = true;
      errorMessage.value = '';
      validationErrors.clear();

      print('\n👤 Loading profile...');
      response = await _apiService.get('/profile');
      print('Profile Response: $response');

      try {
        print('🔍 Parsing user data...');
        final userData = response['data']['user'];
        print('User data: $userData');

        // Test UserModel parsing first
        print('🔍 Testing UserModel parsing...');
        final testUser = UserModel.fromJson(userData);
        print('✅ UserModel parsed successfully: ${testUser.name}');

        print('🔍 Parsing patient data...');
        final patientData = response['data']['patient'];
        print('Patient data: $patientData');

        // Test PatientModel parsing
        print('🔍 Testing PatientModel parsing...');
        final testPatient = PatientModel.fromJson(patientData);
        print('✅ PatientModel parsed successfully');

        profile.value = ProfileModel.fromJson(response['data']);
        print('✅ Profile loaded successfully');
        print('User Name: ${profile.value?.user.name}');
        print('User Email: ${profile.value?.user.email}');
        print('Patient Phone: ${profile.value?.patient.phone}');
        print('Patient Gender: ${profile.value?.patient.gender}');
      } catch (parseError) {
        print('❌ Parse error: $parseError');
        print('❌ Parse error type: ${parseError.runtimeType}');
        print('❌ Stack trace: ${parseError.toString()}');
        rethrow;
      }
    } catch (e) {
      print('❌ Error loading profile: $e');
      errorMessage.value = 'An error occurred while loading profile';

      // Create a basic profile with available data to show something
      if (response != null) {
        try {
          final userData = response['data']['user'];
          final basicProfile = ProfileModel(
            user: UserModel.fromJson(userData),
            patient: PatientModel(
              phone: response['data']['patient']['phone']?.toString(),
              gender: response['data']['patient']['gender'],
              age: response['data']['patient']['age'],
              occupation: response['data']['patient']['occupation'],
              createdAt: null,
              updatedAt: null,
            ),
            bmi: null,
          );
          profile.value = basicProfile;
          errorMessage.value = ''; // Clear error since we have basic data
          print('✅ Basic profile created successfully');
        } catch (basicError) {
          print('❌ Could not create basic profile: $basicError');
        }
      }
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
      print('Update Response: $response');

      profile.value = ProfileModel.fromJson(response['data']);
      print('✅ Profile updated successfully');
      return true;
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
      print('Password Change Response: $response');

      print('✅ Password changed successfully');
      return true;
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
      print('BMI Response: $response');

      if (profile.value != null) {
        profile.value = ProfileModel(
          user: profile.value!.user,
          patient: profile.value!.patient,
          bmi: BmiModel.fromJson(response['data']),
        );
        print('✅ BMI data loaded successfully');
      }
    } catch (e) {
      print('❌ Error loading BMI data: $e');
      errorMessage.value = 'An error occurred while loading BMI data';
    }
  }
}
