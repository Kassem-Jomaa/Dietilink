import 'dart:convert';

/// Utility class for logging and analyzing API response types
/// This helps identify type inconsistencies between expected and actual API responses
class ApiResponseLogger {
  static const bool enableLogging =
      false; // Set to false to prevent infinite loops

  /// Log the structure and types of an API response
  static void logResponse(String endpoint, Map<String, dynamic> response) {
    if (!enableLogging) return;

    print('\n🔍 API Response Analysis for: $endpoint');
    print('=' * 60);

    _analyzeObject(response, 0);

    print('=' * 60);
  }

  /// Recursively analyze an object and print its structure
  static void _analyzeObject(dynamic obj, int depth) {
    final indent = '  ' * depth;

    if (obj == null) {
      print('${indent}null');
      return;
    }

    if (obj is Map<String, dynamic>) {
      print('${indent}Map {');
      obj.forEach((key, value) {
        final valueType = _getDetailedType(value);
        print('${indent}  "$key": $valueType');
        if (value is Map<String, dynamic> || value is List) {
          _analyzeObject(value, depth + 2);
        }
      });
      print('${indent}}');
    } else if (obj is List) {
      print('${indent}List [${obj.length} items]');
      if (obj.isNotEmpty) {
        print('${indent}  First item type: ${_getDetailedType(obj.first)}');
        if (obj.first is Map<String, dynamic> || obj.first is List) {
          _analyzeObject(obj.first, depth + 2);
        }
      }
    }
  }

  /// Get detailed type information including actual values for primitives
  static String _getDetailedType(dynamic value) {
    if (value == null) return 'null';

    final type = value.runtimeType.toString();

    if (value is String) {
      return 'String("$value")';
    } else if (value is int) {
      return 'int($value)';
    } else if (value is double) {
      return 'double($value)';
    } else if (value is bool) {
      return 'bool($value)';
    } else if (value is List) {
      return 'List<${value.isNotEmpty ? value.first.runtimeType : 'dynamic'}>';
    } else if (value is Map) {
      return 'Map<String, dynamic>';
    }

    return type;
  }

  /// Test specific field types that commonly cause issues
  static void testCriticalFields(Map<String, dynamic> response) {
    if (!enableLogging) return;

    print('\n🎯 Critical Field Type Testing:');
    print('-' * 40);

    // Test common ID fields
    _testField(response, ['id', 'user_id', 'progress_id'], 'ID fields');

    // Test pagination fields
    _testField(
        response,
        ['current_page', 'total_pages', 'per_page', 'total_entries'],
        'Pagination fields');

    // Test numeric fields
    _testField(
        response, ['weight', 'chest', 'waist', 'hips'], 'Measurement fields');

    // Test boolean fields
    _testField(response, ['has_next_page', 'has_previous_page', 'success'],
        'Boolean fields');

    // Test date fields
    _testField(response, ['created_at', 'updated_at', 'measurement_date'],
        'Date fields');
  }

  static void _testField(
      Map<String, dynamic> data, List<String> fieldPaths, String category) {
    print('\n$category:');

    for (final path in fieldPaths) {
      final value = _getNestedValue(data, path);
      if (value != null) {
        print('  $path: ${_getDetailedType(value)}');
      }
    }
  }

  static dynamic _getNestedValue(Map<String, dynamic> data, String path) {
    // Simple path traversal for nested objects
    final parts = path.split('.');
    dynamic current = data;

    for (final part in parts) {
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        return null;
      }
    }

    return current;
  }

  /// Generate type-safe model code based on actual API response
  static String generateModelCode(
      String className, Map<String, dynamic> sample) {
    final buffer = StringBuffer();
    buffer.writeln(
        '// Generated model for $className based on actual API response');
    buffer.writeln('class $className {');

    sample.forEach((key, value) {
      final dartType = _inferDartType(value);
      final fieldName = _toCamelCase(key);
      buffer.writeln('  final $dartType $fieldName;');
    });

    buffer.writeln('');
    buffer.writeln('  $className({');
    sample.forEach((key, value) {
      final fieldName = _toCamelCase(key);
      final isRequired = !_isNullable(value);
      buffer.writeln('    ${isRequired ? 'required ' : ''}this.$fieldName,');
    });
    buffer.writeln('  });');

    // Add fromJson factory
    buffer.writeln('');
    buffer
        .writeln('  factory $className.fromJson(Map<String, dynamic> json) {');
    buffer.writeln('    return $className(');
    sample.forEach((key, value) {
      final fieldName = _toCamelCase(key);
      final parser = _getParserForType(value);
      buffer.writeln('      $fieldName: $parser(json[\'$key\']),');
    });
    buffer.writeln('    );');
    buffer.writeln('  }');

    buffer.writeln('}');

    return buffer.toString();
  }

  static String _inferDartType(dynamic value) {
    if (value == null)
      return 'String?'; // Default to nullable string for null values
    if (value is String) return value.isEmpty ? 'String?' : 'String';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'bool';
    if (value is List) return 'List<dynamic>';
    if (value is Map) return 'Map<String, dynamic>';
    return 'dynamic';
  }

  static bool _isNullable(dynamic value) {
    return value == null || (value is String && value.isEmpty);
  }

  static String _toCamelCase(String snakeCase) {
    final parts = snakeCase.split('_');
    if (parts.length == 1) return parts[0];

    return parts[0] +
        parts
            .skip(1)
            .map((part) =>
                part.isEmpty ? '' : part[0].toUpperCase() + part.substring(1))
            .join('');
  }

  static String _getParserForType(dynamic value) {
    if (value == null) return '_parseNullableString';
    if (value is String) return '_parseString';
    if (value is int) return '_parseInt';
    if (value is double) return '_parseDouble';
    if (value is bool) return '_parseBool';
    return '_parseString'; // Default fallback
  }

  /// Quick test method to validate model parsing with real data
  static bool validateModelParsing<T>(
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic> testData,
    String modelName,
  ) {
    try {
      print('\n✅ Testing $modelName parsing...');
      final model = fromJson(testData);
      print('   ✓ $modelName parsed successfully');
      return true;
    } catch (e, stackTrace) {
      print('\n❌ $modelName parsing failed:');
      print('   Error: $e');
      print('   Data: ${jsonEncode(testData)}');
      if (enableLogging) {
        print('   Stack trace: $stackTrace');
      }
      return false;
    }
  }
}

/// Extension to add logging capabilities to API responses
extension ApiResponseAnalysis on Map<String, dynamic> {
  void logApiResponse(String endpoint) {
    ApiResponseLogger.logResponse(endpoint, this);
  }

  void testCriticalFields() {
    ApiResponseLogger.testCriticalFields(this);
  }
}
