import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import 'services/appointments_service.dart';
import 'models/appointment_model.dart';

/// Test file for Appointment API Integration
///
/// This file contains tests to verify that the appointment API integration
/// is working correctly with the real API endpoints.
class AppointmentAPITest {
  static Future<void> testAppointmentTypes() async {
    print('🧪 Testing Appointment Types API...');

    try {
      final apiService = ApiService();
      final appointmentsService = AppointmentsService(apiService);

      final appointmentTypes = await appointmentsService.getAppointmentTypes();

      print('✅ Appointment Types Test: SUCCESS');
      print('   Found ${appointmentTypes.length} appointment types:');

      for (final type in appointmentTypes) {
        print(
            '   - ${type.name} (${type.formattedDuration}) - ${type.description ?? 'No description'}');
      }

      return;
    } catch (e) {
      print('❌ Appointment Types Test: FAILED');
      print('   Error: $e');
      rethrow;
    }
  }

  static Future<void> testDietitianInfo() async {
    print('🧪 Testing Dietitian Info API...');

    try {
      final apiService = ApiService();
      final appointmentsService = AppointmentsService(apiService);

      final dietitianInfo = await appointmentsService.getDietitianInfo();

      print('✅ Dietitian Info Test: SUCCESS');
      print('   Dietitian: ${dietitianInfo.name}');
      print('   ID: ${dietitianInfo.id}');
      print('   Specialty: ${dietitianInfo.specialty ?? 'Not specified'}');
      print('   Location: ${dietitianInfo.location ?? 'Not specified'}');

      return;
    } catch (e) {
      print('❌ Dietitian Info Test: FAILED');
      print('   Error: $e');
      rethrow;
    }
  }

  static Future<void> testAvailableSlots() async {
    print('🧪 Testing Available Slots API...');

    try {
      final apiService = ApiService();
      final appointmentsService = AppointmentsService(apiService);

      // Get appointment types first
      final appointmentTypes = await appointmentsService.getAppointmentTypes();
      if (appointmentTypes.isEmpty) {
        print(
            '❌ Available Slots Test: FAILED - No appointment types available');
        return;
      }

      // Test with first appointment type
      final firstType = appointmentTypes.first;
      final today = DateTime.now().toIso8601String().split('T')[0];

      final slots = await appointmentsService.getAvailableSlots(
        date: today,
        appointmentTypeId: firstType.id,
      );

      print('✅ Available Slots Test: SUCCESS');
      print('   Date: $today');
      print('   Appointment Type: ${firstType.name}');
      print('   Found ${slots.length} available slots:');

      for (final slot in slots.take(5)) {
        // Show first 5 slots
        print(
            '   - ${slot.formattedTime} (${slot.isAvailable ? 'Available' : 'Unavailable'})');
      }

      return;
    } catch (e) {
      print('❌ Available Slots Test: FAILED');
      print('   Error: $e');
      rethrow;
    }
  }

  static Future<void> testNextAppointment() async {
    print('🧪 Testing Next Appointment API...');

    try {
      final apiService = ApiService();
      final appointmentsService = AppointmentsService(apiService);

      final nextAppointment = await appointmentsService.getNextAppointment();

      if (nextAppointment != null) {
        print('✅ Next Appointment Test: SUCCESS');
        print('   Next Appointment: ${nextAppointment.formattedDateTime}');
        print('   Status: ${nextAppointment.statusText}');
        print('   Can be canceled: ${nextAppointment.canBeCanceled}');
        print('   Can be rescheduled: ${nextAppointment.canBeRescheduled}');
      } else {
        print('✅ Next Appointment Test: SUCCESS - No upcoming appointments');
      }

      return;
    } catch (e) {
      print('❌ Next Appointment Test: FAILED');
      print('   Error: $e');
      rethrow;
    }
  }

  static Future<void> testAppointmentStatistics() async {
    print('🧪 Testing Appointment Statistics API...');

    try {
      final apiService = ApiService();
      final appointmentsService = AppointmentsService(apiService);

      final statistics = await appointmentsService.getAppointmentStatistics();

      print('✅ Appointment Statistics Test: SUCCESS');
      print('   Total Appointments: ${statistics.totalAppointments}');
      print('   Upcoming Appointments: ${statistics.upcomingAppointments}');
      print('   Completed Appointments: ${statistics.completedAppointments}');
      print('   Cancelled Appointments: ${statistics.cancelledAppointments}');

      return;
    } catch (e) {
      print('❌ Appointment Statistics Test: FAILED');
      print('   Error: $e');
      rethrow;
    }
  }

  /// Run all API tests
  static Future<void> runAllTests() async {
    print('🚀 Starting Appointment API Integration Tests...\n');

    try {
      await testAppointmentTypes();
      print('');

      await testDietitianInfo();
      print('');

      await testAvailableSlots();
      print('');

      await testNextAppointment();
      print('');

      await testAppointmentStatistics();
      print('');

      print('🎉 All Appointment API Tests Completed Successfully!');
    } catch (e) {
      print('💥 Some tests failed: $e');
      rethrow;
    }
  }
}

/// Usage:
/// 
/// To run the tests, call:
/// await AppointmentAPITest.runAllTests();
/// 
/// Or run individual tests:
/// await AppointmentAPITest.testAppointmentTypes();
/// await AppointmentAPITest.testDietitianInfo();
/// etc. 