import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/availability_controller.dart';
import '../models/availability_models.dart';
import '../../../core/theme/app_theme.dart';

/// Week Calendar Widget
///
/// Displays a horizontal week view with availability indicators
/// Shows 7 day cards with date, day name, and availability status
class WeekCalendarWidget extends GetView<AvailabilityController> {
  final Function(String)? onDateSelected;
  final bool showNavigation;

  const WeekCalendarWidget({
    Key? key,
    this.onDateSelected,
    this.showNavigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('🔍 WeekCalendarWidget.build: Building calendar widget');

    return Column(
      children: [
        // Week navigation header
        if (showNavigation) _buildWeekNavigation(),

        const SizedBox(height: 16),

        // Week calendar grid
        Obx(() {
          print(
              '🔍 WeekCalendarWidget.build: Rebuilding with currentWeek=${controller.selection.value.currentWeek != null}');
          print(
              '🔍 WeekCalendarWidget.build: isLoadingWeek=${controller.isLoadingWeek.value}');
          print(
              '🔍 WeekCalendarWidget.build: weekError=${controller.weekError.value}');

          if (controller.isLoadingWeek.value) {
            print('🔍 WeekCalendarWidget.build: Showing loading state');
            return _buildLoadingState();
          }

          if (controller.weekError.value.isNotEmpty) {
            print('🔍 WeekCalendarWidget.build: Showing error state');
            return _buildErrorState();
          }

          final week = controller.selection.value.currentWeek;
          if (week == null) {
            print(
                '🔍 WeekCalendarWidget.build: Showing empty state - no week data');
            return _buildEmptyState();
          }

          print(
              '🔍 WeekCalendarWidget.build: Building week grid with ${week.days.length} days');
          return _buildWeekGrid(week);
        }),
      ],
    );
  }

  /// Build week navigation header
  Widget _buildWeekNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous week button
        IconButton(
          onPressed: controller.currentWeekOffset.value > 0
              ? controller.loadPreviousWeek
              : null,
          icon: Icon(
            Icons.chevron_left,
            color: controller.currentWeekOffset.value > 0
                ? AppTheme.primary
                : AppTheme.textMuted,
          ),
          tooltip: 'Previous Week',
        ),

        // Week summary
        Expanded(
          child: Center(
            child: Column(
              children: [
                Text(
                  _getWeekTitle(),
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.getWeekSummary(),
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Next week button
        IconButton(
          onPressed: controller.loadNextWeek,
          icon: Icon(
            Icons.chevron_right,
            color: AppTheme.primary,
          ),
          tooltip: 'Next Week',
        ),
      ],
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        },
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
              controller.weekError.value,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppTheme.error,
              ),
            ),
          ),
          TextButton(
            onPressed: controller.loadCurrentWeek,
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
            Icons.calendar_today_outlined,
            size: 48,
            color: AppTheme.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Availability Data',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please select an appointment type to view availability',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build week grid
  Widget _buildWeekGrid(WeekAvailability week) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: week.days.length,
        itemBuilder: (context, index) {
          final day = week.days[index];
          final isSelected =
              controller.selectedDate.value?.toIso8601String().split('T')[0] ==
                  day.date;

          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 8),
            child: _buildDayCard(day, isSelected),
          );
        },
      ),
    );
  }

  /// Build individual day card
  Widget _buildDayCard(DateRangeAvailability day, bool isSelected) {
    final isSelectable = controller.isDateSelectable(day.date);
    final status = controller.getAvailabilityStatus(day.date);

    print(
        '🔍 WeekCalendarWidget._buildDayCard: ${day.date} - isSelectable=$isSelectable, isSelected=$isSelected, hasAvailability=${day.hasAvailability}');

    return GestureDetector(
      onTap: isSelectable
          ? () {
              print('🖱️ Day card tapped: ${day.date}');
              _onDayTap(day.date);
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.1)
              : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : _getStatusColor(status).withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Day name
              Text(
                day.dayName.substring(0, 3),
                style: Get.textTheme.bodySmall?.copyWith(
                  color:
                      isSelectable ? AppTheme.textPrimary : AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),

              // Date number
              Text(
                day.formattedDate.split('/')[0],
                style: Get.textTheme.titleMedium?.copyWith(
                  color:
                      isSelectable ? AppTheme.textPrimary : AppTheme.textMuted,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              // Availability indicator
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getStatusColor(status),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 4),

              // Slot count
              if (day.totalSlots > 0)
                Text(
                  '${day.availableSlots}/${day.totalSlots}',
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle day tap
  void _onDayTap(String date) {
    print('🖱️ WeekCalendarWidget: Day tapped - $date');
    print(
        '🖱️ WeekCalendarWidget: Controller available: ${controller != null}');
    print(
        '🖱️ WeekCalendarWidget: Selected appointment type: ${controller.selectedAppointmentType.value?.name}');
    print('🖱️ WeekCalendarWidget: Calling loadDayAvailability...');

    try {
      controller.loadDayAvailability(date);
      print('🖱️ WeekCalendarWidget: loadDayAvailability called successfully');
    } catch (e) {
      print('❌ WeekCalendarWidget: Error calling loadDayAvailability: $e');
    }

    onDateSelected?.call(date);
  }

  /// Get week title
  String _getWeekTitle() {
    final dates = controller.getCurrentWeekDates();
    final start = dates.first;
    final end = dates.last;

    if (start.month == end.month) {
      return '${_getMonthName(start.month)} ${start.day} - ${end.day}';
    } else {
      return '${_getMonthName(start.month)} ${start.day} - ${_getMonthName(end.month)} ${end.day}';
    }
  }

  /// Get month name
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  /// Get status color
  Color _getStatusColor(AvailabilityStatus status) {
    switch (status) {
      case AvailabilityStatus.available:
        return AppTheme.success;
      case AvailabilityStatus.limited:
        return AppTheme.warning;
      case AvailabilityStatus.booked:
        return AppTheme.error;
      case AvailabilityStatus.unavailable:
        return AppTheme.textMuted;
      case AvailabilityStatus.past:
        return AppTheme.textMuted.withValues(alpha: 0.5);
    }
  }
}
