import 'package:get/get.dart';
import '../../../core/exceptions/api_exception.dart';
import '../../../core/services/error_handler_service.dart';
import '../services/appointments_service.dart';
import '../models/appointment_model.dart';
import '../models/appointment_type_api.dart';
import '../models/dietitian_info.dart';
import '../models/availability_models.dart';

/// Appointments Controller
///
/// Manages appointment-related state and business logic including:
/// - Appointment types management
/// - Dietitian info management
/// - Appointment booking
/// - Slot management
/// - History management
/// - Status updates
class AppointmentsController extends GetxController {
  final AppointmentsService _appointmentsService;

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<Appointment> appointments = <Appointment>[].obs;
  final RxList<AppointmentSlot> availableSlots = <AppointmentSlot>[].obs;
  final RxList<AppointmentTypeAPI> appointmentTypes =
      <AppointmentTypeAPI>[].obs;
  final Rx<DietitianInfo?> dietitianInfo = Rx<DietitianInfo?>(null);
  final Rx<Appointment?> selectedAppointment = Rx<Appointment?>(null);
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<AppointmentTypeAPI?> selectedAppointmentType =
      Rx<AppointmentTypeAPI?>(null);
  final RxBool hasUpcomingAppointments = false.obs;

  // Form variables
  final RxString notes = ''.obs;
  final RxString selectedTime = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool hasMorePages = false.obs;

  // Filters
  final Rx<AppointmentStatus?> statusFilter = Rx<AppointmentStatus?>(null);
  final Rx<DateTime?> startDateFilter = Rx<DateTime?>(null);
  final Rx<DateTime?> endDateFilter = Rx<DateTime?>(null);

  AppointmentsController(this._appointmentsService);

  @override
  void onInit() {
    super.onInit();
    initializeAppointmentSystem();
  }

