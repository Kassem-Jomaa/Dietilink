import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/appointments_controller.dart';
import '../widgets/appointment_reminder.dart';
import '../widgets/appointment_stats_widget.dart';
import '../models/appointment_model.dart';
import '../../../core/theme/app_theme.dart';

/// Appointments View
///
/// Main appointments screen with upcoming appointments and booking
class AppointmentsView extends GetView<AppointmentsController> {
  const AppointmentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showBookAppointmentDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadUpcomingAppointments,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appointment statistics
                AppointmentStatsCard(
                  totalAppointments: controller.appointments.length,
                  upcomingAppointments: controller.appointments
                      .where((a) =>
                          a.status == AppointmentStatus.scheduled ||
                          a.status == AppointmentStatus.confirmed)
                      .length,
                  completedAppointments: controller.appointments
                      .where((a) => a.status == AppointmentStatus.completed)
                      .length,
                  cancelledAppointments: controller.appointments
                      .where((a) => a.status == AppointmentStatus.cancelled)
                      .length,
                ),

                const SizedBox(height: 24),

                // Upcoming appointments
                AppointmentReminder(
                  upcomingAppointments: controller.appointments,
                  onViewAll: () => _navigateToHistory(),
                  onAppointmentTap: (appointment) =>
                      _showAppointmentDetails(appointment),
                ),

                const SizedBox(height: 24),

                // Quick actions
                _buildQuickActions(),

                const SizedBox(height: 24),

                // Recent appointments
                _buildRecentAppointments(),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Build quick actions section
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.add,
                title: 'Book Appointment',
                subtitle: 'Schedule a new appointment',
                onTap: () => _showBookAppointmentDialog(Get.context!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                icon: Icons.history,
                title: 'View History',
                subtitle: 'See past appointments',
                onTap: _navigateToHistory,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build action card
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: AppTheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build recent appointments section
  Widget _buildRecentAppointments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Appointments',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _navigateToHistory,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (controller.appointments.isEmpty)
          _buildEmptyState()
        else
          Column(
            children: controller.appointments
                .take(3)
                .map((appointment) => _buildAppointmentCard(appointment))
                .toList(),
          ),
      ],
    );
  }

  /// Build appointment card
  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              _getStatusColor(appointment.status).withValues(alpha: 0.1),
          child: Icon(
            Icons.event,
            color: _getStatusColor(appointment.status),
          ),
        ),
        title: Text(
          appointment.getTypeNameFromList(controller.appointmentTypes),
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appointment.formattedDateTime),
            if (appointment.reason != null)
              Text(
                appointment.reason!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(appointment.status).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            appointment.statusText,
            style: Get.textTheme.bodySmall?.copyWith(
              color: _getStatusColor(appointment.status),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        onTap: () => _showAppointmentDetails(appointment),
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: AppTheme.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Appointments Yet',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book your first appointment to get started',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showBookAppointmentDialog(Get.context!),
            child: const Text('Book Appointment'),
          ),
        ],
      ),
    );
  }

  /// Show book appointment dialog
  void _showBookAppointmentDialog(BuildContext context) {
    // Navigate to booking screen
    Get.toNamed('/appointments/book');
  }

  /// Navigate to appointment history
  void _navigateToHistory() {
    Get.snackbar(
      'Appointment History',
      'History view coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Show appointment details
  void _showAppointmentDetails(Appointment appointment) {
    Get.dialog(
      AlertDialog(
        title:
            Text(appointment.getTypeNameFromList(controller.appointmentTypes)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${appointment.formattedDate}'),
            Text('Time: ${appointment.formattedTime}'),
            Text('Status: ${appointment.statusText}'),
            if (appointment.reason != null)
              Text('Reason: ${appointment.reason}'),
            if (appointment.notes != null) Text('Notes: ${appointment.notes}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Get status color
  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return AppTheme.skyBlue;
      case AppointmentStatus.confirmed:
        return AppTheme.success;
      case AppointmentStatus.completed:
        return AppTheme.primary;
      case AppointmentStatus.cancelled:
        return AppTheme.error;
      case AppointmentStatus.noShow:
        return AppTheme.warning;
    }
  }
}
