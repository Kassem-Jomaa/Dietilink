import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/availability_controller.dart';
import '../models/availability_models.dart';
import '../../../core/theme/app_theme.dart';

/// Week Calendar Widget
///
/// Displays a horizontal week view with availability indicators
/// Shows 7 day cards with date, day name, and availability status
class WeekCalendarWidget extends StatelessWidget {
  final List<DateRangeAvailability> days;
  final bool isLoading;
  final String? error;
  final void Function(DateRangeAvailability)? onDateSelected;
  final bool showNavigation;
  final AvailabilityController? controller;

  const WeekCalendarWidget({
    Key? key,
    required this.days,
    required this.isLoading,
    this.error,
    this.onDateSelected,
    this.showNavigation = true,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('🔍 WeekCalendarWidget.build: Building calendar widget');
    print('🔍 WeekCalendarWidget.build: days.length=${days.length}');
    print('🔍 WeekCalendarWidget.build: isLoading=$isLoading');
    print('🔍 WeekCalendarWidget.build: error=$error');

    // Debug: Print each day's details
    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      print(
          '🔍 Day $i: ${day.date} - hasAvailability=${day.hasAvailability}, availableSlots=${day.availableSlots}, totalSlots=${day.totalSlots}');
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
        children: [
          // Week navigation header
          if (showNavigation && controller != null) _buildWeekNavigation(),

          const SizedBox(height: 20),

          // Week calendar grid
          if (isLoading)
            _buildLoadingState()
          else if (error != null && error!.isNotEmpty)
            _buildErrorState()
          else if (days.isEmpty)
            _buildEmptyState()
          else
            _buildWeekGrid(),
        ],
      ),
    );
  }

  /// Build week navigation header
  Widget _buildWeekNavigation() {
    if (controller == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous week button
          Container(
            decoration: BoxDecoration(
              color: controller!.currentWeekOffset.value > 0
                  ? AppTheme.primary
                  : AppTheme.textMuted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: controller!.currentWeekOffset.value > 0
                  ? controller!.loadPreviousWeek
                  : null,
              icon: Icon(
                Icons.chevron_left,
                color: controller!.currentWeekOffset.value > 0
                    ? Colors.white
                    : AppTheme.textMuted,
              ),
              tooltip: 'Previous Week',
            ),
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
                    controller!.getWeekSummary(),
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Next week button
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: controller!.loadNextWeek,
              icon: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              tooltip: 'Next Week',
            ),
          ),
        ],
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppTheme.border.withValues(alpha: 0.5)),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 50,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(5),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.error,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              error!,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppTheme.error,
              ),
            ),
          ),
          if (controller != null)
            TextButton(
              onPressed: controller!.loadCurrentWeek,
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.textMuted.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 32,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Available Dates This Week',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different week or appointment type',
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
  Widget _buildWeekGrid() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected =
              controller?.selectedDate.value?.toIso8601String().split('T')[0] ==
                  day.date;

          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            child: _buildDayCard(day, isSelected),
          );
        },
      ),
    );
  }

  /// Build individual day card
  Widget _buildDayCard(DateRangeAvailability day, bool isSelected) {
    final isSelectable =
        controller?.isDateSelectable(day.date) ?? day.hasAvailability;
    final status = controller?.getAvailabilityStatus(day.date) ?? day.status;

    print(
        '🔍 WeekCalendarWidget._buildDayCard: ${day.date} - isSelectable=$isSelectable, isSelected=$isSelected, hasAvailability=${day.hasAvailability}');

    return GestureDetector(
      onTap: isSelectable
          ? () {
              print('🖱️ Day card tapped: ${day.date}');
              _onDayTap(day);
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.1)
              : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : _getStatusColor(status).withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Day name
              Text(
                day.dayName.substring(0, 3),
                style: Get.textTheme.bodySmall?.copyWith(
                  color:
                      isSelectable ? AppTheme.textPrimary : AppTheme.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${day.availableSlots}',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w600,
                      fontSize: 9,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle day tap
  void _onDayTap(DateRangeAvailability day) {
    print('🖱️ WeekCalendarWidget: Day tapped - ${day.date}');
    print(
        '🖱️ WeekCalendarWidget: Controller available: ${controller != null}');
    print(
        '🖱️ WeekCalendarWidget: Selected appointment type: ${controller?.selectedAppointmentType.value?.name}');
    print('🖱️ WeekCalendarWidget: Calling loadDayAvailability...');

    try {
      controller?.loadDayAvailability(day.date);
      print('🖱️ WeekCalendarWidget: loadDayAvailability called successfully');
    } catch (e) {
      print('❌ WeekCalendarWidget: Error calling loadDayAvailability: $e');
    }

    onDateSelected?.call(day);
  }

  /// Get week title
  String _getWeekTitle() {
    if (controller == null) return '';

    final dates = controller!.getCurrentWeekDates();
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
