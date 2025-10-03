import '../../auth/models/user_model.dart';

class ProfileModel {
  final UserModel user;
  final PatientModel patient;
  final BmiModel? bmi;

  ProfileModel({
    required this.user,
    required this.patient,
    this.bmi,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      user: UserModel.fromJson(json['user']),
      patient: PatientModel.fromJson(json['patient']),
      bmi: json['bmi'] != null ? BmiModel.fromJson(json['bmi']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'patient': patient.toJson(),
      'bmi': bmi?.toJson(),
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
  final String? medicalConditions;
  final String? allergies;
  final String? medications;
  final String? surgeries;
  final String? smokingStatus;
  final String? giSymptoms;
  final String? recentBloodTest;
  final String? dietaryPreferences;
  final String? alcoholIntake;
  final String? coffeeIntake;
  final String? vitaminIntake;
  final String? dailyRoutine;
  final String? physicalActivityDetails;
  final String? previousDiets;
  final String? weightHistory;
  final String? subscriptionReason;
  final String? notes;
  final Map<String, dynamic>? additionalInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.createdAt,
    this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Detailed PatientModel parsing:');

      // Parse each field with safe parsing helpers
      String? phone;
      try {
        phone = _parseNullableString(json['phone']);
        print('✅ phone: $phone');
      } catch (e) {
        print('❌ Error parsing phone: $e');
        phone = null;
      }

      String? gender;
      try {
        gender = _parseNullableString(json['gender']);
        print('✅ gender: $gender');
      } catch (e) {
        print('❌ Error parsing gender: $e');
        gender = null;
      }

      DateTime? birthDate;
      try {
        birthDate = json['birth_date'] != null
            ? DateTime.parse(json['birth_date'])
            : null;
        print('✅ birthDate: $birthDate');
      } catch (e) {
        print('❌ Error parsing birth_date: $e');
        birthDate = null;
      }

      int? age;
      try {
        age = _parseNullableInt(json['age']);
        print('✅ age: $age');
      } catch (e) {
        print('❌ Error parsing age: $e');
        age = null;
      }

      String? occupation;
      try {
        occupation = _parseNullableString(json['occupation']);
        print('✅ occupation: $occupation');
      } catch (e) {
        print('❌ Error parsing occupation: $e');
        occupation = null;
      }

      double? height;
      try {
        height = _parseNullableDouble(json['height']);
        print('✅ height: $height');
      } catch (e) {
        print('❌ Error parsing height: $e');
        height = null;
      }

      double? initialWeight;
      try {
        initialWeight = _parseNullableDouble(json['initial_weight']);
        print('✅ initialWeight: $initialWeight');
      } catch (e) {
        print('❌ Error parsing initial_weight: $e');
        initialWeight = null;
      }

      double? goalWeight;
      try {
        goalWeight = _parseNullableDouble(json['goal_weight']);
        print('✅ goalWeight: $goalWeight');
      } catch (e) {
        print('❌ Error parsing goal_weight: $e');
        goalWeight = null;
      }

      String? activityLevel;
      try {
        activityLevel = _parseNullableString(json['activity_level']);
        print('✅ activityLevel: $activityLevel');
      } catch (e) {
        print('❌ Error parsing activity_level: $e');
        activityLevel = null;
      }

      // String fields that used to be lists
      String? medicalConditions;
      try {
        medicalConditions = _parseNullableString(json['medical_conditions']);
        print('✅ medicalConditions: $medicalConditions');
      } catch (e) {
        print('❌ Error parsing medical_conditions: $e');
        medicalConditions = null;
      }

      String? allergies;
      try {
        allergies = _parseNullableString(json['allergies']);
        print('✅ allergies: $allergies');
      } catch (e) {
        print('❌ Error parsing allergies: $e');
        allergies = null;
      }

      String? medications;
      try {
        medications = _parseNullableString(json['medications']);
        print('✅ medications: $medications');
      } catch (e) {
        print('❌ Error parsing medications: $e');
        medications = null;
      }

      String? surgeries;
      try {
        surgeries = _parseNullableString(json['surgeries']);
        print('✅ surgeries: $surgeries');
      } catch (e) {
        print('❌ Error parsing surgeries: $e');
        surgeries = null;
      }

      String? smokingStatus;
      try {
        smokingStatus = _parseNullableString(json['smoking_status']);
        print('✅ smokingStatus: $smokingStatus');
      } catch (e) {
        print('❌ Error parsing smoking_status: $e');
        smokingStatus = null;
      }

      String? giSymptoms;
      try {
        giSymptoms = _parseNullableString(json['gi_symptoms']);
        print('✅ giSymptoms: $giSymptoms');
      } catch (e) {
        print('❌ Error parsing gi_symptoms: $e');
        giSymptoms = null;
      }

      String? recentBloodTest;
      try {
        recentBloodTest = _parseNullableString(json['recent_blood_test']);
        print('✅ recentBloodTest: $recentBloodTest');
      } catch (e) {
        print('❌ Error parsing recent_blood_test: $e');
        recentBloodTest = null;
      }

      String? dietaryPreferences;
      try {
        dietaryPreferences = _parseNullableString(json['dietary_preferences']);
        print('✅ dietaryPreferences: $dietaryPreferences');
      } catch (e) {
        print('❌ Error parsing dietary_preferences: $e');
        dietaryPreferences = null;
      }

      String? alcoholIntake;
      try {
        alcoholIntake = _parseNullableString(json['alcohol_intake']);
        print('✅ alcoholIntake: $alcoholIntake');
      } catch (e) {
        print('❌ Error parsing alcohol_intake: $e');
        alcoholIntake = null;
      }

      String? coffeeIntake;
      try {
        coffeeIntake = _parseNullableString(json['coffee_intake']);
        print('✅ coffeeIntake: $coffeeIntake');
      } catch (e) {
        print('❌ Error parsing coffee_intake: $e');
        coffeeIntake = null;
      }

      String? vitaminIntake;
      try {
        vitaminIntake = _parseNullableString(json['vitamin_intake']);
        print('✅ vitaminIntake: $vitaminIntake');
      } catch (e) {
        print('❌ Error parsing vitamin_intake: $e');
        vitaminIntake = null;
      }

      String? dailyRoutine;
      try {
        dailyRoutine = _parseNullableString(json['daily_routine']);
        print('✅ dailyRoutine: $dailyRoutine');
      } catch (e) {
        print('❌ Error parsing daily_routine: $e');
        dailyRoutine = null;
      }

      String? physicalActivityDetails;
      try {
        physicalActivityDetails =
            _parseNullableString(json['physical_activity_details']);
        print('✅ physicalActivityDetails: $physicalActivityDetails');
      } catch (e) {
        print('❌ Error parsing physical_activity_details: $e');
        physicalActivityDetails = null;
      }

      String? previousDiets;
      try {
        previousDiets = _parseNullableString(json['previous_diets']);
        print('✅ previousDiets: $previousDiets');
      } catch (e) {
        print('❌ Error parsing previous_diets: $e');
        previousDiets = null;
      }

      // Changed from List to String
      String? weightHistory;
      try {
        weightHistory = _parseNullableString(json['weight_history']);
        print('✅ weightHistory: $weightHistory');
      } catch (e) {
        print('❌ Error parsing weight_history: $e');
        weightHistory = null;
      }

      String? subscriptionReason;
      try {
        subscriptionReason = _parseNullableString(json['subscription_reason']);
        print('✅ subscriptionReason: $subscriptionReason');
      } catch (e) {
        print('❌ Error parsing subscription_reason: $e');
        subscriptionReason = null;
      }

      String? notes;
      try {
        notes = _parseNullableString(json['notes']);
        print('✅ notes: $notes');
      } catch (e) {
        print('❌ Error parsing notes: $e');
        notes = null;
      }

      Map<String, dynamic>? additionalInfo;
      try {
        additionalInfo = json['additional_info'] as Map<String, dynamic>?;
        print('✅ additionalInfo: $additionalInfo');
      } catch (e) {
        print('❌ Error parsing additional_info: $e');
        additionalInfo = null;
      }

      DateTime? createdAt;
      try {
        createdAt = json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null;
        print('✅ createdAt: $createdAt');
      } catch (e) {
        print('❌ Error parsing created_at: $e');
        createdAt = null;
      }

      DateTime? updatedAt;
      try {
        updatedAt = json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null;
        print('✅ updatedAt: $updatedAt');
      } catch (e) {
        print('❌ Error parsing updated_at: $e');
        updatedAt = null;
      }

      print('✅ All fields parsed successfully, creating PatientModel...');

      return PatientModel(
        phone: phone,
        gender: gender,
        birthDate: birthDate,
        age: age,
        occupation: occupation,
        height: height,
        initialWeight: initialWeight,
        goalWeight: goalWeight,
        activityLevel: activityLevel,
        medicalConditions: medicalConditions,
        allergies: allergies,
        medications: medications,
        surgeries: surgeries,
        smokingStatus: smokingStatus,
        giSymptoms: giSymptoms,
        recentBloodTest: recentBloodTest,
        dietaryPreferences: dietaryPreferences,
        alcoholIntake: alcoholIntake,
        coffeeIntake: coffeeIntake,
        vitaminIntake: vitaminIntake,
        dailyRoutine: dailyRoutine,
        physicalActivityDetails: physicalActivityDetails,
        previousDiets: previousDiets,
        weightHistory: weightHistory,
        subscriptionReason: subscriptionReason,
        notes: notes,
        additionalInfo: additionalInfo,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      print('❌ Fatal error in PatientModel.fromJson: $e');
      print('❌ JSON data that caused error: $json');
      rethrow;
    }
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
    print('🧪 DETAILED BMI PARSING TEST:');
    print('BMI JSON: $json');
    print('BMI keys: ${json.keys}');

    // Test each field individually with detailed logging
    print('🔍 Testing individual field parsing:');

    print('Raw current: "${json['current']}" (${json['current'].runtimeType})');
    final current = _parseDouble(json['current']);
    print('Parsed current: $current');

    print('Raw initial: "${json['initial']}" (${json['initial'].runtimeType})');
    final initial = _parseDouble(json['initial']);
    print('Parsed initial: $initial');

    print('Raw change: "${json['change']}" (${json['change'].runtimeType})');
    final change = _parseDouble(json['change']);
    print('Parsed change: $change');

    print(
        'Raw category: "${json['category']}" (${json['category'].runtimeType})');
    final category = _parseString(json['category']);
    print('Parsed category: "$category"');

    print('Raw color: "${json['color']}" (${json['color'].runtimeType})');
    final color = _parseString(json['color']);
    print('Parsed color: "$color"');

    print(
        'Raw current_weight: "${json['current_weight']}" (${json['current_weight'].runtimeType})');
    final currentWeight = _parseDouble(json['current_weight']);
    print('Parsed currentWeight: $currentWeight');

    final bmi = BmiModel(
      current: current,
      initial: initial,
      change: change,
      category: category,
      color: color,
      currentWeight: currentWeight,
    );

    print('✅ BmiModel created successfully:');
    print('  current: ${bmi.current}');
    print('  initial: ${bmi.initial}');
    print('  change: ${bmi.change}');
    print('  category: "${bmi.category}"');
    print('  color: "${bmi.color}"');
    print('  currentWeight: ${bmi.currentWeight}');

    return bmi;
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

// Safe parsing helper functions for flexible type handling
double? _parseNullableDouble(dynamic value) {
  print('  🔍 _parseNullableDouble input: $value (${value.runtimeType})');
  if (value == null) {
    print('    → null value, returning null');
    return null;
  }
  if (value is double) {
    print('    → already double: $value');
    return value;
  }
  if (value is int) {
    final result = value.toDouble();
    print('    → converting int to double: $result');
    return result;
  }
  if (value is String) {
    final result = double.tryParse(value);
    print('    → parsing string "$value" to double: $result');
    return result;
  }
  print('    → unhandled type ${value.runtimeType}, returning null');
  return null;
}

double _parseDouble(dynamic value) {
  final result = _parseNullableDouble(value) ?? 0.0;
  print('  → final _parseDouble result: $result');
  return result;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}

int _parseInt(dynamic value) {
  return _parseNullableInt(value) ?? 0;
}

String? _parseNullableString(dynamic value) {
  print('  🔍 _parseNullableString input: $value (${value.runtimeType})');
  if (value == null) {
    print('    → null value, returning null');
    return null;
  }
  final result = value.toString();
  print('    → converted to string: "$result"');
  return result;
}

String _parseString(dynamic value) {
  final result = _parseNullableString(value) ?? '';
  print('  → final _parseString result: "$result"');
  return result;
}

bool _parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is String) {
    return value.toLowerCase() == 'true' || value == '1';
  }
  if (value is int) return value == 1;
  return false;
}
