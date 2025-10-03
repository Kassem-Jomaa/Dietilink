// Enhanced safe parsing helper functions to handle flexible API types
int _parseInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    // Handle common string formats: "1", "1.0", " 1 "
    final cleaned = value.trim();
    if (cleaned.isEmpty) return defaultValue;
    return int.tryParse(cleaned) ??
        double.tryParse(cleaned)?.toInt() ??
        defaultValue;
  }
  if (value is bool) return value ? 1 : 0;
  return defaultValue;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    final cleaned = value.trim();
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned) ?? double.tryParse(cleaned)?.toInt();
  }
  if (value is bool) return value ? 1 : 0;
  return null;
}

double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
  if (value == null) return defaultValue;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    final cleaned = value.trim();
    if (cleaned.isEmpty) return defaultValue;
    return double.tryParse(cleaned) ?? defaultValue;
  }
  if (value is bool) return value ? 1.0 : 0.0;
  return defaultValue;
}

double? _parseNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    final cleaned = value.trim();
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }
  if (value is bool) return value ? 1.0 : 0.0;
  return null;
}

String _parseString(dynamic value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  if (value is String) return value;
  return value.toString();
}

String? _parseNullableString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value.isEmpty ? null : value;
  return value.toString();
}

// Helper for ID fields that could be string or int
String _parseId(dynamic value, {String defaultValue = '0'}) {
  if (value == null) return defaultValue;
  if (value is String) return value.isEmpty ? defaultValue : value;
  if (value is int) return value.toString();
  if (value is double) return value.toInt().toString();
  return value.toString();
}

// Helper for boolean fields that could be various types
bool _parseBool(dynamic value, {bool defaultValue = false}) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is String) {
    final cleaned = value.toLowerCase().trim();
    return cleaned == 'true' || cleaned == '1' || cleaned == 'yes';
  }
  if (value is int) return value != 0;
  if (value is double) return value != 0.0;
  return defaultValue;
}

class ProgressImage {
  final String id; // Changed to String to handle both "1" and 1 from API
  final String url;
  final String path;

  ProgressImage({
    required this.id,
    required this.url,
    required this.path,
  });

  factory ProgressImage.fromJson(Map<String, dynamic> json) {
    return ProgressImage(
      id: _parseId(json['id']), // Use flexible ID parsing
      url: _parseString(json['url']),
      path: _parseString(json['path']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Already a string, no conversion needed
      'url': url,
      'path': path,
    };
  }

  // Helper methods for ID conversion
  int get idAsInt => int.tryParse(id) ?? 0;
  bool get hasValidId => id.isNotEmpty && id != '0';
}

class Measurements {
  final double? chest;
  final double? leftArm;
  final double? rightArm;
  final double? waist;
  final double? hips;
  final double? leftThigh;
  final double? rightThigh;

  Measurements({
    this.chest,
    this.leftArm,
    this.rightArm,
    this.waist,
    this.hips,
    this.leftThigh,
    this.rightThigh,
  });

  factory Measurements.fromJson(Map<String, dynamic> json) {
    return Measurements(
      chest: _parseNullableDouble(json['chest']),
      leftArm: _parseNullableDouble(json['left_arm']),
      rightArm: _parseNullableDouble(json['right_arm']),
      waist: _parseNullableDouble(json['waist']),
      hips: _parseNullableDouble(json['hips']),
      leftThigh: _parseNullableDouble(json['left_thigh']),
      rightThigh: _parseNullableDouble(json['right_thigh']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chest': chest,
      'left_arm': leftArm,
      'right_arm': rightArm,
      'waist': waist,
      'hips': hips,
      'left_thigh': leftThigh,
      'right_thigh': rightThigh,
    };
  }
}

class BodyComposition {
  final double? fatMass;
  final double? muscleMass;

  BodyComposition({
    this.fatMass,
    this.muscleMass,
  });

  factory BodyComposition.fromJson(Map<String, dynamic> json) {
    return BodyComposition(
      fatMass: _parseNullableDouble(json['fat_mass']),
      muscleMass: _parseNullableDouble(json['muscle_mass']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fat_mass': fatMass,
      'muscle_mass': muscleMass,
    };
  }
}

class ProgressEntry {
  final String id; // Changed to String for API flexibility
  final double weight;
  final String measurementDate;
  final String? notes;
  final Measurements measurements;
  final BodyComposition bodyComposition;
  final List<ProgressImage> images;
  final String createdAt;
  final String updatedAt;

