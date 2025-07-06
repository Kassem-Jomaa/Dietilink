import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/exceptions/api_exception.dart';
import '../models/appointment_model.dart';
import '../models/appointment_type_api.dart';
import '../models/dietitian_info.dart';
import '../models/availability_models.dart';
import '../../../config/api_config.dart';

/// Appointments Service
///
/// Handles all appointment-related API calls including:
/// - Getting appointment types
/// - Getting dietitian info
/// - Checking availability
/// - Booking appointments
/// - Managing appointment history
class AppointmentsService {
  final ApiService _apiService;

  AppointmentsService(this._apiService);

  /// Get appointment types (CRITICAL FIRST CALL)
  Future<List<AppointmentTypeAPI>> getAppointmentTypes() async {
    try {
      print('📅 AppointmentsService: Getting appointment types...');

      final response =
          await _apiService.get(ApiConfig.appointmentTypesEndpoint);

      final List<dynamic> typesData =
          response['data']?['appointment_types'] ?? [];
      final List<AppointmentTypeAPI> types =
          typesData.map((type) => AppointmentTypeAPI.fromJson(type)).toList();

      print(
          '✅ AppointmentsService: Retrieved ${types.length} appointment types');
      return types;
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsService.getAppointmentTypes API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AppointmentsService.getAppointmentTypes unexpected error: $e');
      throw ApiException('Failed to get appointment types: $e');
    }
  }

  /// Get dietitian info
  Future<DietitianInfo> getDietitianInfo() async {
    try {
      print('📅 AppointmentsService: Getting dietitian info...');

      final response = await _apiService.get(ApiConfig.dietitianEndpoint);

      print('✅ AppointmentsService: Retrieved dietitian info');
      final dietitianMap = response['data']?['dietitian'];
      if (dietitianMap == null) {
        throw ApiException('No dietitian data found');
      }
      return DietitianInfo.fromJson(dietitianMap);
    } on ApiException catch (e) {
      print('❌ AppointmentsService.getDietitianInfo API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AppointmentsService.getDietitianInfo unexpected error: $e');
      throw ApiException('Failed to get dietitian info: $e');
    }
  }

  /// Get available slots for specific date and appointment type
  Future<List<AppointmentSlot>> getAvailableSlots({
    required String date,
    required int appointmentTypeId,
  }) async {
    try {
      print('📅 AppointmentsService: Getting available slots...');
      print('📅 Date: $date, Appointment Type ID: $appointmentTypeId');

      final queryParameters = <String, dynamic>{
        'date': date,
        'appointment_type_id': appointmentTypeId,
      };

      print('🌐 Calling API: ${ApiConfig.availabilitySlotsEndpoint}');
      print('🌐 Query parameters: $queryParameters');

      final response = await _apiService.get(
        ApiConfig.availabilitySlotsEndpoint,
        queryParameters: queryParameters,
      );

      print('📋 Raw API Response: $response');

      // Handle both API response formats
      List<dynamic> slotsData = [];

      // Try different possible response structures
      if (response['data'] != null &&
          response['data']['available_slots'] != null) {
        slotsData = response['data']['available_slots'] as List;
        print(
            '📋 Found slots in response.data.available_slots: ${slotsData.length}');
      } else if (response['available_slots'] != null) {
        slotsData = response['available_slots'] as List;
        print(
            '📋 Found slots in response.available_slots: ${slotsData.length}');
      } else if (response['slots'] != null) {
        slotsData = response['slots'] as List;
        print('📋 Found slots in response.slots: ${slotsData.length}');
      } else {
        print(
            '❌ No slots found in response. Available keys: ${response.keys.toList()}');
        if (response['data'] != null) {
          print('❌ Data keys: ${(response['data'] as Map).keys.toList()}');
        }
      }

      print('📋 Slots data found: ${slotsData.length} items');
      if (slotsData.isNotEmpty) {
        print('📋 First slot data: ${slotsData.first}');
        print('📋 First slot keys: ${(slotsData.first as Map).keys.toList()}');
      }

      final List<AppointmentSlot> slots = <AppointmentSlot>[];
      for (int i = 0; i < slotsData.length; i++) {
        try {
          // Enhance slot data with date and appointment type ID
          final enhancedSlotData = Map<String, dynamic>.from(slotsData[i]);
          enhancedSlotData['date'] = date;
          enhancedSlotData['appointment_type_id'] = appointmentTypeId;

          final slot = AppointmentSlot.fromJson(enhancedSlotData);
          slots.add(slot);
          print(
              '📋 Successfully parsed slot $i: ${slot.formattedTime} with date=$date, appointmentTypeId=$appointmentTypeId');
        } catch (e) {
          print('❌ Failed to parse slot $i: ${slotsData[i]} - Error: $e');
        }
      }

      print('✅ AppointmentsService: Retrieved ${slots.length} available slots');
      return slots;
    } on ApiException catch (e) {
      print('❌ AppointmentsService.getAvailableSlots API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AppointmentsService.getAvailableSlots unexpected error: $e');
      throw ApiException('Failed to get available slots: $e');
    }
  }

