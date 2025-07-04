import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/availability_controller.dart';
import '../models/availability_models.dart';
import '../models/appointment_type_api.dart';
import 'week_calendar_widget.dart';
import 'day_time_slots_widget.dart';
import 'appointment_type_selector.dart';
import '../../../core/theme/app_theme.dart';

/// Availability Flow Widget
///
/// Main container for the comprehensive availability selection system
/// Combines week calendar, day time slots, and selection confirmation
class AvailabilityFlow extends GetView<AvailabilityController> {
  final Function(AvailabilitySelection)? onSelectionComplete;
  final bool showAppointmentTypeSelector;
  final List<AppointmentTypeAPI> appointmentTypes;

  const AvailabilityFlow({
    Key? key,
    this.onSelectionComplete,
    this.showAppointmentTypeSelector = true,
    required this.appointmentTypes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Appointment type selector (if enabled)
        if (showAppointmentTypeSelector) ...[
          AppointmentTypeSelector(
            appointmentTypes: appointmentTypes,
            selectedType: controller.selectedAppointmentType.value,
            onTypeSelected: (type) {
              controller.setAppointmentType(type);
            },
            isLoading: controller.isLoadingWeek.value,
            error: controller.weekError.value.isNotEmpty
                ? controller.weekError.value
                : null,
          ),
          const SizedBox(height: 24),
        ],

        // Week calendar
        Text(
          'Select Date',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        WeekCalendarWidget(
          onDateSelected: (date) {
            print(
                '🔍 AvailabilityFlow: Date selected from WeekCalendarWidget: $date');
            // Date selection is handled by the calendar widget
          },
        ),
        const SizedBox(height: 24),

        // Day time slots
        Obx(() {
          print(
              '🔍 AvailabilityFlow: selectedDate=${controller.selectedDate.value?.toIso8601String().split('T')[0]}');
          print(
              '🔍 AvailabilityFlow: selectedDay=${controller.selectedDay.value?.date}');
          print(
              '🔍 AvailabilityFlow: isLoadingDay=${controller.isLoadingDay.value}');
          print('🔍 AvailabilityFlow: dayError=${controller.dayError.value}');

          if (controller.selectedDate.value == null) {
            print(
                '🔍 AvailabilityFlow: Showing date prompt - no date selected');
            return _buildDatePrompt();
          }

          print('🔍 AvailabilityFlow: Showing DayTimeSlotsWidget');
          return DayTimeSlotsWidget(
            onSlotSelected: (slot) {
              // Slot selection is handled by the time slots widget
            },
          );
        }),
        const SizedBox(height: 24),

        // Selection confirmation
        Obx(() {
          if (!controller.canProceedToBooking) {
            return const SizedBox.shrink();
          }

          return _buildSelectionConfirmation();
        }),
      ],
    );
  }

  /// Build date selection prompt
  Widget _buildDatePrompt() {
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
            Icons.calendar_today_outlined,
            size: 48,
            color: AppTheme.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a Date',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a date from the calendar above to view available time slots',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build selection confirmation
  Widget _buildSelectionConfirmation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppTheme.success,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Selection Complete',
                style: Get.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Booking summary
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Summary',
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 8),

                // Appointment type
                Obx(() => Row(
                      children: [
                        Icon(
                          Icons.medical_services,
                          size: 16,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.selectedAppointmentType.value?.name ?? '',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 4),

                // Date and time
                Obx(() => Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.bookingSummary,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    controller.clearAllSelections();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Change Selection'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    onSelectionComplete?.call(controller.selection.value);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Confirm Booking'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Availability Flow View
///
/// Full-screen view for the availability selection flow
class AvailabilityFlowView extends GetView<AvailabilityController> {
  final Function(AvailabilitySelection)? onSelectionComplete;
  final List<AppointmentTypeAPI> appointmentTypes;

  const AvailabilityFlowView({
    Key? key,
    this.onSelectionComplete,
    required this.appointmentTypes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Availability'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          // Clear selection button
          Obx(() {
            if (controller.selection.value.hasSelection) {
              return IconButton(
                onPressed: () {
                  controller.clearAllSelections();
                },
                icon: const Icon(Icons.clear),
                tooltip: 'Clear Selection',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AvailabilityFlow(
          appointmentTypes: appointmentTypes,
          onSelectionComplete: onSelectionComplete,
        ),
      ),
    );
  }
}
