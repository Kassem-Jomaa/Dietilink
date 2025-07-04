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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        if (showHeader) _buildHeader(),

        const SizedBox(height: 16),

        // Time slots content
        Obx(() {
          print(
              '🔍 DayTimeSlotsWidget.build: Rebuilding with selectedDay=${controller.selectedDay.value?.date}');
          print(
              '🔍 DayTimeSlotsWidget.build: isLoadingDay=${controller.isLoadingDay.value}');
          print(
              '🔍 DayTimeSlotsWidget.build: dayError=${controller.dayError.value}');

          if (controller.isLoadingDay.value) {
            return _buildLoadingState();
          }

          if (controller.dayError.value.isNotEmpty) {
            return _buildErrorState();
          }

          final day = controller.selectedDay.value;
          if (day == null) {
            return _buildEmptyState();
          }

          return _buildTimeSlots(day);
        }),
      ],
    );
  }

  /// Build header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Time Slots',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Obx(() {
              final day = controller.selectedDay.value;
              if (day == null) return const SizedBox.shrink();

              return Text(
                '${day.formattedDate} • ${day.dayName}',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMuted,
                ),
              );
            }),
          ],
        ),

        // Slot count badge
        Obx(() {
          final day = controller.selectedDay.value;
          if (day == null) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${day.slots.length} slots',
              style: Get.textTheme.bodySmall?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }),
      ],
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading time slots...',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.dayError.value,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppTheme.error,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final date = controller.selectedDate.value;
              if (date != null) {
                controller
                    .loadDayAvailability(date.toIso8601String().split('T')[0]);
              }
            },
            child: const Text('Retry'),
          ),
        ],
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

    final periodWidgets = <Widget>[];
    for (final period in TimePeriod.periods) {
      final periodSlots = day.slotsByPeriod[period.name] ?? [];
      print('🔍 Period ${period.name}: ${periodSlots.length} slots');

      if (periodSlots.isNotEmpty) {
        periodWidgets.add(_buildPeriodSection(period, periodSlots));
      }
    }

    if (periodWidgets.isEmpty) {
      print('⚠️ No period widgets created, showing empty state');
      return _buildEmptyState();
    }

    print('✅ Created ${periodWidgets.length} period sections');
    return Column(children: periodWidgets);
  }

  /// Build period section
  Widget _buildPeriodSection(TimePeriod period, List<AppointmentSlot> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Period header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                period.icon,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                period.name,
                style: Get.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: period.color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 1,
                  color: period.color.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${slots.length} slots',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),

        // Time slots grid
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: slots.length,
            itemBuilder: (context, index) {
              return _buildTimeSlotCard(slots[index], period);
            },
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  /// Build time slot card
  Widget _buildTimeSlotCard(AppointmentSlot slot, TimePeriod period) {
    final isSelected =
        controller.selectedSlot.value?.startTime == slot.startTime;

    return GestureDetector(
      onTap: () => _onSlotTap(slot),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? period.color.withValues(alpha: 0.1)
              : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? period.color : AppTheme.border,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Time
            Text(
              _formatTime(slot.startTime),
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? period.color : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),

            // Duration indicator
            Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                color: isSelected ? period.color : AppTheme.textMuted,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 2),

            // End time
            Text(
              _formatTime(slot.endTime),
              style: Get.textTheme.bodySmall?.copyWith(
                color: isSelected ? period.color : AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle slot tap
  void _onSlotTap(AppointmentSlot slot) {
    controller.selectTimeSlot(slot);
    onSlotSelected?.call(slot);

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
}