  /// Get date range availability for calendar
  Future<List<DateRangeAvailability>> getDateRangeAvailability({
    required String startDate,
    required String endDate,
    required int appointmentTypeId,
  }) async {
    try {
      print('📅 AppointmentsService: Getting date range availability...');

      final queryParameters = <String, dynamic>{
        'start_date': startDate,
        'end_date': endDate,
        'appointment_type_id': appointmentTypeId,
      };

      final response = await _apiService.get(
        ApiConfig.availabilityDateRangeEndpoint,
        queryParameters: queryParameters,
      );

      // Handle both API response formats
      final List<dynamic> availabilityData =
          response['data']?['availability'] ?? response['availability'] ?? [];
      final List<DateRangeAvailability> availability = availabilityData
          .map((item) => DateRangeAvailability.fromJson(item))
          .toList();

      print(
          '✅ AppointmentsService: Retrieved ${availability.length} date availability items');
      return availability;
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsService.getDateRangeAvailability API error: ${e.message}');
      rethrow;
    } catch (e) {
      print(
          '❌ AppointmentsService.getDateRangeAvailability unexpected error: $e');
      throw ApiException('Failed to get date range availability: $e');
    }
  }

  /// Check specific slot availability
  Future<SlotAvailability> checkSlotAvailability({
    required String date,
    required String startTime,
    required int appointmentTypeId,
  }) async {
    try {
      print('🔍 AppointmentsService: Checking slot availability...');

      final data = <String, dynamic>{
        'date': date,
        'start_time': startTime,
        'appointment_type_id': appointmentTypeId,
      };

      final response = await _apiService.post(
        ApiConfig.availabilityCheckSlotEndpoint,
        data: data,
      );

      // Handle both API response formats
      final slotData = response['data'] ?? response;

      print('✅ AppointmentsService: Slot availability checked');
      return SlotAvailability.fromJson(slotData);
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsService.checkSlotAvailability API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AppointmentsService.checkSlotAvailability unexpected error: $e');
      throw ApiException('Failed to check slot availability: $e');
    }
  }

  /// Book a new appointment
  Future<Appointment> bookAppointment({
    required int dietitianId,
    required int appointmentTypeId,
    required String appointmentDate,
    required String startTime,
    String? notes,
  }) async {
    print('🔍 AppointmentsService: bookAppointment() called');
    print('🔍 AppointmentsService: Parameters:');
    print('  - dietitianId: $dietitianId');
    print('  - appointmentTypeId: $appointmentTypeId');
    print('  - appointmentDate: $appointmentDate');
    print('  - startTime: $startTime');
    print('  - notes: $notes');

    try {
      print('📅 AppointmentsService: Booking appointment...');

      final data = <String, dynamic>{
        'dietitian_id': dietitianId,
        'appointment_type_id': appointmentTypeId,
        'appointment_date': appointmentDate,
        'start_time': startTime,
      };

      if (notes != null && notes.isNotEmpty) {
        data['notes'] = notes;
      }

      print('🔍 AppointmentsService: Request data: $data');

      print(
          '🔍 AppointmentsService: Making API call to ${ApiConfig.appointmentsEndpoint}');
      final response =
          await _apiService.post(ApiConfig.appointmentsEndpoint, data: data);

      print('🔍 AppointmentsService: API Response: $response');
      print('✅ AppointmentsService: Appointment booked successfully');

      // Handle nested response structure
      final appointmentData =
          response['data']?['appointment'] ?? response['appointment'];
      if (appointmentData == null) {
        throw ApiException(
            'Invalid response format: appointment data not found');
      }

      return Appointment.fromJson(appointmentData);
    } on ApiException catch (e) {
      print('❌ AppointmentsService.bookAppointment API error: ${e.message}');
      print('🔍 AppointmentsService: API error details:');
      print('  - Error type: ApiException');
      print('  - Error message: ${e.message}');
      print('  - Error code: ${e.statusCode}');
      rethrow;
    } catch (e) {
      print('❌ AppointmentsService.bookAppointment unexpected error: $e');
      print('🔍 AppointmentsService: Unexpected error details:');
      print('  - Error type: ${e.runtimeType}');
      print('  - Error message: $e');
      throw ApiException('Failed to book appointment: $e');
    }
  }