  /// Initialize appointment system - CRITICAL SEQUENCE
  Future<void> initializeAppointmentSystem() async {
    try {
      isLoading.value = true;
      error.value = '';

      print('📅 AppointmentsController: Initializing appointment system...');

      // 1. Get appointment types FIRST
      final types = await _appointmentsService.getAppointmentTypes();
      appointmentTypes.assignAll(types);

      // 2. Get dietitian info
      final dietitian = await _appointmentsService.getDietitianInfo();
      dietitianInfo.value = dietitian;

      // 3. Load upcoming appointments
      await loadUpcomingAppointments();

      print(
          '✅ AppointmentsController: Appointment system initialized successfully');
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsController.initializeAppointmentSystem API error: ${e.message}');
      error.value = e.message;
    } catch (e) {
      print(
          '❌ AppointmentsController.initializeAppointmentSystem unexpected error: $e');
      error.value = 'Failed to initialize appointment system: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Load upcoming appointments
  Future<void> loadUpcomingAppointments() async {
    try {
      isLoading.value = true;
      error.value = '';

      print('📅 AppointmentsController: Loading upcoming appointments...');

      final nextAppointment = await _appointmentsService.getNextAppointment();

      if (nextAppointment != null) {
        appointments.assignAll([nextAppointment]);
        hasUpcomingAppointments.value = true;
      } else {
        appointments.clear();
        hasUpcomingAppointments.value = false;
      }

      print('✅ AppointmentsController: Loaded upcoming appointments');
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsController.loadUpcomingAppointments API error: ${e.message}');
      error.value = e.message;
    } catch (e) {
      print(
          '❌ AppointmentsController.loadUpcomingAppointments unexpected error: $e');
      error.value = 'Failed to load upcoming appointments: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Load appointment history with pagination
  Future<void> loadAppointmentHistory({
    bool refresh = false,
    int page = 1,
  }) async {
    try {
      if (refresh) {
        isLoading.value = true;
        currentPage.value = 1;
      } else {
        isLoading.value = true;
      }

      error.value = '';

      print('📅 AppointmentsController: Loading appointment history...');

      final history = await _appointmentsService.getAppointmentHistory(
        page: page,
        perPage: 10,
        status: statusFilter.value,
        startDate: startDateFilter.value,
        endDate: endDateFilter.value,
      );

      if (refresh || page == 1) {
        appointments.assignAll(history.appointments);
      } else {
        appointments.addAll(history.appointments);
      }

      currentPage.value = history.pagination.currentPage;
      totalPages.value = history.pagination.totalPages;
      hasMorePages.value = history.pagination.hasNextPage;

      print(
          '✅ AppointmentsController: Loaded ${history.appointments.length} appointments');
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsController.loadAppointmentHistory API error: ${e.message}');
      error.value = e.message;
    } catch (e) {
      print(
          '❌ AppointmentsController.loadAppointmentHistory unexpected error: $e');
      error.value = 'Failed to load appointment history: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more appointments (pagination)
  Future<void> loadMoreAppointments() async {
    if (hasMorePages.value && !isLoading.value) {
      await loadAppointmentHistory(page: currentPage.value + 1);
    }
  }

  /// Get available slots for a specific date and appointment type
  Future<void> getAvailableSlots({
    required String date,
    required int appointmentTypeId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      print('📅 AppointmentsController: Getting available slots...');

      final slots = await _appointmentsService.getAvailableSlots(
        date: date,
        appointmentTypeId: appointmentTypeId,
      );

      availableSlots.assignAll(slots);

      print(
          '✅ AppointmentsController: Retrieved ${slots.length} available slots');
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsController.getAvailableSlots API error: ${e.message}');
      ErrorHandlerService.handleApiError(e, context: 'getting available slots');
      error.value = e.message;
    } catch (e) {
      print('❌ AppointmentsController.getAvailableSlots unexpected error: $e');
      ErrorHandlerService.handleApiError(e, context: 'getting available slots');
      error.value = 'Failed to get available slots: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Get date range availability for calendar
  Future<List<DateRangeAvailability>> getDateRangeAvailability({
    required String startDate,
    required String endDate,
    required int appointmentTypeId,
  }) async {
    try {
      print('📅 AppointmentsController: Getting date range availability...');

      final availability = await _appointmentsService.getDateRangeAvailability(
        startDate: startDate,
        endDate: endDate,
        appointmentTypeId: appointmentTypeId,
      );

      print(
          '✅ AppointmentsController: Retrieved ${availability.length} date availability items');
      return availability;
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsController.getDateRangeAvailability API error: ${e.message}');
      ErrorHandlerService.handleApiError(e,
          context: 'getting date range availability');
      error.value = e.message;
      rethrow;
    } catch (e) {
      print(
          '❌ AppointmentsController.getDateRangeAvailability unexpected error: $e');
      ErrorHandlerService.handleApiError(e,
          context: 'getting date range availability');
      error.value = 'Failed to get date range availability: $e';
      rethrow;
    }
  }

  /// Check slot availability
  Future<bool> checkSlotAvailability({
    required String date,
    required String startTime,
    required int appointmentTypeId,
  }) async {
    try {
      print('📅 AppointmentsController: Checking slot availability...');

      final availability = await _appointmentsService.checkSlotAvailability(
        date: date,
        startTime: startTime,
        appointmentTypeId: appointmentTypeId,
      );

      print('✅ AppointmentsController: Slot availability checked');

      // If slot is not available, set the reason as error message
      if (!availability.isAvailable) {
        String reason = availability.reason ?? 'Time slot is not available';
        error.value = reason;
        print('❌ AppointmentsController: Slot not available - $reason');
      }

      return availability.isAvailable;
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsController.checkSlotAvailability API error: ${e.message}');
      ErrorHandlerService.handleAppointmentError(e);
      error.value = e.message;
      return false;
    } catch (e) {
      print(
          '❌ AppointmentsController.checkSlotAvailability unexpected error: $e');
      ErrorHandlerService.handleAppointmentError(e);
      error.value = 'Failed to check slot availability: $e';
      return false;
    }
  }

  /// Book a new appointment with slot availability check
  Future<bool> bookAppointment() async {
    print('🔍 AppointmentsController: bookAppointment() called');
    print('🔍 AppointmentsController: Current state:');
    print('  - dietitianInfo: ${dietitianInfo.value?.name ?? "null"}');
    print(
        '  - selectedAppointmentType: ${selectedAppointmentType.value?.name ?? "null"}');
    print('  - selectedDate: ${selectedDate.value}');
    print('  - selectedTime: ${selectedTime.value}');
    print('  - notes: ${notes.value}');

    try {
      if (dietitianInfo.value == null ||
          selectedAppointmentType.value == null) {
        print('❌ AppointmentsController: Missing required data');
        print('  - dietitianInfo is null: ${dietitianInfo.value == null}');
        print(
            '  - selectedAppointmentType is null: ${selectedAppointmentType.value == null}');
        error.value =
            'Please select appointment type and ensure dietitian info is loaded';
        return false;
      }

      isLoading.value = true;
      error.value = '';

      print('📅 AppointmentsController: Booking appointment...');

      print('🔍 AppointmentsController: Checking slot availability...');
      // Check slot availability before booking
      final isSlotAvailable = await checkSlotAvailability(
        date: selectedDate.value.toIso8601String().split('T')[0],
        startTime: selectedTime.value,
        appointmentTypeId: selectedAppointmentType.value!.id,
      );

      print(
          '🔍 AppointmentsController: Slot availability result: $isSlotAvailable');
      if (!isSlotAvailable) {
        print('❌ AppointmentsController: Slot is not available');
        // Don't show warning here since we'll handle it in the view
        // The error message is already set in checkSlotAvailability
        return false;
      }
      print(
          '✅ AppointmentsController: Slot is available, proceeding with booking');

      final appointment = await _appointmentsService.bookAppointment(
        dietitianId: dietitianInfo.value!.id,
        appointmentTypeId: selectedAppointmentType.value!.id,
        appointmentDate: selectedDate.value.toIso8601String().split('T')[0],
        startTime: selectedTime.value,
        notes: notes.value.isNotEmpty ? notes.value : null,
      );

      // Add to appointments list
      appointments.insert(0, appointment);
      hasUpcomingAppointments.value = true;

      // Clear form
      clearBookingForm();

      // Refresh appointments list
      await loadUpcomingAppointments();

      // Show success message
      ErrorHandlerService.showSuccess('Appointment booked successfully!');

      print('✅ AppointmentsController: Appointment booked successfully');
      return true;
    } on ApiException catch (e) {
      print('❌ AppointmentsController.bookAppointment API error: ${e.message}');
      ErrorHandlerService.handleAppointmentError(e);
      error.value = e.message;
      return false;
    } catch (e) {
      print('❌ AppointmentsController.bookAppointment unexpected error: $e');
      ErrorHandlerService.handleAppointmentError(e);
      error.value = 'Failed to book appointment: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancel appointment
  Future<bool> cancelAppointment(int appointmentId, String reason) async {
    try {
      isLoading.value = true;
      error.value = '';

      print('📅 AppointmentsController: Cancelling appointment...');

      await _appointmentsService.cancelAppointmentWithReason(
          appointmentId, reason);

      // Remove from appointments list
      appointments
          .removeWhere((appointment) => appointment.id == appointmentId);
      hasUpcomingAppointments.value = appointments.isNotEmpty;

      // Refresh appointments list
      await loadUpcomingAppointments();

      // Show success message
      ErrorHandlerService.showSuccess('Appointment cancelled successfully!');

      print('✅ AppointmentsController: Appointment cancelled successfully');
      return true;
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsController.cancelAppointment API error: ${e.message}');
      error.value = e.message;
      return false;
    } catch (e) {
      print('❌ AppointmentsController.cancelAppointment unexpected error: $e');
      error.value = 'Failed to cancel appointment: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get appointment details
  Future<Appointment?> getAppointmentDetails(int appointmentId) async {
    try {
      isLoading.value = true;
      error.value = '';

      print('📅 AppointmentsController: Getting appointment details...');

      final appointment =
          await _appointmentsService.getAppointmentDetails(appointmentId);
      selectedAppointment.value = appointment;

      print('✅ AppointmentsController: Retrieved appointment details');
      return appointment;
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsController.getAppointmentDetails API error: ${e.message}');
      error.value = e.message;
      return null;
    } catch (e) {
      print(
          '❌ AppointmentsController.getAppointmentDetails unexpected error: $e');
      error.value = 'Failed to get appointment details: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get appointment statistics
  Future<AppointmentStatistics?> getAppointmentStatistics() async {
    try {
      print('📅 AppointmentsController: Getting appointment statistics...');

      final statistics = await _appointmentsService.getAppointmentStatistics();

      print('✅ AppointmentsController: Retrieved appointment statistics');
      return statistics;
    } on ApiException catch (e) {
      print(
          '❌ AppointmentsController.getAppointmentStatistics API error: ${e.message}');
      error.value = e.message;
      return null;
    } catch (e) {
      print(
          '❌ AppointmentsController.getAppointmentStatistics unexpected error: $e');
      error.value = 'Failed to get appointment statistics: $e';
      return null;
    }
  }

  /// Set selected appointment type
  void setSelectedAppointmentType(AppointmentTypeAPI type) {
    selectedAppointmentType.value = type;
    print('📅 AppointmentsController: Selected appointment type: ${type.name}');
  }

  /// Set selected date
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    print(
        '📅 AppointmentsController: Selected date: ${date.toIso8601String().split('T')[0]}');
  }

  /// Set selected time
  void setSelectedTime(String time) {
    selectedTime.value = time;
    print('📅 AppointmentsController: Selected time: $time');
  }

  /// Clear booking form
  void clearBookingForm() {
    selectedAppointmentType.value = null;
    selectedDate.value = DateTime.now();
    selectedTime.value = '';
    notes.value = '';
    availableSlots.clear();
  }

  /// Set status filter
  void setStatusFilter(AppointmentStatus? status) {
    statusFilter.value = status;
    loadAppointmentHistory(refresh: true);
  }

  /// Set date range filter
  void setDateRangeFilter(DateTime? startDate, DateTime? endDate) {
    startDateFilter.value = startDate;
    endDateFilter.value = endDate;
    loadAppointmentHistory(refresh: true);
  }

  /// Clear filters
  void clearFilters() {
    statusFilter.value = null;
    startDateFilter.value = null;
    endDateFilter.value = null;
    loadAppointmentHistory(refresh: true);
  }

  /// Refresh data
  Future<void> refresh() async {
    await initializeAppointmentSystem();
  }
}
