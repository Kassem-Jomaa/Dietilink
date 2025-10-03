import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/appointment_model.dart';
import '../../../core/theme/app_theme.dart';

/// Appointment Calendar Widget
///
/// A calendar widget that displays appointments and allows date selection
class AppointmentCalendar extends StatefulWidget {
  final List<Appointment> appointments;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? startDate;
  final DateTime? endDate;

  const AppointmentCalendar({
    Key? key,
    required this.appointments,
    required this.selectedDate,
    required this.onDateSelected,
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  State<AppointmentCalendar> createState() => _AppointmentCalendarState();
}

class _AppointmentCalendarState extends State<AppointmentCalendar> {
  late DateTime _focusedDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _focusedDate = widget.selectedDate;
    _selectedDate = widget.selectedDate;
  }

  @override
  void didUpdateWidget(AppointmentCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _selectedDate = widget.selectedDate;
      _focusedDate = widget.selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Calendar header
          _buildCalendarHeader(),

          // Calendar grid
          _buildCalendarGrid(),

          // Legend
          _buildLegend(),
        ],
      ),
    );
  }

  /// Build calendar header with month/year and navigation
  Widget _buildCalendarHeader() {
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
          // Previous month button
          IconButton(
            onPressed: _previousMonth,
            icon: const Icon(Icons.chevron_left),
            color: AppTheme.primary,
          ),

          // Month and year
          Expanded(
            child: Text(
              _getMonthYearText(),
              textAlign: TextAlign.center,
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textMain,
              ),
            ),
          ),

          // Next month button
          IconButton(
            onPressed: _nextMonth,
            icon: const Icon(Icons.chevron_right),
            color: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  /// Build calendar grid
  Widget _buildCalendarGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Day headers
          _buildDayHeaders(),
          const SizedBox(height: 8),

          // Calendar days
          _buildCalendarDays(),
        ],
      ),
    );
  }

  /// Build day headers (Mon, Tue, etc.)
  Widget _buildDayHeaders() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      children: days.map((day) {
        return Expanded(
          child: Container(
            height: 32,
            alignment: Alignment.center,
            child: Text(
              day,
              style: Get.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textMuted,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Build calendar days grid
  Widget _buildCalendarDays() {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_focusedDate.year, _focusedDate.month + 1, 0);

    // Calculate the first day to display (Monday of the week containing the first day of month)
    final firstDayToDisplay = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday - 1),
    );

    // Calculate the last day to display (Sunday of the week containing the last day of month)
    final lastDayToDisplay = lastDayOfMonth.add(
      Duration(days: 7 - lastDayOfMonth.weekday),
    );

    final days = <Widget>[];
    DateTime currentDay = firstDayToDisplay;

    while (currentDay.isBefore(lastDayToDisplay) ||
        currentDay.isAtSameMomentAs(lastDayToDisplay)) {
      days.add(_buildDayCell(currentDay));
      currentDay = currentDay.add(const Duration(days: 1));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      childAspectRatio: 1,
      children: days,
    );
  }

  /// Build individual day cell
  Widget _buildDayCell(DateTime date) {
    final isCurrentMonth = date.month == _focusedDate.month;
    final isSelected = _isSameDay(date, _selectedDate);
    final isToday = _isSameDay(date, DateTime.now());
    final hasAppointments = _getAppointmentsForDate(date).isNotEmpty;
    final isPast =
        date.isBefore(DateTime.now().subtract(const Duration(days: 1)));

    return GestureDetector(
      onTap: () => _onDaySelected(date),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: _getDayCellColor(isSelected, isToday, isPast),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getDayCellBorderColor(isSelected, isToday),
            width: isSelected || isToday ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Day number
            Center(
              child: Text(
                date.day.toString(),
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                  color: _getDayTextColor(isCurrentMonth, isSelected, isPast),
                ),
              ),
            ),

            // Appointment indicator
            if (hasAppointments && isCurrentMonth)
              Positioned(
                bottom: 4,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build legend
  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem('Today', AppTheme.primary, true),
          _buildLegendItem('Selected', AppTheme.success, false),
          _buildLegendItem('Has Appointments', AppTheme.primary, false,
              showDot: true),
        ],
      ),
    );
  }

  /// Build legend item
  Widget _buildLegendItem(String label, Color color, bool isToday,
      {bool showDot = false}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withOpacity(isToday ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: color,
              width: isToday ? 2 : 1,
            ),
          ),
          child: showDot
              ? Center(
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Get.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }

  /// Get month and year text
  String _getMonthYearText() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[_focusedDate.month - 1]} ${_focusedDate.year}';
  }

  /// Navigate to previous month
  void _previousMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1);
    });
  }

  /// Navigate to next month
  void _nextMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
    });
  }

  /// Handle day selection
  void _onDaySelected(DateTime date) {
    if (date.month == _focusedDate.month) {
      setState(() {
        _selectedDate = date;
      });
      widget.onDateSelected(date);
    }
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get appointments for a specific date
  List<Appointment> _getAppointmentsForDate(DateTime date) {
    return widget.appointments.where((appointment) {
      return _isSameDay(appointment.appointmentDate, date);
    }).toList();
  }

  /// Get day cell background color
  Color _getDayCellColor(bool isSelected, bool isToday, bool isPast) {
    if (isSelected) return AppTheme.success.withOpacity(0.2);
    if (isToday) return AppTheme.primary.withOpacity(0.1);
    if (isPast) return AppTheme.background;
    return Colors.transparent;
  }

  /// Get day cell border color
  Color _getDayCellBorderColor(bool isSelected, bool isToday) {
    if (isSelected) return AppTheme.success;
    if (isToday) return AppTheme.primary;
    return AppTheme.border;
  }

  /// Get day text color
  Color _getDayTextColor(bool isCurrentMonth, bool isSelected, bool isPast) {
    if (isSelected) return AppTheme.success;
    if (!isCurrentMonth) return AppTheme.textMuted.withOpacity(0.3);
    if (isPast) return AppTheme.textMuted.withOpacity(0.5);
    return AppTheme.textMain;
  }
}

