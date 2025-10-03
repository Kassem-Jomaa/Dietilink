import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/availability_controller.dart';
import '../models/availability_models.dart';
import '../../../core/theme/app_theme.dart';

/// Day Time Slots Widget
///
/// Displays detailed time slots for a selected day
/// Groups slots by time periods with visual organization
class DayTimeSlotsWidget extends GetView<AvailabilityController> {
  final Function(AppointmentSlot)? onSlotSelected;
  final bool showHeader;

  const DayTimeSlotsWidget({
    Key? key,
    this.onSlotSelected,
    this.showHeader = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDay = controller.selectedDay.value;
      final isLoadingDay = controller.isLoadingDay.value;
      final dayError = controller.dayError.value;

      print(
          '🔍 DayTimeSlotsWidget.build: Rebuilding with selectedDay=${selectedDay?.date}');
      print('🔍 DayTimeSlotsWidget.build: isLoadingDay=$isLoadingDay');
      print('🔍 DayTimeSlotsWidget.build: dayError=$dayError');

      if (selectedDay == null) {
        return _buildDatePrompt();
      }

      if (isLoadingDay) {
        return _buildLoadingState();
      }

      if (dayError.isNotEmpty) {
        return _buildErrorState(dayError);
      }

      return _buildTimeSlots(selectedDay);
    });
  }

  /// Build date prompt
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
              Icons.schedule,
              size: 32,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a Date First',
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

  /// Build loading state
  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading Time Slots...',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we fetch available times',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.error,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to Load Time Slots',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppTheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: AppTheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              if (controller.selectedDate.value != null) {
                controller.loadDayAvailability(controller.selectedDate.value!
                    .toIso8601String()
                    .split('T')[0]);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  /// Build time slots
  Widget _buildTimeSlots(DayAvailability day) {
    print(
        '🔍 DayTimeSlotsWidget._buildTimeSlots: Building slots for ${day.date}');
    print('🔍 Total slots: ${day.slots.length}');
    print(
        '🔍 Slots by period: ${day.slotsByPeriod.map((k, v) => MapEntry(k, v.length))}');

    if (day.slots.isEmpty) {
      print('⚠️ No slots available, showing empty state');
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Column(
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
                  Expanded(
                    child: Text(
                      'Available Time Slots',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Calculate total available and booked slots
              Builder(
                builder: (context) {
                  final totalSlots = day.slots.length;
                  final availableSlots =
                      day.slots.where((slot) => slot.isAvailable).length;
                  final bookedSlots =
                      day.slots.where((slot) => !slot.isAvailable).length;

                  return Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      // Available slots count
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$availableSlots available',
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: AppTheme.success,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      if (bookedSlots > 0)
                        // Booked slots count
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.error.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$bookedSlots booked',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: AppTheme.error,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${day.formattedDate} • ${day.dayName}',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 20),

          // Period sections
          ...day.slotsByPeriod.entries.map((entry) {
            final period = entry.key;
            final slots = entry.value;
            print('🔍 Period $period: ${slots.length} slots');

            if (slots.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPeriodSection(period, slots),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Build period section
  Widget _buildPeriodSection(String period, List<AppointmentSlot> slots) {
    final periodInfo = _getPeriodInfo(period);

    // Calculate available and booked slots
    final availableSlots = slots.where((slot) => slot.isAvailable).length;
    final bookedSlots = slots.where((slot) => !slot.isAvailable).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Period header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: periodInfo.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                periodInfo.icon,
                color: periodInfo.color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  period,
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: periodInfo.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Available slots count
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$availableSlots',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (bookedSlots > 0) ...[
                const SizedBox(width: 4),
                // Booked slots count
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$bookedSlots',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppTheme.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Time slots grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            return Obx(() => _buildTimeSlotCard(slots[index], periodInfo));
          },
        ),
      ],
    );
  }

  /// Get period info
  _PeriodInfo _getPeriodInfo(String period) {
    switch (period.toLowerCase()) {
      case 'morning':
        return _PeriodInfo(
          name: 'Morning',
          icon: Icons.wb_sunny,
          color: AppTheme.warning,
        );
      case 'afternoon':
        return _PeriodInfo(
          name: 'Afternoon',
          icon: Icons.wb_sunny_outlined,
          color: AppTheme.primary,
        );
      case 'evening':
        return _PeriodInfo(
          name: 'Evening',
          icon: Icons.nightlight_round,
          color: AppTheme.violetBlue,
        );
      default:
        return _PeriodInfo(
          name: period,
          icon: Icons.schedule,
          color: AppTheme.textMuted,
        );
    }
  }

  /// Build time slot card
  Widget _buildTimeSlotCard(AppointmentSlot slot, _PeriodInfo periodInfo) {
    final selectedSlot = controller.selectedSlot.value;
    final isSelected = selectedSlot?.startTime == slot.startTime;
    final isAvailable = slot.isAvailable;

    // Debug logging for selection
    if (isSelected) {
      print('🎯 Slot ${slot.formattedTime} is SELECTED');
      print('🎯 Selected slot: ${selectedSlot?.formattedTime}');
      print('🎯 Slot startTime: ${slot.startTime}');
      print('🎯 Selected slot startTime: ${selectedSlot?.startTime}');
    }

    // Get current date and appointment type for availability check
    final selectedDate = controller.selectedDate.value;
    final selectedAppointmentType = controller.selectedAppointmentType.value;
    final date = selectedDate?.toIso8601String().split('T')[0] ?? '';
    final appointmentTypeId = selectedAppointmentType?.id ?? 0;

    final isKnownUnavailable = controller.isSlotKnownUnavailable(
      date,
      slot.startTime,
      appointmentTypeId,
    );

    return GestureDetector(
      onTap:
          (isAvailable && !isKnownUnavailable) ? () => _onSlotTap(slot) : null,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? periodInfo.color.withValues(alpha: 0.1)
              : (isAvailable && !isKnownUnavailable)
                  ? AppTheme.cardBackground
                  : AppTheme.textMuted.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? periodInfo.color
                : (isAvailable && !isKnownUnavailable)
                    ? AppTheme.border
                    : AppTheme.error.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Time
              Flexible(
                child: Text(
                  _formatTime(slot.startTime),
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? periodInfo.color
                        : (isAvailable && !isKnownUnavailable)
                            ? AppTheme.textPrimary
                            : AppTheme.textMuted.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),

              // Duration indicator
              Container(
                width: 14,
                height: 1,
                decoration: BoxDecoration(
                  color: isSelected
                      ? periodInfo.color
                      : (isAvailable && !isKnownUnavailable)
                          ? AppTheme.textMuted
                          : AppTheme.error.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(0.5),
                ),
              ),
              const SizedBox(height: 2),

              // End time
              Flexible(
                child: Text(
                  _formatTime(slot.endTime),
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? periodInfo.color
                        : (isAvailable && !isKnownUnavailable)
                            ? AppTheme.textMuted
                            : AppTheme.textMuted.withValues(alpha: 0.6),
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Booked indicator for unavailable slots
              if (!isAvailable || isKnownUnavailable) ...[
                const SizedBox(height: 3),
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Booked',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppTheme.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Handle slot tap
  void _onSlotTap(AppointmentSlot slot) async {
    print('🖱️ Slot tapped: ${slot.formattedTime}');
    print(
        '🖱️ Slot date: ${slot.date}, startTime: ${slot.startTime}, appointmentTypeId: ${slot.appointmentTypeId}');

    // Get the current selected date and appointment type
    final selectedDate = controller.selectedDate.value;
    final selectedAppointmentType = controller.selectedAppointmentType.value;

    if (selectedDate == null || selectedAppointmentType == null) {
      print('❌ No date or appointment type selected');
      Get.snackbar(
        'Error',
        'Please select a date and appointment type first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    final date = selectedDate.toIso8601String().split('T')[0];
    final appointmentTypeId = selectedAppointmentType.id;

    print('🖱️ Using date: $date, appointmentTypeId: $appointmentTypeId');

    // Check if slot is known to be unavailable from cache
    if (controller.isSlotKnownUnavailable(
        date, slot.startTime, appointmentTypeId)) {
      print('❌ Slot is known to be unavailable from cache');
      Get.snackbar(
        'Slot Unavailable',
        'This time slot is already booked',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.block, color: Colors.white),
      );
      return;
    }

    // Check slot availability before allowing selection
    print('🔍 Checking slot availability for ${slot.formattedTime}');
    final isAvailable = await controller.isSlotAvailable(
      date,
      slot.startTime,
      appointmentTypeId,
    );

    print('🔍 Slot availability result: $isAvailable');

    if (!isAvailable) {
      // Mark slot as unavailable in cache
      print('❌ Marking slot as unavailable in cache');
      controller.markSlotAsUnavailable(date, slot.startTime, appointmentTypeId);

      Get.snackbar(
        'Slot Unavailable',
        'This time slot is already booked',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.block, color: Colors.white),
      );
      return;
    }

    // Set the selected slot in the controller
    controller.selectTimeSlot(slot);
    onSlotSelected?.call(slot);

    print('✅ Slot selected: ${slot.formattedTime}');
    print(
        '✅ Controller selectedSlot: ${controller.selectedSlot.value?.formattedTime}');

    // Show selection feedback
    Get.snackbar(
      'Time Selected',
      '${_formatTime(slot.startTime)} - ${_formatTime(slot.endTime)}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.success.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  /// Format time for display
  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return time;
    }
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 48,
            color: AppTheme.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Time Slots Available',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There are no available time slots for this date.\nTry selecting a different date.',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Period info class
class _PeriodInfo {
  final String name;
  final IconData icon;
  final Color color;

  _PeriodInfo({
    required this.name,
    required this.icon,
    required this.color,
  });
}
