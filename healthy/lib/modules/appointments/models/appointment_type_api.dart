/// Appointment Type API Model
///
/// Represents appointment types from the API with all required fields
class AppointmentTypeAPI {
  final int id;
  final String name;
  final int durationMinutes;
  final String formattedDuration;
  final String color;
  final String? description;

  AppointmentTypeAPI({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.formattedDuration,
    required this.color,
    this.description,
  });

  factory AppointmentTypeAPI.fromJson(Map<String, dynamic> json) {
    return AppointmentTypeAPI(
      id: json['id'],
      name: json['name'],
      durationMinutes: json['duration_minutes'],
      formattedDuration: json['formatted_duration'],
      color: json['color'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration_minutes': durationMinutes,
      'formatted_duration': formattedDuration,
      'color': color,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'AppointmentTypeAPI(id: $id, name: $name, duration: $formattedDuration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppointmentTypeAPI && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
