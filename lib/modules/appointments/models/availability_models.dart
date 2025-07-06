import 'package:flutter/material.dart';

/// Availability Models for API Integration

/// Appointment Slot with API structure
class AppointmentSlot {
  final String id;
  final String date;
  final String startTime;
  final String endTime;
  final String formattedTime;
  final bool isAvailable;
  final int appointmentTypeId;
  final int? dietitianId;
  final String? dietitianName;
  final String? dietitianSpecialty;
  final String? reason;

  AppointmentSlot({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.formattedTime,
    required this.isAvailable,
    required this.appointmentTypeId,
    this.dietitianId,
    this.dietitianName,
    this.dietitianSpecialty,
    this.reason,
  });

  factory AppointmentSlot.fromJson(Map<String, dynamic> json) {
    return AppointmentSlot(
      id: json['id'] ?? 'slot_${json['start_time']}_${json['end_time']}',
      date: json['date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      formattedTime: json['formatted_time'] ??
          '${json['start_time']} - ${json['end_time']}',
      isAvailable: json['is_available'] ?? true,
      appointmentTypeId: json['appointment_type_id'] ?? 0,
      dietitianId: json['dietitian_id'],
      dietitianName: json['dietitian_name'],
      dietitianSpecialty: json['dietitian_specialty'],
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'formatted_time': formattedTime,
      'is_available': isAvailable,
      'appointment_type_id': appointmentTypeId,
      'dietitian_id': dietitianId,
      'dietitian_name': dietitianName,
      'dietitian_specialty': dietitianSpecialty,
      'reason': reason,
    };
  }

  DateTime get dateTime {
    return DateTime.parse('$date $startTime');
  }

  String get formattedDate {
    final dateObj = DateTime.parse(date);
    return '${dateObj.day}/${dateObj.month}/${dateObj.year}';
  }

  bool get isToday {
    final now = DateTime.now();
    final slotDate = DateTime.parse(date);
    return slotDate.year == now.year &&
        slotDate.month == now.month &&
        slotDate.day == now.day;
  }

  bool get isPast {
    return dateTime.isBefore(DateTime.now());
  }
}

/// Date Range Availability for Calendar
class DateRangeAvailability {
  final String date;
  final int slotsCount;
  final bool hasAvailability;
  final String formattedDate;
  final String dayName;
  final int availableSlots;
  final int totalSlots;
  final AvailabilityStatus status;

  DateRangeAvailability({
    required this.date,
    required this.slotsCount,
    required this.hasAvailability,
    required this.formattedDate,
    required this.dayName,
    required this.availableSlots,
    required this.totalSlots,
    required this.status,
  });

  factory DateRangeAvailability.fromJson(Map<String, dynamic> json) {
    final isAvailable = json['is_available'] ?? false;
    final slotsCount = json['slots_count'] ?? 0;
    final hasAvailability = json['has_availability'] ?? isAvailable;

    AvailabilityStatus status;
    if (!isAvailable || slotsCount == 0) {
      status = AvailabilityStatus.unavailable;
    } else if (slotsCount > 0) {
      status = AvailabilityStatus.available;
    } else {
      status = AvailabilityStatus.limited;
    }

    return DateRangeAvailability(
      date: json['date'] ?? '',
      slotsCount: slotsCount,
      hasAvailability: hasAvailability,
      formattedDate: json['formatted_date'] ?? '',
      dayName: json['day_name'] ?? '',
      availableSlots: isAvailable ? slotsCount : 0,
      totalSlots: slotsCount,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'slots_count': slotsCount,
      'has_availability': hasAvailability,
      'formatted_date': formattedDate,
      'day_name': dayName,
      'available_slots': availableSlots,
      'total_slots': totalSlots,
      'status': status.toString().split('.').last,
    };
  }
}

/// Slot Availability Check Response
class SlotAvailability {
  final bool isAvailable;
  final String? message;
  final String? suggestedTime;
  final String? reason;
  final String? suggestedAlternative;

  SlotAvailability({
    required this.isAvailable,
    this.message,
    this.suggestedTime,
    this.reason,
    this.suggestedAlternative,
  });

