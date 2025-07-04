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
          final slot = AppointmentSlot.fromJson(slotsData[i]);
          slots.add(slot);
          print('📋 Successfully parsed slot $i: ${slot.formattedTime}');
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

      final response =
          await _apiService.post(ApiConfig.appointmentsEndpoint, data: data);

      print('✅ AppointmentsService: Appointment booked successfully');
      return Appointment.fromJson(response['appointment']);
    } on ApiException catch (e) {
      print('❌ AppointmentsService.bookAppointment API error: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ AppointmentsService.bookAppointment unexpected error: $e');
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
      return Appointment.fromJson(response['appointment']);
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

      if (response['appointment'] != null) {
        print('✅ AppointmentsService: Retrieved next appointment');
        return Appointment.fromJson(response['appointment']);
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

      print('🧪 Test completed');
    } catch (e) {
      print('❌ Test failed: $e');
    }
  }
}
