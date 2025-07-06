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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primary.withValues(alpha: 0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with progress indicator
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Your Appointment',
                  style: Get.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your preferred date and time',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 16),

                // Progress indicator
                Obx(() => _buildProgressIndicator()),
              ],
            ),
          ),

          // Appointment type selector (if enabled)
          if (showAppointmentTypeSelector) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: AppointmentTypeSelector(
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
            ),
            const SizedBox(height: 24),
          ],

          // Week calendar section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Select Date',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(() {
                  final days =
                      controller.selection.value.currentWeek?.days ?? [];

                  print('🔍 AvailabilityFlow: Building WeekCalendarWidget');
                  print(
                      '🔍 AvailabilityFlow: currentWeek exists: ${controller.selection.value.currentWeek != null}');
                  print('🔍 AvailabilityFlow: days.length: ${days.length}');
                  print(
                      '🔍 AvailabilityFlow: isLoadingWeek: ${controller.isLoadingWeek.value}');
                  print(
                      '🔍 AvailabilityFlow: weekError: ${controller.weekError.value}');
                  print(
                      '🔍 AvailabilityFlow: selection.value: ${controller.selection.value}');
                  print(
                      '🔍 AvailabilityFlow: selection.value.currentWeek: ${controller.selection.value.currentWeek}');

                  return WeekCalendarWidget(
                    days: days,
                    isLoading: controller.isLoadingWeek.value,
                    error: controller.weekError.value.isNotEmpty
                        ? controller.weekError.value
                        : null,
                    onDateSelected: (day) {
                      print(
                          '🔍 AvailabilityFlow: Date selected from WeekCalendarWidget: ${day.date}');
                      controller.setSelectedDate(DateTime.parse(day.date));
                    },
                    controller: controller,
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Day time slots section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  print(
                      '🔍 AvailabilityFlow: selectedDate=${controller.selectedDate.value?.toIso8601String().split('T')[0]}');
                  print(
                      '🔍 AvailabilityFlow: selectedDay=${controller.selectedDay.value?.date}');
                  print(
                      '🔍 AvailabilityFlow: isLoadingDay=${controller.isLoadingDay.value}');
                  print(
                      '🔍 AvailabilityFlow: dayError=${controller.dayError.value}');

                  if (controller.selectedDate.value == null) {
                    print(
                        '🔍 AvailabilityFlow: Showing date prompt - no date selected');
                    return _buildDatePrompt();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Select Time',
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DayTimeSlotsWidget(
                        onSlotSelected: (slot) {
                          // Slot selection is handled by the time slots widget
                        },
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Selection confirmation
          Obx(() {
            if (!controller.canProceedToBooking) {
              return const SizedBox.shrink();
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSelectionConfirmation(),
            );
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Build progress indicator
  Widget _buildProgressIndicator() {
    final steps = ['Type', 'Date', 'Time'];
    final currentStep =
        controller.selectedAppointmentType.value != null ? 1 : 0;
    final step2 = controller.selectedDate.value != null ? 2 : currentStep;
    final step3 = controller.selectedSlot.value != null ? 3 : step2;

    return Row(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = index < step3;
        final isCurrent = index == step3 - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppTheme.success : AppTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (index < steps.length - 1)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppTheme.success : AppTheme.border,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Build date selection prompt
  Widget _buildDatePrompt() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 32,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a Date',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a date from the calendar above to view available time slots',
            style: Get.textTheme.bodyMedium?.copyWith(
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.success.withValues(alpha: 0.1),
            AppTheme.success.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.success.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ready to Book!',
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Booking summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 18,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Booking Summary',
                      style: Get.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Appointment type
                Obx(() => _buildSummaryRow(
                      icon: Icons.medical_services,
                      label: 'Appointment Type',
                      value:
                          controller.selectedAppointmentType.value?.name ?? '',
                    )),
                const SizedBox(height: 8),

                // Date and time
                Obx(() => _buildSummaryRow(
                      icon: Icons.schedule,
                      label: 'Date & Time',
                      value: controller.bookingSummary,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),

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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Change Selection'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    print(
                        '🔍 AvailabilityFlow: Confirm Booking button pressed');
                    print('🔍 AvailabilityFlow: Selection data:');
                    print(
                        '  - selectedDate: ${controller.selection.value.selectedDate}');
                    print(
                        '  - selectedSlot: ${controller.selection.value.selectedSlot}');
                    print(
                        '  - hasSelection: ${controller.selection.value.hasSelection}');
                    print(
                        '  - selectedDay: ${controller.selection.value.selectedDay?.date}');

                    if (controller.selection.value.selectedDate == null) {
                      print('❌ AvailabilityFlow: No date selected');
                      Get.snackbar(
                        'Error',
                        'Please select a date first',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppTheme.error,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    if (controller.selection.value.selectedSlot == null) {
                      print('❌ AvailabilityFlow: No time slot selected');
                      Get.snackbar(
                        'Error',
                        'Please select a time slot first',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppTheme.error,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    print(
                        '✅ AvailabilityFlow: All selections valid, calling onSelectionComplete');
                    onSelectionComplete?.call(controller.selection.value);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Confirm Booking'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build summary row
  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textMuted,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMuted,
                ),
              ),
              Text(
                value,
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
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