  /// Get appointment history
  Future<AppointmentHistory> getAppointmentHistory({
    int page = 1,
    int perPage = 10,
    AppointmentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      print('📅 AppointmentsService: Getting appointment history...');

      final queryParameters = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };

      if (status != null) {
        queryParameters['status'] = status.toString().split('.').last;
      }

      if (startDate != null) {
        queryParameters['start_date'] =
            startDate.toIso8601String().split('T')[0];
      }

      if (endDate != null) {
        queryParameters['end_date'] = endDate.toIso8601String().split('T')[0];
      }

      final response = await _apiService.get(
        ApiConfig.appointmentsEndpoint,
        queryParameters: queryParameters,
      );

      print('✅ AppointmentsService: Retrieved appointment history');
      return AppointmentHistory.fromJson(response);
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsService.getAppointmentHistory API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AppointmentsService.getAppointmentHistory unexpected error: $e');
      throw ApiException('Failed to get appointment history: $e');
    }
  }

  /// Get appointment details
  Future<Appointment> getAppointmentDetails(int appointmentId) async {
    try {
      print('📅 AppointmentsService: Getting appointment details...');

      final response = await _apiService
          .get('${ApiConfig.appointmentsEndpoint}/$appointmentId');

      print('✅ AppointmentsService: Retrieved appointment details');

      // Handle nested response structure
      final appointmentData =
          response['data']?['appointment'] ?? response['appointment'];
      if (appointmentData == null) {
        throw ApiException(
            'Invalid response format: appointment data not found');
      }

      return Appointment.fromJson(appointmentData);
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsService.getAppointmentDetails API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AppointmentsService.getAppointmentDetails unexpected error: $e');
      throw ApiException('Failed to get appointment details: $e');
    }
  }

  /// Get next upcoming appointment
  Future<Appointment?> getNextAppointment() async {
    try {
      print('📅 AppointmentsService: Getting next appointment...');

      final response = await _apiService.get(ApiConfig.nextAppointmentEndpoint);

      // Handle nested response structure
      final appointmentData =
          response['data']?['appointment'] ?? response['appointment'];

      if (appointmentData != null) {
        print('✅ AppointmentsService: Retrieved next appointment');
        return Appointment.fromJson(appointmentData);
      } else {
        print('✅ AppointmentsService: No upcoming appointments');
        return null;
      }
    } on ApiException catch (e) {
      print('❌ AppointmentsService.getNextAppointment API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AppointmentsService.getNextAppointment unexpected error: $e');
      throw ApiException('Failed to get next appointment: $e');
    }
  }

  /// Get appointment statistics
  Future<AppointmentStatistics> getAppointmentStatistics() async {
    try {
      print('📅 AppointmentsService: Getting appointment statistics...');

      final response =
          await _apiService.get(ApiConfig.appointmentStatisticsEndpoint);

      print('✅ AppointmentsService: Retrieved appointment statistics');
      return AppointmentStatistics.fromJson(response['statistics']);
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsService.getAppointmentStatistics API error: ${e.message}');
      rethrow;
    } catch (e) {
      print(
          '❌ AppointmentsService.getAppointmentStatistics unexpected error: $e');
      throw ApiException('Failed to get appointment statistics: $e');
    }
  }

  /// Cancel appointment with reason
  Future<void> cancelAppointmentWithReason(
      int appointmentId, String reason) async {
    try {
      print('📅 AppointmentsService: Cancelling appointment...');

      final data = <String, dynamic>{
        'reason': reason,
      };

      await _apiService.post(
        '${ApiConfig.appointmentsEndpoint}/$appointmentId/cancel',
        data: data,
      );

      print('✅ AppointmentsService: Appointment cancelled successfully');
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsService.cancelAppointmentWithReason API error: ${e.message}');
      rethrow;
    } catch (e) {
      print(
          '❌ AppointmentsService.cancelAppointmentWithReason unexpected error: $e');
      throw ApiException('Failed to cancel appointment: $e');
    }
  }

  /// Test method to debug API response structure
  Future<void> testAvailableSlotsResponse({
    required String date,
    required int appointmentTypeId,
  }) async {
    try {
      print('🧪 Testing Available Slots API Response Structure...');
      print('🧪 Date: $date, Appointment Type ID: $appointmentTypeId');

      final queryParameters = <String, dynamic>{
        'date': date,
        'appointment_type_id': appointmentTypeId,
      };

      final response = await _apiService.get(
        ApiConfig.availabilitySlotsEndpoint,
        queryParameters: queryParameters,
      );

      print('🧪 Full API Response:');
      print(response);

      print('🧪 Response keys: ${response.keys.toList()}');

      if (response['data'] != null) {
        print('🧪 Data keys: ${(response['data'] as Map).keys.toList()}');

        if (response['data']['available_slots'] != null) {
          final slots = response['data']['available_slots'] as List;
          print('🧪 Available slots count: ${slots.length}');

          if (slots.isNotEmpty) {
            print('🧪 First slot structure:');
            print(slots.first);
            print('🧪 First slot keys: ${(slots.first as Map).keys.toList()}');
          }
        }
      }

      print('�� Test completed');
    } catch (e) {
      print('❌ Test failed: $e');
    }
  }

  /// Get all time slots for a day (both available and booked)
  Future<DayAvailability> getAllTimeSlots({
    required String date,
    required int appointmentTypeId,
  }) async {
    try {
      print('🔍 AppointmentsService: Getting all time slots for $date');

      // First, get available slots from the API
      final availableSlots = await getAvailableSlots(
        date: date,
        appointmentTypeId: appointmentTypeId,
      );

      // Generate all possible time slots for the day (business hours: 8 AM to 6 PM)
      final allSlots = <AppointmentSlot>[];
      final businessHours = <String>[
        '08:00',
        '08:15',
        '08:30',
        '08:45',
        '09:00',
        '09:15',
        '09:30',
        '09:45',
        '10:00',
        '10:15',
        '10:30',
        '10:45',
        '11:00',
        '11:15',
        '11:30',
        '11:45',
        '12:00',
        '12:15',
        '12:30',
        '12:45',
        '13:00',
        '13:15',
        '13:30',
        '13:45',
        '14:00',
        '14:15',
        '14:30',
        '14:45',
        '15:00',
        '15:15',
        '15:30',
        '15:45',
        '16:00',
        '16:15',
        '16:30',
        '16:45',
        '17:00',
        '17:15',
        '17:30',
        '17:45',
      ];

      // Get appointment type to determine duration
      final appointmentTypes = await getAppointmentTypes();
      final appointmentType = appointmentTypes.firstWhere(
        (type) => type.id == appointmentTypeId,
        orElse: () => appointmentTypes.first,
      );

      final durationMinutes = appointmentType.durationMinutes;

      // Create all possible slots
      for (final startTime in businessHours) {
        final startTimeObj = _parseTime(startTime);
        final endTimeObj = _addMinutes(startTimeObj, durationMinutes);
        final endTime = _formatTime(endTimeObj);

        // Check if this slot is in the available slots list
        final isAvailable = availableSlots.any(
            (slot) => slot.startTime == startTime && slot.endTime == endTime);

        final slot = AppointmentSlot(
          id: 'slot_${startTime}_$endTime',
          date: date,
          startTime: startTime,
          endTime: endTime,
          formattedTime:
              '${_formatTimeForDisplay(startTime)} - ${_formatTimeForDisplay(endTime)}',
          isAvailable: isAvailable,
          appointmentTypeId: appointmentTypeId,
          dietitianId: null,
          dietitianName: null,
          dietitianSpecialty: null,
          reason: isAvailable ? null : 'Time slot already booked',
        );

        allSlots.add(slot);
      }

      // Group slots by time period
      final slotsByPeriod = <String, List<AppointmentSlot>>{};
      for (final slot in allSlots) {
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

      // Get day info
      final dateObj = DateTime.parse(date);
      final dayNames = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      final dayName = dayNames[dateObj.weekday - 1];
      final formattedDate = '${dateObj.day}/${dateObj.month}/${dateObj.year}';

      return DayAvailability(
        date: date,
        formattedDate: formattedDate,
        dayName: dayName,
        slots: allSlots,
        totalSlots: allSlots.length,
        slotsByPeriod: slotsByPeriod,
      );
    } catch (e) {
      print('❌ AppointmentsService.getAllTimeSlots error: $e');
      throw ApiException('Failed to get all time slots: $e');
    }
  }

  /// Parse time string to TimeOfDay
  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Format TimeOfDay to string
  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Add minutes to TimeOfDay
  TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
    final totalMinutes = time.hour * 60 + time.minute + minutes;
    final newHour = totalMinutes ~/ 60;
    final newMinute = totalMinutes % 60;
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  /// Format time for display (12-hour format)
  String _formatTimeForDisplay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    if (hour == 0) {
      return '12:${minute.toString().padLeft(2, '0')} AM';
    } else if (hour < 12) {
      return '$hour:${minute.toString().padLeft(2, '0')} AM';
    } else if (hour == 12) {
      return '12:${minute.toString().padLeft(2, '0')} PM';
    } else {
      return '${hour - 12}:${minute.toString().padLeft(2, '0')} PM';
    }
  }
}
