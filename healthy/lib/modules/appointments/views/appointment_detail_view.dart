import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/appointments_controller.dart';

/// Appointment Detail View
///
/// Screen for viewing appointment details
class AppointmentDetailView extends GetView<AppointmentsController> {
  const AppointmentDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: const Center(
        child: Text('Appointment Detail View - Coming Soon!'),
      ),
    );
  }
}
