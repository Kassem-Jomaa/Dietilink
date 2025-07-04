import 'package:intl/intl.dart';

/// Timezone Utilities
///
/// Handles timezone conversions and formatting for the appointment system
class TimezoneUtils {
  /// Convert UTC DateTime to local time
  static DateTime utcToLocal(DateTime utcDateTime) {
    return utcDateTime.toLocal();
  }

  /// Convert local DateTime to UTC
  static DateTime localToUtc(DateTime localDateTime) {
    return localDateTime.toUtc();
  }

  /// Format date for API (YYYY-MM-DD)
  static String formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Format time for API (HH:MM)
  static String formatTimeForApi(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// Format date for display
  static String formatDateForDisplay(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }

  /// Format time for display
  static String formatTimeForDisplay(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  /// Format date and time for display
  static String formatDateTimeForDisplay(DateTime dateTime) {
    return DateFormat('EEEE, MMMM d, yyyy at h:mm a').format(dateTime);
  }

  /// Parse date from API string (YYYY-MM-DD)
  static DateTime parseDateFromApi(String dateString) {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }

  /// Parse time from API string (HH:MM)
  static DateTime parseTimeFromApi(String timeString) {
    final now = DateTime.now();
    final timeParts = timeString.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  /// Get current date in API format
  static String getCurrentDateForApi() {
    return formatDateForApi(DateTime.now());
  }

  /// Get current time in API format
  static String getCurrentTimeForApi() {
    return formatTimeForApi(DateTime.now());
  }

  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if a date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Get relative date string (Today, Tomorrow, or formatted date)
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else {
      return formatDateForDisplay(date);
    }
  }

  /// Get time zone offset string
  static String getTimezoneOffsetString() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;
    final hours = offset.inHours.abs();
    final minutes = (offset.inMinutes.abs() % 60);
    final sign = offset.isNegative ? '-' : '+';
    return 'UTC$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Format duration in minutes to human readable string
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours hr';
      } else {
        return '$hours hr $remainingMinutes min';
      }
    }
  }

  /// Get time slot string (e.g., "9:00 AM - 10:00 AM")
  static String getTimeSlotString(DateTime startTime, int durationMinutes) {
    final endTime = startTime.add(Duration(minutes: durationMinutes));
    return '${formatTimeForDisplay(startTime)} - ${formatTimeForDisplay(endTime)}';
  }

  /// Check if a time slot is in the past
  static bool isTimeSlotInPast(DateTime date, String timeString) {
    final now = DateTime.now();
    final slotTime = parseTimeFromApi(timeString);
    final slotDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      slotTime.hour,
      slotTime.minute,
    );
    return slotDateTime.isBefore(now);
  }

  /// Get next available time slot
  static DateTime getNextAvailableTimeSlot(
      DateTime baseTime, int intervalMinutes) {
    final now = DateTime.now();
    final roundedTime = DateTime(
      baseTime.year,
      baseTime.month,
      baseTime.day,
      baseTime.hour,
      (baseTime.minute ~/ intervalMinutes) * intervalMinutes,
    );

    if (roundedTime.isBefore(now)) {
      return now.add(
          Duration(minutes: intervalMinutes - (now.minute % intervalMinutes)));
    }

    return roundedTime;
  }

  /// Format appointment time for display with timezone
  static String formatAppointmentTime(DateTime dateTime,
      {bool includeTimezone = true}) {
    final formatted = formatDateTimeForDisplay(dateTime);
    if (includeTimezone) {
      return '$formatted (${getTimezoneOffsetString()})';
    }
    return formatted;
  }

  /// Get day of week string
  static String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// Get short day of week string
  static String getShortDayOfWeek(DateTime date) {
    return DateFormat('E').format(date);
  }

  /// Get month string
  static String getMonth(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  /// Get short month string
  static String getShortMonth(DateTime date) {
    return DateFormat('MMM').format(date);
  }
}
