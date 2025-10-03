import 'package:flutter_test/flutter_test.dart';
import '../models/profile_model.dart';

void main() {
  group('Profile Type Safety Tests', () {
    test('PatientModel handles string numeric values', () {
      final json = {
        'phone': '+1234567890',
        'gender': 'male',
        'age': '35', // String instead of int
        'height': '175.5', // String instead of double
        'initial_weight': '80.2', // String instead of double
        'goal_weight': '75.0', // String instead of double
        'activity_level': 'moderate',
      };

      expect(() => PatientModel.fromJson(json), returnsNormally);

      final patient = PatientModel.fromJson(json);
      expect(patient.age, equals(35));
      expect(patient.height, equals(175.5));
      expect(patient.initialWeight, equals(80.2));
      expect(patient.goalWeight, equals(75.0));
    });

    test('PatientModel handles null values gracefully', () {
      final json = {
        'phone': null,
        'gender': null,
        'age': null,
        'height': null,
        'initial_weight': null,
        'goal_weight': null,
      };

      expect(() => PatientModel.fromJson(json), returnsNormally);

      final patient = PatientModel.fromJson(json);
      expect(patient.age, isNull);
      expect(patient.height, isNull);
      expect(patient.initialWeight, isNull);
      expect(patient.goalWeight, isNull);
    });

    test('PatientModel handles mixed type values', () {
      final json = {
        'phone': '+1234567890',
        'age': 35, // int
        'height': 175.5, // double
        'initial_weight': '80', // string
        'goal_weight': 75, // int
      };

      expect(() => PatientModel.fromJson(json), returnsNormally);

      final patient = PatientModel.fromJson(json);
      expect(patient.age, equals(35));
      expect(patient.height, equals(175.5));
      expect(patient.initialWeight, equals(80.0));
      expect(patient.goalWeight, equals(75.0));
    });

    test('BmiModel handles direct BMI object (controller passes nested data)',
        () {
      // This simulates the correct data structure passed from controller
      final json = {
        'current': '25.5',
        'initial': '28.0',
        'change': '-2.5',
        'category': 'Normal',
        'color': 'green',
        'current_weight': '75.5'
      };

      expect(() => BmiModel.fromJson(json), returnsNormally);

      final bmi = BmiModel.fromJson(json);
      expect(bmi.current, equals(25.5));
      expect(bmi.initial, equals(28.0));
      expect(bmi.change, equals(-2.5));
      expect(bmi.category, equals('Normal'));
      expect(bmi.color, equals('green'));
      expect(bmi.currentWeight, equals(75.5));
    });

    test('BmiModel handles flat API response structure', () {
      final json = {
        'current': '25.5',
        'initial': '28.0',
        'change': '-2.5',
        'category': 'Normal',
        'color': 'green',
        'current_weight': '75.5'
      };

      expect(() => BmiModel.fromJson(json), returnsNormally);

      final bmi = BmiModel.fromJson(json);
      expect(bmi.current, equals(25.5));
      expect(bmi.initial, equals(28.0));
      expect(bmi.change, equals(-2.5));
    });

    test('BmiModel handles numeric values as different types', () {
      final json = {
        'current': 25.5, // double
        'initial': 28, // int
        'change': '-2.5', // string
        'category': 'Normal',
        'color': 'green',
        'current_weight': '75' // string
      };

      expect(() => BmiModel.fromJson(json), returnsNormally);

      final bmi = BmiModel.fromJson(json);
      expect(bmi.current, equals(25.5));
      expect(bmi.initial, equals(28.0));
      expect(bmi.change, equals(-2.5));
      expect(bmi.currentWeight, equals(75.0));
    });

    test('BmiModel handles missing or null values', () {
      final json = {
        'current': null,
        'initial': null,
        'change': null,
        'category': null,
        'color': null,
        'current_weight': null
      };

      expect(() => BmiModel.fromJson(json), returnsNormally);

      final bmi = BmiModel.fromJson(json);
      expect(bmi.current, equals(0.0));
      expect(bmi.initial, equals(0.0));
      expect(bmi.change, equals(0.0));
      expect(bmi.category, equals('Unknown'));
      expect(bmi.color, equals('gray'));
      expect(bmi.currentWeight, equals(0.0));
    });

    test('Complete ProfileModel parsing with mixed types', () {
      final json = {
        'user': {'id': '1', 'name': 'John Doe', 'email': 'john@example.com'},
        'patient': {
          'phone': '+1234567890',
          'gender': 'male',
          'age': '35',
          'height': '175.5',
          'initial_weight': '80.2',
          'goal_weight': 75.0,
          'activity_level': 'moderate'
        },
        'bmi': {
          'current': '25.5',
          'initial': 28,
          'change': '-2.5',
          'category': 'Normal',
          'color': 'green',
          'current_weight': '75.5'
        }
      };

      expect(() => ProfileModel.fromJson(json), returnsNormally);

      final profile = ProfileModel.fromJson(json);
      expect(profile.user.name, equals('John Doe'));
      expect(profile.patient.age, equals(35));
      expect(profile.patient.height, equals(175.5));
      expect(profile.bmi?.current, equals(25.5));
      expect(profile.bmi?.initial, equals(28.0));
    });
  });

  group('Safe Parsing Helper Function Tests', () {
    // Note: These functions are private in the model, so we test them indirectly
    // through the model parsing methods above. In a real scenario, you might
    // make them public or create a separate utility class for testing.

    test('String to double conversion edge cases', () {
      final testCases = {
        'phone': '+1234567890', // Non-numeric string
        'height': '175.5', // Valid double string
        'weight': '80', // Integer string
        'invalid': 'abc', // Invalid numeric string
        'empty': '', // Empty string
        'null_field': null, // Null value
      };

      expect(() => PatientModel.fromJson(testCases), returnsNormally);

      final patient = PatientModel.fromJson(testCases);
      // The parsing should handle invalid/non-numeric strings gracefully
      expect(patient.phone, equals('+1234567890'));
      expect(patient.height, equals(175.5));
    });
  });
}
