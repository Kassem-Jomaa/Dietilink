import '../../auth/models/user_model.dart';

class ProfileModel {
  final UserModel user;
  final PatientModel patient;
  final BmiModel bmi;

  ProfileModel({
    required this.user,
    required this.patient,
    required this.bmi,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      user: UserModel.fromJson(json['user']),
      patient: PatientModel.fromJson(json['patient']),
      bmi: BmiModel.fromJson(json['bmi']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'patient': patient.toJson(),
      'bmi': bmi.toJson(),
    };
  }
}

class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? role;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.role,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      status: json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'status': status,
    };
  }
}

class PatientModel {
  final String? phone;
  final String? gender;
  final DateTime? birthDate;
  final int? age;
  final String? occupation;
  final double? height;
  final double? initialWeight;
  final double? goalWeight;
  final String? activityLevel;
  final List<String>? medicalConditions;
  final List<String>? allergies;
  final List<String>? medications;
  final List<String>? surgeries;
  final String? smokingStatus;
  final List<String>? giSymptoms;
  final String? recentBloodTest;
  final List<String>? dietaryPreferences;
  final String? alcoholIntake;
  final String? coffeeIntake;
  final List<String>? vitaminIntake;
  final String? dailyRoutine;
  final String? physicalActivityDetails;
  final List<String>? previousDiets;
  final List<Map<String, dynamic>>? weightHistory;
  final String? subscriptionReason;
  final String? notes;
  final Map<String, dynamic>? additionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  PatientModel({
    this.phone,
    this.gender,
    this.birthDate,
    this.age,
    this.occupation,
    this.height,
    this.initialWeight,
    this.goalWeight,
    this.activityLevel,
    this.medicalConditions,
    this.allergies,
    this.medications,
    this.surgeries,
    this.smokingStatus,
    this.giSymptoms,
    this.recentBloodTest,
    this.dietaryPreferences,
    this.alcoholIntake,
    this.coffeeIntake,
    this.vitaminIntake,
    this.dailyRoutine,
    this.physicalActivityDetails,
    this.previousDiets,
    this.weightHistory,
    this.subscriptionReason,
    this.notes,
    this.additionalInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      phone: json['phone'],
      gender: json['gender'],
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'])
          : null,
      age: json['age'],
      occupation: json['occupation'],
      height: json['height']?.toDouble(),
      initialWeight: json['initial_weight']?.toDouble(),
      goalWeight: json['goal_weight']?.toDouble(),
      activityLevel: json['activity_level'],
      medicalConditions: List<String>.from(json['medical_conditions'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      medications: List<String>.from(json['medications'] ?? []),
      surgeries: List<String>.from(json['surgeries'] ?? []),
      smokingStatus: json['smoking_status'],
      giSymptoms: List<String>.from(json['gi_symptoms'] ?? []),
      recentBloodTest: json['recent_blood_test'],
      dietaryPreferences: List<String>.from(json['dietary_preferences'] ?? []),
      alcoholIntake: json['alcohol_intake'],
      coffeeIntake: json['coffee_intake'],
      vitaminIntake: List<String>.from(json['vitamin_intake'] ?? []),
      dailyRoutine: json['daily_routine'],
      physicalActivityDetails: json['physical_activity_details'],
      previousDiets: List<String>.from(json['previous_diets'] ?? []),
      weightHistory:
          List<Map<String, dynamic>>.from(json['weight_history'] ?? []),
      subscriptionReason: json['subscription_reason'],
      notes: json['notes'],
      additionalInfo: json['additional_info'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'gender': gender,
      'birth_date': birthDate?.toIso8601String(),
      'occupation': occupation,
      'height': height,
      'initial_weight': initialWeight,
      'goal_weight': goalWeight,
      'activity_level': activityLevel,
      'medical_conditions': medicalConditions,
      'allergies': allergies,
      'medications': medications,
      'surgeries': surgeries,
      'smoking_status': smokingStatus,
      'gi_symptoms': giSymptoms,
      'recent_blood_test': recentBloodTest,
      'dietary_preferences': dietaryPreferences,
      'alcohol_intake': alcoholIntake,
      'coffee_intake': coffeeIntake,
      'vitamin_intake': vitaminIntake,
      'daily_routine': dailyRoutine,
      'physical_activity_details': physicalActivityDetails,
      'previous_diets': previousDiets,
      'notes': notes,
    };
  }
}

class BmiModel {
  final double current;
  final double initial;
  final double change;
  final String category;
  final String color;
  final double currentWeight;

  BmiModel({
    required this.current,
    required this.initial,
    required this.change,
    required this.category,
    required this.color,
    required this.currentWeight,
  });

  factory BmiModel.fromJson(Map<String, dynamic> json) {
    return BmiModel(
      current: json['current'].toDouble(),
      initial: json['initial'].toDouble(),
      change: json['change'].toDouble(),
      category: json['category'],
      color: json['color'],
      currentWeight: json['current_weight'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current,
      'initial': initial,
      'change': change,
      'category': category,
      'color': color,
      'current_weight': currentWeight,
    };
  }
}
