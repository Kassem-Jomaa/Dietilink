/// Notification settings model
class NotificationSettings {
  final bool enabled;
  final bool mealReminders;
  final bool appointmentReminders;
  final bool progressReminders;
  final bool healthTips;
  final bool waterReminders;
  final bool exerciseReminders;
  final NotificationTime mealReminderTime;
  final NotificationTime waterReminderTime;
  final NotificationTime exerciseReminderTime;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool quietHoursEnabled;
  final NotificationTime quietHoursStart;
  final NotificationTime quietHoursEnd;

  const NotificationSettings({
    this.enabled = true,
    this.mealReminders = true,
    this.appointmentReminders = true,
    this.progressReminders = true,
    this.healthTips = true,
    this.waterReminders = true,
    this.exerciseReminders = true,
    this.mealReminderTime = const NotificationTime(hour: 8, minute: 0),
    this.waterReminderTime = const NotificationTime(hour: 9, minute: 0),
    this.exerciseReminderTime = const NotificationTime(hour: 18, minute: 0),
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.quietHoursEnabled = false,
    this.quietHoursStart = const NotificationTime(hour: 22, minute: 0),
    this.quietHoursEnd = const NotificationTime(hour: 7, minute: 0),
  });

  /// Create from JSON
  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      enabled: json['enabled'] ?? true,
      mealReminders: json['meal_reminders'] ?? true,
      appointmentReminders: json['appointment_reminders'] ?? true,
      progressReminders: json['progress_reminders'] ?? true,
      healthTips: json['health_tips'] ?? true,
      waterReminders: json['water_reminders'] ?? true,
      exerciseReminders: json['exercise_reminders'] ?? true,
      mealReminderTime:
          NotificationTime.fromJson(json['meal_reminder_time'] ?? {}),
      waterReminderTime:
          NotificationTime.fromJson(json['water_reminder_time'] ?? {}),
      exerciseReminderTime:
          NotificationTime.fromJson(json['exercise_reminder_time'] ?? {}),
      soundEnabled: json['sound_enabled'] ?? true,
      vibrationEnabled: json['vibration_enabled'] ?? true,
      quietHoursEnabled: json['quiet_hours_enabled'] ?? false,
      quietHoursStart:
          NotificationTime.fromJson(json['quiet_hours_start'] ?? {}),
      quietHoursEnd: NotificationTime.fromJson(json['quiet_hours_end'] ?? {}),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'meal_reminders': mealReminders,
      'appointment_reminders': appointmentReminders,
      'progress_reminders': progressReminders,
      'health_tips': healthTips,
      'water_reminders': waterReminders,
      'exercise_reminders': exerciseReminders,
      'meal_reminder_time': mealReminderTime.toJson(),
      'water_reminder_time': waterReminderTime.toJson(),
      'exercise_reminder_time': exerciseReminderTime.toJson(),
      'sound_enabled': soundEnabled,
      'vibration_enabled': vibrationEnabled,
      'quiet_hours_enabled': quietHoursEnabled,
      'quiet_hours_start': quietHoursStart.toJson(),
      'quiet_hours_end': quietHoursEnd.toJson(),
    };
  }

  /// Create a copy with updated values
  NotificationSettings copyWith({
    bool? enabled,
    bool? mealReminders,
    bool? appointmentReminders,
    bool? progressReminders,
    bool? healthTips,
    bool? waterReminders,
    bool? exerciseReminders,
    NotificationTime? mealReminderTime,
    NotificationTime? waterReminderTime,
    NotificationTime? exerciseReminderTime,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? quietHoursEnabled,
    NotificationTime? quietHoursStart,
    NotificationTime? quietHoursEnd,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      mealReminders: mealReminders ?? this.mealReminders,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
      progressReminders: progressReminders ?? this.progressReminders,
      healthTips: healthTips ?? this.healthTips,
      waterReminders: waterReminders ?? this.waterReminders,
      exerciseReminders: exerciseReminders ?? this.exerciseReminders,
      mealReminderTime: mealReminderTime ?? this.mealReminderTime,
      waterReminderTime: waterReminderTime ?? this.waterReminderTime,
      exerciseReminderTime: exerciseReminderTime ?? this.exerciseReminderTime,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  @override
  String toString() {
    return 'NotificationSettings(enabled: $enabled, mealReminders: $mealReminders, appointmentReminders: $appointmentReminders)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationSettings &&
        other.enabled == enabled &&
        other.mealReminders == mealReminders &&
        other.appointmentReminders == appointmentReminders &&
        other.progressReminders == progressReminders &&
        other.healthTips == healthTips &&
        other.waterReminders == waterReminders &&
        other.exerciseReminders == exerciseReminders &&
        other.mealReminderTime == mealReminderTime &&
        other.waterReminderTime == waterReminderTime &&
        other.exerciseReminderTime == exerciseReminderTime &&
        other.soundEnabled == soundEnabled &&
        other.vibrationEnabled == vibrationEnabled &&
        other.quietHoursEnabled == quietHoursEnabled &&
        other.quietHoursStart == quietHoursStart &&
        other.quietHoursEnd == quietHoursEnd;
  }

  @override
  int get hashCode {
    return enabled.hashCode ^
        mealReminders.hashCode ^
        appointmentReminders.hashCode ^
        progressReminders.hashCode ^
        healthTips.hashCode ^
        waterReminders.hashCode ^
        exerciseReminders.hashCode ^
        mealReminderTime.hashCode ^
        waterReminderTime.hashCode ^
        exerciseReminderTime.hashCode ^
        soundEnabled.hashCode ^
        vibrationEnabled.hashCode ^
        quietHoursEnabled.hashCode ^
        quietHoursStart.hashCode ^
        quietHoursEnd.hashCode;
  }
}

/// Time of day for notifications
class NotificationTime {
  final int hour;
  final int minute;

  const NotificationTime({
    required this.hour,
    required this.minute,
  });

  /// Create from JSON
  factory NotificationTime.fromJson(Map<String, dynamic> json) {
    return NotificationTime(
      hour: json['hour'] ?? 8,
      minute: json['minute'] ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'minute': minute,
    };
  }

  /// Format as string (HH:MM)
  String format() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return format();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationTime &&
        other.hour == hour &&
        other.minute == minute;
  }

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;
}
