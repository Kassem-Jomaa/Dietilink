import 'appointment_type_api.dart';
import '../../../core/utils/timezone_utils.dart';

/// Appointment Status Enum
enum AppointmentStatus {
  scheduled,
  confirmed,
  completed,
  cancelled,
  noShow,
}

/// Appointment Model - Updated for API
class Appointment {
  final int id;
  final DateTime appointmentDate;
  final String? reason;
  final String? notes;
  final AppointmentStatus status;
  final int appointmentTypeId;
  final int dietitianId;
  final String? dietitianName;
  final String? dietitianSpecialty;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool canBeCanceled;
  final bool canBeRescheduled;

  Appointment({
    required this.id,
    required this.appointmentDate,
    this.reason,
    this.notes,
    required this.status,
    required this.appointmentTypeId,
    required this.dietitianId,
    this.dietitianName,
    this.dietitianSpecialty,
    this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.canBeCanceled,
    required this.canBeRescheduled,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      appointmentDate: DateTime.parse(json['date'] ??
          json[
              'appointment_date']), // API returns 'date' not 'appointment_date'
      reason: json['notes'], // API uses 'notes' field for reason
      notes: json['notes'],
      status: _parseStatus(json['status']),
      appointmentTypeId:
          json['appointment_type']?['id'] ?? json['appointment_type_id'] ?? 0,
      dietitianId: json['dietitian']?['id'] ?? json['dietitian_id'] ?? 0,
      dietitianName: json['dietitian']
          ?['name'], // API returns nested dietitian object
      dietitianSpecialty:
          json['dietitian']?['specialty'] ?? json['dietitian_specialty'],
      location: json['dietitian']?['clinic_name'] ?? json['location'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at'] ??
          json['created_at']), // API doesn't always provide updated_at
      canBeCanceled: json['can_be_canceled'] ?? false,
      canBeRescheduled: json['can_be_rescheduled'] ?? false,
    );
  }

  static AppointmentStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'scheduled':
        return AppointmentStatus.scheduled;
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'no_show':
        return AppointmentStatus.noShow;
      default:
        return AppointmentStatus.scheduled;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': appointmentDate
          .toIso8601String()
          .split('T')[0], // API expects 'date' field
      'appointment_date':
          appointmentDate.toIso8601String(), // Keep for backward compatibility
      'reason': reason,
      'notes': notes,
      'status': status.toString().split('.').last,
      'appointment_type_id': appointmentTypeId,
      'dietitian_id': dietitianId,
      'dietitian_name': dietitianName,
      'dietitian_specialty': dietitianSpecialty,
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'can_be_canceled': canBeCanceled,
      'can_be_rescheduled': canBeRescheduled,
    };
  }

  String get formattedDate {
    return TimezoneUtils.formatDateForDisplay(appointmentDate);
  }

  String get formattedTime {
    return TimezoneUtils.formatTimeForDisplay(appointmentDate);
  }

  String get formattedDateTime {
    return TimezoneUtils.formatDateTimeForDisplay(appointmentDate);
  }

  bool get isToday {
    return TimezoneUtils.isToday(appointmentDate);
  }

  bool get isPast {
    return appointmentDate.isBefore(DateTime.now());
  }

  bool get isUpcoming {
    return appointmentDate.isAfter(DateTime.now());
  }

  String get statusText {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No Show';
    }
  }

  /// Get appointment type name based on appointmentTypeId
  /// This should be replaced with actual type mapping from API
  String get typeText {
    // This will be overridden by the controller with actual API data
    switch (appointmentTypeId) {
      case 1:
        return 'Initial Consultation';
      case 2:
        return 'Follow-up';
      case 4:
        return 'Quick Check-in';
      default:
        return 'General';
    }
  }

  /// Get appointment type name from a list of appointment types
  String getTypeNameFromList(List<AppointmentTypeAPI> types) {
    final type = types.firstWhere(
      (t) => t.id == appointmentTypeId,
      orElse: () => AppointmentTypeAPI(
        id: appointmentTypeId,
        name: 'Unknown Type',
        durationMinutes: 30,
        formattedDuration: '30m',
        color: '#6B7280',
      ),
    );
    return type.name;
  }

  /// Get dietitian name (alias for dietitianName)
  String? get doctorName => dietitianName;

  /// Check if appointment has reminder (placeholder)
  bool get hasReminder => false;
}

/// Appointment History Response Model
class AppointmentHistory {
  final List<Appointment> appointments;
  final PaginationInfo pagination;

  AppointmentHistory({
    required this.appointments,
    required this.pagination,
  });

  factory AppointmentHistory.fromJson(Map<String, dynamic> json) {
    return AppointmentHistory(
      appointments: (json['appointments'] as List)
          .map((appointment) => Appointment.fromJson(appointment))
          .toList(),
      pagination: PaginationInfo.fromJson(json['pagination']),
    );
  }
}

/// Pagination Info Model
class PaginationInfo {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalItems: json['total_items'] ?? 0,
      perPage: json['per_page'] ?? 10,
      hasNextPage: json['has_next_page'] ?? false,
      hasPreviousPage: json['has_previous_page'] ?? false,
    );
  }
}
