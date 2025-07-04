import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/appointment_model.dart';
import '../../../core/theme/app_theme.dart';

/// Appointment Reminder Widget
///
/// Displays upcoming appointments and reminder notifications
class AppointmentReminder extends StatelessWidget {
  final List<Appointment> upcomingAppointments;
  final VoidCallback? onViewAll;
  final Function(Appointment)? onAppointmentTap;

  const AppointmentReminder({
    Key? key,
    required this.upcomingAppointments,
    this.onViewAll,
    this.onAppointmentTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (upcomingAppointments.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),

          // Appointments list
          _buildAppointmentsList(),
        ],
      ),
    );
  }

  /// Build header with title and view all button
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications_active,
            color: AppTheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Upcoming Appointments',
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textMain,
            ),
          ),
          const Spacer(),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: const Text('View All'),
            ),
        ],
      ),
    );
  }

  /// Build appointments list
  Widget _buildAppointmentsList() {
    return Column(
      children: upcomingAppointments.take(3).map((appointment) {
        return _buildAppointmentItem(appointment);
      }).toList(),
    );
  }

  /// Build individual appointment item
  Widget _buildAppointmentItem(Appointment appointment) {
    final isToday = appointment.isToday;
    final isTomorrow = _isTomorrow(appointment.appointmentDate);

    return InkWell(
      onTap: () => onAppointmentTap?.call(appointment),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.border.withOpacity(0.5),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Time indicator
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: _getStatusColor(appointment.status),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),

            // Appointment info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        appointment.formattedTime,
                        style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textMain,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(appointment.status)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          appointment.statusText,
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(appointment.status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appointment.typeText,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getDateText(appointment.appointmentDate),
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMuted,
                        ),
                      ),
                      if (isToday || isTomorrow) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                (isToday ? AppTheme.warning : AppTheme.skyBlue)
                                    .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isToday ? 'Today' : 'Tomorrow',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color:
                                  isToday ? AppTheme.warning : AppTheme.skyBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (appointment.reason != null &&
                      appointment.reason!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      appointment.reason!,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Reminder indicator
            if (appointment.hasReminder)
              Icon(
                Icons.notifications_active,
                color: AppTheme.warning,
                size: 20,
              ),

            // Arrow indicator
            Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available,
            size: 48,
            color: AppTheme.textMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Upcoming Appointments',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You don\'t have any scheduled appointments',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (onViewAll != null)
            ElevatedButton(
              onPressed: onViewAll,
              child: const Text('Book Appointment'),
            ),
        ],
      ),
    );
  }

  /// Check if date is tomorrow
  bool _isTomorrow(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Get date text for display
  String _getDateText(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
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

/// Appointment Reminder Card Widget
///
/// A compact reminder card for dashboard
class AppointmentReminderCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onTap;

  const AppointmentReminderCard({
    Key? key,
    required this.appointment,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isToday = appointment.isToday;
    final isTomorrow = _isTomorrow(appointment.appointmentDate);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: _getStatusColor(appointment.status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Time indicator
              Container(
                width: 3,
                height: 32,
                decoration: BoxDecoration(
                  color: _getStatusColor(appointment.status),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(width: 12),

              // Appointment info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          appointment.formattedTime,
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textMain,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isToday || isTomorrow)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: (isToday
                                      ? AppTheme.warning
                                      : AppTheme.skyBlue)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              isToday ? 'TODAY' : 'TOMORROW',
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: isToday
                                    ? AppTheme.warning
                                    : AppTheme.skyBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      appointment.typeText,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    ),
                    if (appointment.reason != null &&
                        appointment.reason!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        appointment.reason!,
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMuted,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Reminder indicator
              if (appointment.hasReminder)
                Icon(
                  Icons.notifications_active,
                  color: AppTheme.warning,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Check if date is tomorrow
  bool _isTomorrow(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
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