/// Appointment Calendar Mini Widget
///
/// A smaller version of the calendar for compact display
class AppointmentCalendarMini extends StatelessWidget {
  final List<Appointment> appointments;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const AppointmentCalendarMini({
    Key? key,
    required this.appointments,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calendar',
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Simple calendar grid
          _buildMiniCalendar(),
        ],
      ),
    );
  }

  Widget _buildMiniCalendar() {
    final today = DateTime.now();
    final currentMonth = DateTime(today.year, today.month, 1);
    final daysInMonth = DateTime(today.year, today.month + 1, 0).day;

    return Column(
      children: [
        // Month header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_left, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Text(
              _getMonthName(today.month),
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_right, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Days grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: daysInMonth,
          itemBuilder: (context, index) {
            final day = index + 1;
            final date = DateTime(today.year, today.month, day);
            final hasAppointments = _hasAppointmentsOnDate(date);
            final isSelected = _isSameDay(date, selectedDate);
            final isToday = _isSameDay(date, today);

            return GestureDetector(
              onTap: () => onDateSelected(date),
              child: Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: _getMiniDayColor(isSelected, isToday),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        day.toString(),
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: _getMiniDayTextColor(isSelected, isToday),
                          fontWeight:
                              isToday ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (hasAppointments)
                      Positioned(
                        bottom: 2,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

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

  bool _hasAppointmentsOnDate(DateTime date) {
    return appointments
        .any((appointment) => _isSameDay(appointment.appointmentDate, date));
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Color _getMiniDayColor(bool isSelected, bool isToday) {
    if (isSelected) return AppTheme.primary;
    if (isToday) return AppTheme.primary.withOpacity(0.2);
    return Colors.transparent;
  }

  Color _getMiniDayTextColor(bool isSelected, bool isToday) {
    if (isSelected) return Colors.white;
    if (isToday) return AppTheme.primary;
    return AppTheme.textMain;
  }
}
