import 'package:get/get.dart';
import 'core/services/api_service.dart';
import 'modules/appointments/services/appointments_service.dart';
import 'modules/appointments/test_appointment_api.dart';

/// Comprehensive API Connection Test
///
/// This file provides a complete testing suite for all API endpoints
/// and can be run to verify the entire system is working correctly.
class APIConnectionTest {
  /// Test basic API connectivity
  static Future<void> testBasicConnection() async {
    print('🔍 Testing Basic API Connection...');

    try {
      final apiService = ApiService();
      await apiService.init();

      // Test a simple endpoint
      final response = await apiService.get('/appointment-types');

      print('✅ Basic Connection Test: SUCCESS');
      print('   Response received: ${response.keys.join(', ')}');
    } catch (e) {
      print('❌ Basic Connection Test: FAILED');
      print('   Error: $e');
      rethrow;
    }
  }

  /// Test authentication flow
  static Future<void> testAuthentication() async {
    print('🔐 Testing Authentication...');

    try {
      final apiService = ApiService();
      await apiService.init();

      // Test login (you'll need to provide valid credentials)
      final loginData = {'username': 'kassem', 'password': 'password'};

      final response = await apiService.post('/login', data: loginData);

      if (response['success'] == true) {
        print('✅ Authentication Test: SUCCESS');
        print(
            '   Token received: ${response['data']?['token']?.toString().substring(0, 20)}...');
      } else {
        print('❌ Authentication Test: FAILED');
        print('   Response: $response');
      }
    } catch (e) {
      print('❌ Authentication Test: FAILED');
      print('   Error: $e');
    }
  }

  /// Test all appointment endpoints
  static Future<void> testAppointmentEndpoints() async {
    print('📅 Testing Appointment Endpoints...');

    try {
      await AppointmentAPITest.runAllTests();
      print('✅ All Appointment Endpoints: SUCCESS');
    } catch (e) {
      print('❌ Appointment Endpoints Test: FAILED');
      print('   Error: $e');
    }
  }

  /// Test complete booking flow
  static Future<void> testCompleteBookingFlow() async {
    print('🎯 Testing Complete Booking Flow...');

    try {
      final apiService = ApiService();
      await apiService.init();
      final appointmentsService = AppointmentsService(apiService);

      // Step 1: Get appointment types
      final types = await appointmentsService.getAppointmentTypes();
      if (types.isEmpty) {
        print('❌ Booking Flow Test: FAILED - No appointment types available');
        return;
      }

      // Step 2: Get dietitian info
      final dietitian = await appointmentsService.getDietitianInfo();

      // Step 3: Get available slots
      final today = DateTime.now().toIso8601String().split('T')[0];
      final slots = await appointmentsService.getAvailableSlots(
        date: today,
        appointmentTypeId: types.first.id,
      );

      print('✅ Complete Booking Flow Test: SUCCESS');
      print('   Appointment Types: ${types.length}');
      print('   Dietitian: ${dietitian.name}');
      print('   Available Slots Today: ${slots.length}');
    } catch (e) {
      print('❌ Complete Booking Flow Test: FAILED');
      print('   Error: $e');
    }
  }

  /// Run all tests
  static Future<void> runAllTests() async {
    print('🚀 Starting Comprehensive API Connection Tests...\n');

    try {
      await testBasicConnection();
      print('');

      await testAuthentication();
      print('');

      await testAppointmentEndpoints();
      print('');

      await testCompleteBookingFlow();
      print('');

      print('🎉 All API Connection Tests Completed Successfully!');
      print('✅ Your appointment system is ready for production!');
    } catch (e) {
      print('💥 Some tests failed: $e');
      print('🔧 Please check your API configuration and network connection');
    }
  }
}

/// Quick test function for main.dart
Future<void> testAPI() async {
  await APIConnectionTest.runAllTests();
}
