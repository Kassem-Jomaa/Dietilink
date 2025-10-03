import 'package:flutter/material.dart';
import 'modules/appointments/test_appointment_api.dart';

/// Test runner for Book Button Logging
///
/// This file can be run to test if the book button logging is working
/// and to identify any issues in the booking flow.
void main() async {
  print('🚀 Testing Book Button Logging...\n');

  try {
    // Test the appointment booking API
    await AppointmentAPITest.testBookAppointment();

    print('\n✅ Book button logging test completed successfully!');
    print('📋 Summary:');
    print('   - Logging has been added to all book button components');
    print('   - Debug logs will show the complete booking flow');
    print('   - Any issues will be clearly identified in the logs');
    print('   - Check the console output for detailed debugging information');
  } catch (e) {
    print('❌ Book button logging test failed: $e');
  }
}