  factory SlotAvailability.fromJson(Map<String, dynamic> json) {
    return SlotAvailability(
      isAvailable: json['is_available'] ?? false,
      message: json['message'],
      suggestedTime: json['suggested_time'],
      reason: json['reason'],
      suggestedAlternative: json['suggested_alternative'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_available': isAvailable,
      'message': message,
      'suggested_time': suggestedTime,
      'reason': reason,
      'suggested_alternative': suggestedAlternative,
    };
  }
}

/// Appointment Statistics
class AppointmentStatistics {
  final int totalAppointments;
  final int upcomingAppointments;
  final int completedAppointments;
  final int cancelledAppointments;
  final double averageRating;
  final Map<String, int> appointmentsByType;

  AppointmentStatistics({
    required this.totalAppointments,
    required this.upcomingAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.averageRating,
    required this.appointmentsByType,
  });

  factory AppointmentStatistics.fromJson(Map<String, dynamic> json) {
    return AppointmentStatistics(
      totalAppointments: json['total_appointments'] ?? 0,
      upcomingAppointments: json['upcoming_appointments'] ?? 0,
      completedAppointments: json['completed_appointments'] ?? 0,
      cancelledAppointments: json['cancelled_appointments'] ?? 0,
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      appointmentsByType:
          Map<String, int>.from(json['appointments_by_type'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_appointments': totalAppointments,
      'upcoming_appointments': upcomingAppointments,
      'completed_appointments': completedAppointments,
      'cancelled_appointments': cancelledAppointments,
      'average_rating': averageRating,
      'appointments_by_type': appointmentsByType,
    };
  }
}

/// Availability Status Enum
enum AvailabilityStatus {
  available, // Many slots available (green)
  limited, // Few slots available (yellow)
  booked, // No slots available (red)
  unavailable, // No slots configured (gray)
  past, // Date is in the past (disabled)
}

/// Day Availability Model
class DayAvailability {
  final String date;
  final String formattedDate;
  final String dayName;
  final List<AppointmentSlot> slots;
  final int totalSlots;
  final Map<String, List<AppointmentSlot>> slotsByPeriod;

  DayAvailability({
    required this.date,
    required this.formattedDate,
    required this.dayName,
    required this.slots,
    required this.totalSlots,
    required this.slotsByPeriod,
  });

  factory DayAvailability.fromJson(Map<String, dynamic> json) {
    print(
        '🔍 DayAvailability.fromJson: Processing JSON: ${json.keys.toList()}');

    // Handle both direct response and nested data structure
    Map<String, dynamic> data;
    if (json['data'] != null) {
      data = json['data'] as Map<String, dynamic>;
      print('🔍 Using nested data structure');
    } else {
      data = json;
      print('🔍 Using direct response structure');
    }

    // Try different possible field names for slots
    List<dynamic> slotsData = [];
    if (data['available_slots'] != null) {
      slotsData = data['available_slots'] as List;
      print('🔍 Found slots in available_slots: ${slotsData.length}');
    } else if (data['slots'] != null) {
      slotsData = data['slots'] as List;
      print('🔍 Found slots in slots: ${slotsData.length}');
    } else if (json['available_slots'] != null) {
      slotsData = json['available_slots'] as List;
      print('🔍 Found slots in root available_slots: ${slotsData.length}');
    }

    print('🔍 DayAvailability.fromJson: Processing ${slotsData.length} slots');

    final slots = <AppointmentSlot>[];

    // Extract date and appointment type ID from the correct location
    final date = data['date'] ?? json['date'] ?? '';
    final appointmentTypeId =
        data['appointment_type']?['id'] ?? json['appointment_type']?['id'] ?? 0;

    print('🔍 Extracted date: $date, appointmentTypeId: $appointmentTypeId');

    for (final slotData in slotsData) {
      try {
        print('🔍 Processing slot data: $slotData');

        // Add date and appointment_type_id to slot data
        final enhancedSlotData = Map<String, dynamic>.from(slotData);
        enhancedSlotData['date'] = date;
        enhancedSlotData['appointment_type_id'] = appointmentTypeId;

        final slot = AppointmentSlot.fromJson(enhancedSlotData);
        slots.add(slot);
        print(
            '🔍 Added slot: ${slot.formattedTime} (${slot.startTime}-${slot.endTime}) with date=$date, appointmentTypeId=$appointmentTypeId');
      } catch (e) {
        print('❌ Failed to parse slot: $slotData - Error: $e');
      }
    }

    // Group slots by time period
    final slotsByPeriod = <String, List<AppointmentSlot>>{};
    for (final slot in slots) {
      final hour = int.tryParse(slot.startTime.split(':')[0]) ?? 0;
      String period;

      if (hour < 12) {
        period = 'Morning';
      } else if (hour < 17) {
        period = 'Afternoon';
      } else {
        period = 'Evening';
      }

      slotsByPeriod.putIfAbsent(period, () => []).add(slot);
    }

    print(
        '🔍 Grouped slots by period: ${slotsByPeriod.map((k, v) => MapEntry(k, v.length))}');

    return DayAvailability(
      date: date,
      formattedDate: data['formatted_date'] ?? json['formatted_date'] ?? '',
      dayName: data['day_name'] ?? json['day_name'] ?? '',
      slots: slots,
      totalSlots: data['total_slots'] ?? json['total_slots'] ?? slots.length,
      slotsByPeriod: slotsByPeriod,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'formatted_date': formattedDate,
      'day_name': dayName,
      'available_slots': slots.map((slot) => slot.toJson()).toList(),
      'total_slots': totalSlots,
    };
  }
}

/// Week Availability Model
class WeekAvailability {
  final DateTime weekStart;
  final DateTime weekEnd;
  final List<DateRangeAvailability> days;
  final int totalAvailableSlots;
  final int totalSlots;

  WeekAvailability({
    required this.weekStart,
    required this.weekEnd,
    required this.days,
    required this.totalAvailableSlots,
    required this.totalSlots,
  });

  factory WeekAvailability.fromJson(Map<String, dynamic> json) {
    final availabilityData = json['availability'] as List? ?? [];
    final days = availabilityData
        .map((day) => DateRangeAvailability.fromJson(day))
        .toList();

    int totalAvailable = 0;
    int total = 0;
    for (final day in days) {
      totalAvailable += day.availableSlots;
      total += day.totalSlots;
    }

    return WeekAvailability(
      weekStart: DateTime.parse(
          json['week_start'] ?? DateTime.now().toIso8601String()),
      weekEnd:
          DateTime.parse(json['week_end'] ?? DateTime.now().toIso8601String()),
      days: days,
      totalAvailableSlots: totalAvailable,
      totalSlots: total,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week_start': weekStart.toIso8601String(),
      'week_end': weekEnd.toIso8601String(),
      'availability': days.map((day) => day.toJson()).toList(),
      'total_available_slots': totalAvailableSlots,
      'total_slots': totalSlots,
    };
  }
}

/// Availability Selection State
class AvailabilitySelection {
  final DateTime? selectedDate;
  final AppointmentSlot? selectedSlot;
  final WeekAvailability? currentWeek;
  final DayAvailability? selectedDay;
  final bool isLoading;
  final String? error;

  AvailabilitySelection({
    this.selectedDate,
    this.selectedSlot,
    this.currentWeek,
    this.selectedDay,
    this.isLoading = false,
    this.error,
  });

  AvailabilitySelection copyWith({
    DateTime? selectedDate,
    AppointmentSlot? selectedSlot,
    WeekAvailability? currentWeek,
    DayAvailability? selectedDay,
    bool? isLoading,
    String? error,
  }) {
    return AvailabilitySelection(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      currentWeek: currentWeek ?? this.currentWeek,
      selectedDay: selectedDay ?? this.selectedDay,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get hasSelection => selectedDate != null && selectedSlot != null;
  bool get hasDate => selectedDate != null;
  bool get hasSlot => selectedSlot != null;
}

/// Time Period Model
class TimePeriod {
  final String name;
  final String icon;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Color color;

  const TimePeriod({
    required this.name,
    required this.icon,
    required this.startTime,
    required this.endTime,
    required this.color,
  });

  static const List<TimePeriod> periods = [
    TimePeriod(
      name: 'Morning',
      icon: '🌅',
      startTime: TimeOfDay(hour: 6, minute: 0),
      endTime: TimeOfDay(hour: 12, minute: 0),
      color: Colors.orange,
    ),
    TimePeriod(
      name: 'Afternoon',
      icon: '☀️',
      startTime: TimeOfDay(hour: 12, minute: 0),
      endTime: TimeOfDay(hour: 17, minute: 0),
      color: Colors.blue,
    ),
    TimePeriod(
      name: 'Evening',
      icon: '🌆',
      startTime: TimeOfDay(hour: 17, minute: 0),
      endTime: TimeOfDay(hour: 21, minute: 0),
      color: Colors.purple,
    ),
  ];

  static TimePeriod getPeriodForTime(TimeOfDay time) {
    for (final period in periods) {
      if (time.hour >= period.startTime.hour &&
          time.hour < period.endTime.hour) {
        return period;
      }
    }
    return periods.first; // Default to morning
  }
}
