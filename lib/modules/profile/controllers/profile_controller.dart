import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../core/exceptions/api_exception.dart';
import '../models/profile_model.dart';
import '../../auth/models/user_model.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxMap<String, List<String>> validationErrors =
      RxMap<String, List<String>>({});

  // Temporary form data storage for cross-tab access
  final RxMap<String, dynamic> tempFormData = RxMap<String, dynamic>({});

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void _handleError(dynamic error, [String? context]) {
    if (error is ApiException) {
      print('🔄 Handling ApiException: ${error.message}');

      // Handle API errors
      switch (error.statusCode) {
        case 401:
          errorMessage.value = 'Session expired. Please log in again.';
          // Navigate to login
          Get.offAllNamed('/auth/login');
          break;
        case 422:
          // Handle validation errors
          if (error.errors != null) {
            validationErrors.value = Map<String, List<String>>.from(
                error.errors!.map((key, value) => MapEntry(
                    key, (value as List).map((e) => e.toString()).toList())));
            errorMessage.value = 'Please check the form for errors.';
          } else {
            errorMessage.value = error.message;
          }
          break;
        case 403:
          errorMessage.value =
              'Access denied. You do not have permission to perform this action.';
          break;
        case 404:
          errorMessage.value = 'The requested resource was not found.';
          break;
        case 429:
          errorMessage.value = 'Too many requests. Please try again later.';
          break;
        case 500:
        case 502:
        case 503:
          errorMessage.value = 'Server error. Please try again later.';
          break;
        default:
          errorMessage.value = error.message;
      }
    } else {
      errorMessage.value =
          'An unexpected error occurred${context != null ? ' while $context' : ''}';
      print(
          '🔄 Unexpected error${context != null ? ' while $context' : ''}: $error');
    }
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

        // Load BMI data after profile loads successfully
        await loadBmi();

        // Add BMI endpoint test for debugging
        await testBmiEndpoint();
      } catch (parseError) {
        print('❌ Parse error: $parseError');
        print('❌ Parse error type: ${parseError.runtimeType}');
        print('❌ Stack trace: ${parseError.toString()}');
        rethrow;
      }
    } catch (e) {
      print('❌ Error loading profile: $e');
      _handleError(e, 'loading profile');

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

      // Load BMI data after profile update
      await loadBmi();

      return true;
    } catch (e) {
      print('❌ Error updating profile: $e');
      _handleError(e, 'updating profile');
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
      _handleError(e, 'changing password');
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

      // Add detailed debug logging
      print('🔍 Full BMI Response: ${response['data']}');
      print('🔍 BMI Object: ${response['data']?['bmi']}');
      if (response['data']?['bmi'] != null) {
        print('🔍 BMI Keys: ${response['data']['bmi'].keys}');

        // Debug each BMI field individually
        final bmiData = response['data']['bmi'];
        print('🔍 Raw BMI field values:');
        print(
            '  current: ${bmiData['current']} (type: ${bmiData['current'].runtimeType})');
        print(
            '  initial: ${bmiData['initial']} (type: ${bmiData['initial'].runtimeType})');
        print(
            '  change: ${bmiData['change']} (type: ${bmiData['change'].runtimeType})');
        print(
            '  category: ${bmiData['category']} (type: ${bmiData['category'].runtimeType})');
        print(
            '  color: ${bmiData['color']} (type: ${bmiData['color'].runtimeType})');
        print(
            '  current_weight: ${bmiData['current_weight']} (type: ${bmiData['current_weight'].runtimeType})');

        // Test parsing each field (using direct parsing for debugging)
        print('🔍 Parsed values:');
        print(
            '  current parsed: ${double.tryParse(bmiData['current'].toString())}');
        print(
            '  initial parsed: ${double.tryParse(bmiData['initial'].toString())}');
        print(
            '  change parsed: ${double.tryParse(bmiData['change'].toString())}');
        print(
            '  category parsed: ${bmiData['category']?.toString() ?? 'null'}');
        print('  color parsed: ${bmiData['color']?.toString() ?? 'null'}');
        print(
            '  current_weight parsed: ${double.tryParse(bmiData['current_weight'].toString())}');
      }

      if (profile.value != null && response['data']?['bmi'] != null) {
        // ✅ Fix: Access nested bmi data
        final bmiData = response['data']['bmi'];
        profile.value = ProfileModel(
          user: profile.value!.user,
          patient: profile.value!.patient,
          bmi: BmiModel.fromJson(bmiData), // ✅ Pass bmi object directly
        );
        print('✅ BMI data loaded successfully');
        print(
            'BMI: ${profile.value!.bmi!.current} (${profile.value!.bmi!.category})');
        print('BMI Current Weight: ${profile.value!.bmi!.currentWeight}');
        print('BMI Color: ${profile.value!.bmi!.color}');
      } else {
        print('⚠️ No BMI data in response');
        if (response['data'] == null) {
          print('  → No data field in response');
        } else if (response['data']['bmi'] == null) {
          print('  → No bmi field in data');
          print('  → Available fields: ${response['data'].keys}');
          print(
              '  → BMI calculation requires height and current weight in profile');
        }
      }
    } catch (e) {
      print('❌ Error loading BMI data: $e');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Stack trace: $e');

      // Don't set error message for BMI failure as it's not critical
      // But log the error for debugging
      if (e is ApiException) {
        print('BMI API Error: ${e.message} (Status: ${e.statusCode})');
      }
    }
  }

  // Removed duplicate helper methods - using the ones from profile_model.dart

  // Test method to debug BMI endpoint
  Future<void> testBmiEndpoint() async {
    try {
      print('\n🧪 TESTING BMI ENDPOINT...');
      final response = await _apiService.get('/bmi');
      print('🧪 Raw BMI Response:');
      print('  Success: ${response['success']}');
      print('  Data: ${response['data']}');
      print('  Data type: ${response['data'].runtimeType}');

      if (response['data'] != null) {
        print('🧪 Data keys: ${response['data'].keys.toList()}');

        // Check if BMI data exists
        if (response['data'].containsKey('bmi')) {
          print('🧪 BMI found! Content: ${response['data']['bmi']}');
        } else {
          print(
              '🧪 No BMI key found. Available keys: ${response['data'].keys.toList()}');
        }

        // Check all fields in detail
        response['data'].forEach((key, value) {
          print('🧪 Field $key: $value (${value.runtimeType})');

          // If it's the BMI object, dive deeper
          if (key == 'bmi' && value is Map) {
            print('🧪 Checking individual BMI field types:');
            (value as Map<String, dynamic>).forEach((bmiKey, bmiValue) {
              print('    $bmiKey: "$bmiValue" (${bmiValue.runtimeType})');

              // Test parsing each numeric value
              if (bmiKey == 'current' ||
                  bmiKey == 'initial' ||
                  bmiKey == 'change' ||
                  bmiKey == 'current_weight') {
                final parsed = double.tryParse(bmiValue.toString());
                print('      → parsed as double: $parsed');
              }
            });
          }
        });
      }
    } catch (e) {
      print('🧪 BMI Test Error: $e');
    }
  }

  // Public method to refresh all profile data
  Future<void> refreshProfile() async {
    await loadProfile();
  }

  // Public method to manually load BMI data
  Future<void> refreshBmi() async {
    await loadBmi();
  }

  // Methods for managing temporary form data across tabs
  void updateTempFormData(String key, dynamic value) {
    tempFormData[key] = value;
  }

  void updateTempFormDataMap(Map<String, dynamic> data) {
    tempFormData.addAll(data);
  }

  Map<String, dynamic> getTempFormData() {
    return Map<String, dynamic>.from(tempFormData);
  }

  void clearTempFormData() {
    tempFormData.clear();
  }

  // Collect all form data for profile update
  Map<String, dynamic> collectAllFormData() {
    final currentProfile = profile.value;
    if (currentProfile == null) {
      throw Exception('Profile data not available');
    }

    // Start with required fields from current profile
    final updateData = <String, dynamic>{
      'name': currentProfile.user.name, // Required field
    };

    // Add email only if it exists
    if (currentProfile.user.email != null &&
        currentProfile.user.email!.isNotEmpty) {
      updateData['email'] = currentProfile.user.email!;
    }

    // Add patient fields from current profile (maintaining existing data)
    if (currentProfile.patient.phone != null) {
      updateData['phone'] = currentProfile.patient.phone!;
    }
    if (currentProfile.patient.gender != null) {
      updateData['gender'] = currentProfile.patient.gender!;
    }
    if (currentProfile.patient.birthDate != null) {
      // Format date as YYYY-MM-DD string
      updateData['birth_date'] =
          currentProfile.patient.birthDate!.toIso8601String().split('T')[0];
    }
    if (currentProfile.patient.occupation != null) {
      updateData['occupation'] = currentProfile.patient.occupation!;
    }
    if (currentProfile.patient.height != null) {
      updateData['height'] = currentProfile.patient.height!;
    }
    if (currentProfile.patient.initialWeight != null) {
      updateData['initial_weight'] = currentProfile.patient.initialWeight!;
    }
    if (currentProfile.patient.goalWeight != null) {
      updateData['goal_weight'] = currentProfile.patient.goalWeight!;
    }
    if (currentProfile.patient.activityLevel != null) {
      updateData['activity_level'] = currentProfile.patient.activityLevel!;
    }

    // Add medical and lifestyle fields from current profile
    if (currentProfile.patient.medicalConditions != null &&
        currentProfile.patient.medicalConditions!.isNotEmpty) {
      updateData['medical_conditions'] =
          currentProfile.patient.medicalConditions!;
    }
    if (currentProfile.patient.allergies != null &&
        currentProfile.patient.allergies!.isNotEmpty) {
      updateData['allergies'] = currentProfile.patient.allergies!;
    }
    if (currentProfile.patient.medications != null &&
        currentProfile.patient.medications!.isNotEmpty) {
      updateData['medications'] = currentProfile.patient.medications!;
    }
    if (currentProfile.patient.surgeries != null &&
        currentProfile.patient.surgeries!.isNotEmpty) {
      updateData['surgeries'] = currentProfile.patient.surgeries!;
    }
    if (currentProfile.patient.smokingStatus != null) {
      updateData['smoking_status'] = currentProfile.patient.smokingStatus!;
    }
    if (currentProfile.patient.giSymptoms != null &&
        currentProfile.patient.giSymptoms!.isNotEmpty) {
      updateData['gi_symptoms'] = currentProfile.patient.giSymptoms!;
    }
    if (currentProfile.patient.recentBloodTest != null) {
      updateData['recent_blood_test'] = currentProfile.patient.recentBloodTest!;
    }
    if (currentProfile.patient.vitaminIntake != null &&
        currentProfile.patient.vitaminIntake!.isNotEmpty) {
      updateData['vitamin_intake'] = currentProfile.patient.vitaminIntake!;
    }
    if (currentProfile.patient.previousDiets != null &&
        currentProfile.patient.previousDiets!.isNotEmpty) {
      updateData['previous_diets'] = currentProfile.patient.previousDiets!;
    }
    if (currentProfile.patient.dietaryPreferences != null &&
        currentProfile.patient.dietaryPreferences!.isNotEmpty) {
      updateData['dietary_preferences'] =
          currentProfile.patient.dietaryPreferences!;
    }
    if (currentProfile.patient.alcoholIntake != null) {
      updateData['alcohol_intake'] = currentProfile.patient.alcoholIntake!;
    }
    if (currentProfile.patient.coffeeIntake != null) {
      updateData['coffee_intake'] = currentProfile.patient.coffeeIntake!;
    }
    if (currentProfile.patient.weightHistory != null &&
        currentProfile.patient.weightHistory!.isNotEmpty) {
      updateData['weight_history'] = currentProfile.patient.weightHistory!;
    }
    if (currentProfile.patient.dailyRoutine != null) {
      updateData['daily_routine'] = currentProfile.patient.dailyRoutine!;
    }
    if (currentProfile.patient.physicalActivityDetails != null) {
      updateData['physical_activity_details'] =
          currentProfile.patient.physicalActivityDetails!;
    }
    if (currentProfile.patient.subscriptionReason != null) {
      updateData['subscription_reason'] =
          currentProfile.patient.subscriptionReason!;
    }
    if (currentProfile.patient.notes != null) {
      updateData['notes'] = currentProfile.patient.notes!;
    }

    // Override with any form data that has been modified
    final formData = getTempFormData();
    formData.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        updateData[key] = value;
      }
    });

    print('\n📝 Collected form data for update:');
    updateData.forEach((key, value) {
      print('  $key: $value');
    });

    return updateData;
  }
}
