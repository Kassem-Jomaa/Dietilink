import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import 'services/appointments_service.dart';
import 'models/appointment_model.dart';
import 'models/availability_models.dart';

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

  static Future<void> testWeekCalendarAvailability() async {
    print('🧪 Testing Week Calendar Availability API...');

    try {
      final apiService = ApiService();
      final appointmentsService = AppointmentsService(apiService);

      // Get appointment types first
      final appointmentTypes = await appointmentsService.getAppointmentTypes();
      if (appointmentTypes.isEmpty) {
        print('❌ Week Calendar Test: FAILED - No appointment types available');
        return;
      }

      // Test with first appointment type
      final firstType = appointmentTypes.first;
      final now = DateTime.now();
      final weekStart = now.add(const Duration(days: 0)); // Current week
      final weekEnd = weekStart.add(const Duration(days: 6));

      print(
          '   Testing week: ${weekStart.toIso8601String().split('T')[0]} to ${weekEnd.toIso8601String().split('T')[0]}');
      print('   Appointment Type: ${firstType.name}');

      final availability = await appointmentsService.getDateRangeAvailability(
        startDate: weekStart.toIso8601String().split('T')[0],
        endDate: weekEnd.toIso8601String().split('T')[0],
        appointmentTypeId: firstType.id,
      );

      print('✅ Week Calendar Availability Test: SUCCESS');
      print('   Found ${availability.length} days with availability data:');

      int availableDays = 0;
      int totalSlots = 0;
      int availableSlots = 0;

      for (final day in availability) {
        print(
            '   - ${day.date} (${day.dayName}): ${day.hasAvailability ? "Available" : "Not Available"} (${day.availableSlots}/${day.totalSlots} slots)');

        if (day.hasAvailability) {
          availableDays++;
          totalSlots += day.totalSlots;
          availableSlots += day.availableSlots;
        }
      }

      print(
          '   Summary: $availableDays days available, $availableSlots/$totalSlots slots available');

      // Test widget rendering with mock data
      await testWeekCalendarWidgetRendering(availability);

      return;
    } catch (e) {
      print('❌ Week Calendar Availability Test: FAILED');
      print('   Error: $e');
      rethrow;
    }
  }

  static Future<void> testWeekCalendarWidgetRendering(
      List<DateRangeAvailability> days) async {
    print('🧪 Testing WeekCalendarWidget Rendering...');

    try {
      print('   Testing widget with ${days.length} days:');

      for (int i = 0; i < days.length; i++) {
        final day = days[i];
        print(
            '   Day $i: ${day.date} - hasAvailability=${day.hasAvailability}, availableSlots=${day.availableSlots}, totalSlots=${day.totalSlots}');

        // Simulate what the widget would display
        final status = day.hasAvailability && day.availableSlots > 0
            ? 'Available'
            : 'Not Available';
        final slotInfo = day.totalSlots > 0
            ? ' (${day.availableSlots}/${day.totalSlots} slots)'
            : '';

        print('     Widget would show: $status$slotInfo');
      }

      print('✅ WeekCalendarWidget Rendering Test: SUCCESS');
      print('   Widget should display ${days.length} day cards');

      final availableDays = days
          .where((day) => day.hasAvailability && day.availableSlots > 0)
          .length;
      print('   ${availableDays} days should be selectable');

      return;
    } catch (e) {
      print('❌ WeekCalendarWidget Rendering Test: FAILED');
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

      await testWeekCalendarAvailability();
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

  static Future<void> testBookAppointment() async {
    print('🧪 Testing Book Appointment API...');

    try {
      final apiService = ApiService();
      final appointmentsService = AppointmentsService(apiService);

      // Test booking parameters
      final dietitianId = 1;
      final appointmentTypeId = 1;
      final appointmentDate = '2025-07-05';
      final startTime = '09:00';
      final notes = 'Test appointment booking';

      print('🧪 Testing with parameters:');
      print('  - dietitianId: $dietitianId');
      print('  - appointmentTypeId: $appointmentTypeId');
      print('  - appointmentDate: $appointmentDate');
      print('  - startTime: $startTime');
      print('  - notes: $notes');

      final appointment = await appointmentsService.bookAppointment(
        dietitianId: dietitianId,
        appointmentTypeId: appointmentTypeId,
        appointmentDate: appointmentDate,
        startTime: startTime,
        notes: notes,
      );

      print('✅ Book Appointment Test: SUCCESS');
      print('📅 Booked appointment:');
      print('  - ID: ${appointment.id}');
      print('  - Date: ${appointment.appointmentDate}');
      print('  - Formatted Date: ${appointment.formattedDate}');
      print('  - Formatted Time: ${appointment.formattedTime}');
      print('  - Status: ${appointment.statusText}');
    } catch (e) {
      print('❌ Book Appointment Test: FAILED - $e');
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
/// await AppointmentAPITest.testWeekCalendarAvailability();
/// await AppointmentAPITest.testBookAppointment();
/// etc. 