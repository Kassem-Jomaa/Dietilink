class ProgressImage {
  final int id;
  final String url;
  final String path;

  ProgressImage({
    required this.id,
    required this.url,
    required this.path,
  });

  factory ProgressImage.fromJson(Map<String, dynamic> json) {
    return ProgressImage(
      id: json['id'],
      url: json['url'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'path': path,
    };
  }
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
      chest: json['chest']?.toDouble(),
      leftArm: json['left_arm']?.toDouble(),
      rightArm: json['right_arm']?.toDouble(),
      waist: json['waist']?.toDouble(),
      hips: json['hips']?.toDouble(),
      leftThigh: json['left_thigh']?.toDouble(),
      rightThigh: json['right_thigh']?.toDouble(),
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
      fatMass: json['fat_mass']?.toDouble(),
      muscleMass: json['muscle_mass']?.toDouble(),
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
  final int id;
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
      id: json['id'],
      weight: json['weight'].toDouble(),
      measurementDate: json['measurement_date'],
      notes: json['notes'],
      measurements: Measurements.fromJson(json['measurements'] ?? {}),
      bodyComposition: BodyComposition.fromJson(json['body_composition'] ?? {}),
      images: (json['images'] as List?)
              ?.map((image) => ProgressImage.fromJson(image))
              .toList() ??
          [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
      totalEntries: json['total_entries'],
      perPage: json['per_page'],
      hasNextPage: json['has_next_page'],
      hasPreviousPage: json['has_previous_page'],
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
      progressEntries: (json['progress_entries'] as List)
          .map((entry) => ProgressEntry.fromJson(entry))
          .toList(),
      pagination: ProgressPagination.fromJson(json['pagination']),
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
      startDate: json['start_date'],
      endDate: json['end_date'],
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
      totalEntries: json['total_entries'],
      weightChange: json['weight_change'].toDouble(),
      initialWeight: json['initial_weight'].toDouble(),
      currentWeight: json['current_weight'].toDouble(),
      waistChange: json['waist_change']?.toDouble(),
      hipsChange: json['hips_change']?.toDouble(),
      chestChange: json['chest_change']?.toDouble(),
      measurementPeriod: MeasurementPeriod.fromJson(json['measurement_period']),
    );
  }
}