  ProgressEntry({
    required this.id,
    required this.weight,
    required this.measurementDate,
    this.notes,
    required this.measurements,
    required this.bodyComposition,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProgressEntry.fromJson(Map<String, dynamic> json) {
    return ProgressEntry(
      id: _parseId(json['id']), // Use flexible ID parsing
      weight: _parseDouble(json['weight'],
          defaultValue: 0.0), // Ensure non-null with default
      measurementDate: _parseString(json['measurement_date']),
      notes: json['notes'] != null ? _parseString(json['notes']) : null,
      measurements: Measurements.fromJson(
          json['measurements'] is Map<String, dynamic>
              ? json['measurements']
              : {}),
      bodyComposition: BodyComposition.fromJson(
          json['body_composition'] is Map<String, dynamic>
              ? json['body_composition']
              : {}),
      images: (json['images'] is List)
          ? (json['images'] as List)
              .where((item) => item is Map<String, dynamic>)
              .map((image) =>
                  ProgressImage.fromJson(image as Map<String, dynamic>))
              .toList()
          : [],
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Already a string
      'weight': weight,
      'measurement_date': measurementDate,
      'notes': notes,
      'measurements': measurements.toJson(),
      'body_composition': bodyComposition.toJson(),
      'images': images.map((image) => image.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Helper methods for ID conversion
  int get idAsInt => int.tryParse(id) ?? 0;
  bool get hasValidId => id.isNotEmpty && id != '0';
}

class ProgressPagination {
  final int currentPage;
  final int totalPages;
  final int totalEntries;
  final int perPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  ProgressPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalEntries,
    required this.perPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory ProgressPagination.fromJson(Map<String, dynamic> json) {
    return ProgressPagination(
      currentPage: _parseInt(json['current_page'], defaultValue: 1),
      totalPages: _parseInt(json['total_pages'], defaultValue: 1),
      totalEntries: _parseInt(json['total_entries'], defaultValue: 0),
      perPage: _parseInt(json['per_page'], defaultValue: 20),
      // Handle boolean values more flexibly
      hasNextPage: _parseBool(json['has_next_page']),
      hasPreviousPage: _parseBool(json['has_previous_page']),
    );
  }
}

class ProgressHistory {
  final List<ProgressEntry> progressEntries;
  final ProgressPagination pagination;

  ProgressHistory({
    required this.progressEntries,
    required this.pagination,
  });

  factory ProgressHistory.fromJson(Map<String, dynamic> json) {
    return ProgressHistory(
      progressEntries: (json['progress_entries'] is List)
          ? (json['progress_entries'] as List)
              .where((item) => item is Map<String, dynamic>)
              .map((entry) =>
                  ProgressEntry.fromJson(entry as Map<String, dynamic>))
              .toList()
          : [],
      pagination: ProgressPagination.fromJson(
          json['pagination'] is Map<String, dynamic> ? json['pagination'] : {}),
    );
  }
}

class MeasurementPeriod {
  final String startDate;
  final String endDate;

  MeasurementPeriod({
    required this.startDate,
    required this.endDate,
  });

  factory MeasurementPeriod.fromJson(Map<String, dynamic> json) {
    return MeasurementPeriod(
      startDate: _parseString(json['start_date']),
      endDate: _parseString(json['end_date']),
    );
  }
}

class ProgressStatistics {
  final int totalEntries;
  final double weightChange;
  final double initialWeight;
  final double currentWeight;
  final double? waistChange;
  final double? hipsChange;
  final double? chestChange;
  final MeasurementPeriod measurementPeriod;

  ProgressStatistics({
    required this.totalEntries,
    required this.weightChange,
    required this.initialWeight,
    required this.currentWeight,
    this.waistChange,
    this.hipsChange,
    this.chestChange,
    required this.measurementPeriod,
  });

  factory ProgressStatistics.fromJson(Map<String, dynamic> json) {
    return ProgressStatistics(
      totalEntries: _parseInt(json['total_entries'], defaultValue: 0),
      weightChange: _parseDouble(json['weight_change'], defaultValue: 0.0),
      initialWeight: _parseDouble(json['initial_weight'], defaultValue: 0.0),
      currentWeight: _parseDouble(json['current_weight'], defaultValue: 0.0),
      waistChange: _parseNullableDouble(json['waist_change']),
      hipsChange: _parseNullableDouble(json['hips_change']),
      chestChange: _parseNullableDouble(json['chest_change']),
      measurementPeriod: MeasurementPeriod.fromJson(
          json['measurement_period'] is Map<String, dynamic>
              ? json['measurement_period']
              : {}),
    );
  }
}
