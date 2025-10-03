import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/appointments_controller.dart';

/// Appointment History View
///
/// Screen for viewing appointment history
class AppointmentHistoryView extends GetView<AppointmentsController> {
  const AppointmentHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment History'),
      ),
      body: const Center(
        child: Text('Appointment History View - Coming Soon!'),
      ),
    );
  }
}
