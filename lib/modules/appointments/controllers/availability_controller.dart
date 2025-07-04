import 'package:get/get.dart';
import '../services/appointments_service.dart';
import '../models/availability_models.dart';
import '../models/appointment_type_api.dart';
import 'appointments_controller.dart';

/// Availability Controller
///
/// Manages availability selection state and business logic including:
/// - Week calendar navigation
/// - Day time slot loading
/// - Selection state management
/// - API integration for availability data
class AvailabilityController extends GetxController {
  final AppointmentsService _appointmentsService;

  // Observable state
  final Rx<AvailabilitySelection> selection = AvailabilitySelection().obs;
  final RxInt currentWeekOffset = 0.obs;
  final Rx<AppointmentTypeAPI?> selectedAppointmentType =
      Rx<AppointmentTypeAPI?>(null);
  final RxBool isLoadingWeek = false.obs;
  final RxBool isLoadingDay = false.obs;
  final RxString weekError = ''.obs;
  final RxString dayError = ''.obs;

  // Separate observable variables for better reactivity
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<AppointmentSlot?> selectedSlot = Rx<AppointmentSlot?>(null);
  final Rx<DayAvailability?> selectedDay = Rx<DayAvailability?>(null);

  // Cache for performance
  final Map<String, DayAvailability> _dayCache = {};
  final Map<int, WeekAvailability> _weekCache = {};

  AvailabilityController(this._appointmentsService);

  @override
  void onInit() {
    super.onInit();
    // Don't load current week until appointment type is selected
    // This will be triggered when user selects an appointment type
  }

  /// Load current week availability
  Future<void> loadCurrentWeek() async {
    await loadWeekAvailability(0);
  }

  /// Load week availability for specific offset
  Future<void> loadWeekAvailability(int weekOffset) async {
    if (selectedAppointmentType.value == null) {
      weekError.value = 'Please select an appointment type first';
      return;
    }

    // Check cache first
    if (_weekCache.containsKey(weekOffset)) {
      final cachedWeek = _weekCache[weekOffset]!;
      selection.update((val) => val?.copyWith(
            currentWeek: cachedWeek,
            isLoading: false,
            error: null,
          ));
      currentWeekOffset.value = weekOffset;
      return;
    }

    try {
      isLoadingWeek.value = true;
      weekError.value = '';

      final now = DateTime.now();
      final weekStart = now.add(Duration(days: weekOffset * 7));
      final weekEnd = weekStart.add(const Duration(days: 6));

      final availability = await _appointmentsService.getDateRangeAvailability(
        startDate: weekStart.toIso8601String().split('T')[0],
        endDate: weekEnd.toIso8601String().split('T')[0],
        appointmentTypeId: selectedAppointmentType.value!.id,
      );

      // Convert to WeekAvailability
      final weekAvailability = WeekAvailability(
        weekStart: weekStart,
        weekEnd: weekEnd,
        days: availability,
        totalAvailableSlots:
            availability.fold(0, (sum, day) => sum + day.availableSlots),
        totalSlots: availability.fold(0, (sum, day) => sum + day.totalSlots),
      );

      // Cache the result
      _weekCache[weekOffset] = weekAvailability;

      selection.update((val) => val?.copyWith(
            currentWeek: weekAvailability,
            isLoading: false,
            error: null,
          ));
      currentWeekOffset.value = weekOffset;

      print(
          '✅ AvailabilityController: Loaded week availability for offset $weekOffset');
      print('📅 Week data: ${weekAvailability.days.length} days loaded');
      for (final day in weekAvailability.days) {
        print(
            '  - ${day.dayName} (${day.date}): ${day.hasAvailability ? "Available" : "Not Available"} (${day.slotsCount} slots)');
      }
    } catch (e) {
      print('❌ AvailabilityController.loadWeekAvailability error: $e');
      weekError.value = 'Failed to load week availability: $e';
      selection.update((val) => val?.copyWith(
            isLoading: false,
            error: weekError.value,
          ));
    } finally {
      isLoadingWeek.value = false;
    }
  }

  /// Load next week
  Future<void> loadNextWeek() async {
    await loadWeekAvailability(currentWeekOffset.value + 1);
  }

  /// Load previous week
  Future<void> loadPreviousWeek() async {
    if (currentWeekOffset.value > 0) {
      await loadWeekAvailability(currentWeekOffset.value - 1);
    }
  }

  /// Load day availability for specific date
  Future<void> loadDayAvailability(String date) async {
    print(
        '🚀 AvailabilityController.loadDayAvailability: Starting for date $date');
    print(
        '🚀 AvailabilityController.loadDayAvailability: selectedAppointmentType=${selectedAppointmentType.value?.name}');

    if (selectedAppointmentType.value == null) {
      print(
          '❌ AvailabilityController.loadDayAvailability: No appointment type selected');
      dayError.value = 'Please select an appointment type first';
      return;
    }

    final cacheKey = '${date}_${selectedAppointmentType.value!.id}';
    print(
        '🚀 AvailabilityController.loadDayAvailability: Cache key = $cacheKey');

    // Check cache first
    if (_dayCache.containsKey(cacheKey)) {
      print('🚀 AvailabilityController.loadDayAvailability: Using cached data');
      final cachedDay = _dayCache[cacheKey]!;
      setSelectedDate(DateTime.parse(date));
      selectedDay.value = cachedDay;
      selection.update((val) => val?.copyWith(
            selectedDay: cachedDay,
            selectedDate: DateTime.parse(date),
            isLoading: false,
            error: null,
          ));
      return;
    }

    try {
      isLoadingDay.value = true;
      dayError.value = '';

      print('🌐 AvailabilityController: Calling API for slots on $date');
      print('🌐 API Endpoint: /availability/slots');
      print(
          '🌐 Parameters: date=$date, appointment_type_id=${selectedAppointmentType.value!.id}');

      List<AppointmentSlot> slots = [];

      try {
        // Try to get slots from API
        slots = await _appointmentsService.getAvailableSlots(
          date: date,
          appointmentTypeId: selectedAppointmentType.value!.id,
        );
        print(
            '✅ AvailabilityController: Received ${slots.length} slots from API');

        // Test the API response structure
        await _appointmentsService.testAvailableSlotsResponse(
          date: date,
          appointmentTypeId: selectedAppointmentType.value!.id,
        );
      } catch (apiError) {
        print('⚠️ API call failed, using fallback: $apiError');

        // Fallback: Get slot count from week data and generate mock slots
        final week = selection.value.currentWeek;
        if (week != null) {
          final dayData = week.days.firstWhere(
            (d) => d.date == date,
            orElse: () => throw Exception('Date $date not found in week data'),
          );

          if (dayData.availableSlots > 0) {
            print(
                '🔄 Generating ${dayData.availableSlots} mock slots for $date');
            slots = _generateMockSlots(date, dayData.availableSlots,
                selectedAppointmentType.value!.id);
          } else {
            print('⚠️ No available slots for $date');
            dayError.value = 'No available slots for this date';
            return;
          }
        } else {
          throw Exception('No week data available for fallback');
        }
      }

      if (slots.isNotEmpty) {
        print(
            '📋 First slot: ${slots.first.formattedTime} - ${slots.first.isAvailable}');
        print(
            '📋 Last slot: ${slots.last.formattedTime} - ${slots.last.isAvailable}');
        print('📋 Total slots received: ${slots.length}');

        // Debug: Print first few slots in detail
        for (int i = 0; i < slots.length && i < 3; i++) {
          final slot = slots[i];
          print(
              '📋 Slot $i: ${slot.startTime}-${slot.endTime} (${slot.formattedTime}) - Available: ${slot.isAvailable}');
        }
      } else {
        print('⚠️ No slots available for $date');
        dayError.value = 'No available slots for this date';
        return;
      }

      // Convert to DayAvailability
      final dayAvailability = DayAvailability.fromJson({
        'date': date,
        'formatted_date': _formatDate(date),
        'day_name': _getDayName(date),
        'available_slots': slots.map((slot) => slot.toJson()).toList(),
        'total_slots': slots.length,
      });

      // Cache the result
      _dayCache[cacheKey] = dayAvailability;

      final parsedDate = DateTime.parse(date);
      setSelectedDate(parsedDate);
      selectedDay.value = dayAvailability;

      selection.update((val) => val?.copyWith(
            selectedDay: dayAvailability,
            selectedDate: parsedDate,
            isLoading: false,
            error: null,
          ));

      print('✅ AvailabilityController: Loaded day availability for $date');
      print('✅ Selected day slots: ${dayAvailability.slots.length}');
      print('✅ Selected day total slots: ${dayAvailability.totalSlots}');
    } catch (e) {
      print('❌ AvailabilityController.loadDayAvailability error: $e');
      print('❌ Error type: ${e.runtimeType}');
      dayError.value = 'Failed to load day availability: $e';
      selection.update((val) => val?.copyWith(
            isLoading: false,
            error: dayError.value,
          ));
    } finally {
      isLoadingDay.value = false;
    }
  }

  /// Generate mock slots for a given date
  List<AppointmentSlot> _generateMockSlots(
      String date, int slotCount, int appointmentTypeId) {
    final slots = <AppointmentSlot>[];
    final startHour = 8; // Start at 8 AM
    final endHour = 18; // End at 6 PM
    final slotDuration = 30; // 30 minutes per slot

    for (int i = 0; i < slotCount && i < ((endHour - startHour) * 2); i++) {
      final hour = startHour + (i ~/ 2);
      final minute = (i % 2) * 30;
      final startTime =
          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      final endMinute = minute + slotDuration;
      final endHour = hour + (endMinute ~/ 60);
      final endMinuteFinal = endMinute % 60;
      final endTime =
          '${endHour.toString().padLeft(2, '0')}:${endMinuteFinal.toString().padLeft(2, '0')}';

      final slot = AppointmentSlot(
        id: 'slot_${date}_$i',
        date: date,
        startTime: startTime,
        endTime: endTime,
        formattedTime:
            '${hour > 12 ? hour - 12 : hour}:${minute.toString().padLeft(2, '0')} ${hour >= 12 ? 'PM' : 'AM'}',
        isAvailable: true,
        appointmentTypeId: appointmentTypeId,
      );

      slots.add(slot);
    }

    return slots;
  }

  /// Select a time slot
  void selectTimeSlot(AppointmentSlot slot) {
    selectedSlot.value = slot;
    selection.update((val) => val?.copyWith(
          selectedSlot: slot,
        ));
    print('✅ AvailabilityController: Selected time slot ${slot.formattedTime}');
  }

  /// Clear time slot selection
  void clearTimeSlotSelection() {
    selectedSlot.value = null;
    selection.update((val) => val?.copyWith(
          selectedSlot: null,
        ));
  }

  /// Clear date selection
  void clearDateSelection() {
    setSelectedDate(null);
    selectedDay.value = null;
    selectedSlot.value = null;
    selection.update((val) => val?.copyWith(
          selectedDate: null,
          selectedDay: null,
          selectedSlot: null,
        ));
  }

  /// Clear all selections
  void clearAllSelections() {
    setSelectedDate(null);
    selectedDay.value = null;
    selectedSlot.value = null;
    selection.update((val) => val?.copyWith(
          selectedDate: null,
          selectedSlot: null,
          selectedDay: null,
        ));
  }

  /// Set appointment type
  void setAppointmentType(AppointmentTypeAPI type) {
    selectedAppointmentType.value = type;
    // Clear cache when appointment type changes
    _dayCache.clear();
    _weekCache.clear();
    // Reload current week with new type
    loadCurrentWeek();
    print('✅ AvailabilityController: Set appointment type to ${type.name}');
  }

  /// Check if a date is selectable
  bool isDateSelectable(String date) {
    print('🔍 AvailabilityController.isDateSelectable: Checking date $date');

    final dateObj = DateTime.parse(date);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(dateObj.year, dateObj.month, dateObj.day);

    // Check if date is not in the past
    if (!dateToCheck.isAfter(today.subtract(const Duration(days: 1)))) {
      print('🔍 Date $date is in the past - not selectable');
      return false;
    }

    // Check if date has availability
    final week = selection.value.currentWeek;
    if (week == null) {
      print('🔍 No week data available - date $date not selectable');
      return false;
    }

    final day = week.days.firstWhere(
      (d) => d.date == date,
      orElse: () {
        print('🔍 Date $date not found in week data');
        return DateRangeAvailability(
          date: date,
          slotsCount: 0,
          hasAvailability: false,
          formattedDate: _formatDate(date),
          dayName: _getDayName(date),
          availableSlots: 0,
          totalSlots: 0,
          status: AvailabilityStatus.unavailable,
        );
      },
    );

    final isSelectable = day.hasAvailability && day.availableSlots > 0;
    print(
        '🔍 Date $date: hasAvailability=${day.hasAvailability}, availableSlots=${day.availableSlots}, totalSlots=${day.totalSlots}, isSelectable=$isSelectable');
    return isSelectable;
  }

  /// Get availability status for a date
  AvailabilityStatus getAvailabilityStatus(String date) {
    if (!isDateSelectable(date)) {
      return AvailabilityStatus.past;
    }

    final week = selection.value.currentWeek;
    if (week == null) return AvailabilityStatus.unavailable;

    final day = week.days.firstWhere(
      (d) => d.date == date,
      orElse: () => DateRangeAvailability(
        date: date,
        slotsCount: 0,
        hasAvailability: false,
        formattedDate: _formatDate(date),
        dayName: _getDayName(date),
        availableSlots: 0,
        totalSlots: 0,
        status: AvailabilityStatus.unavailable,
      ),
    );

    return day.status;
  }

  /// Get formatted date string
  String _formatDate(String date) {
    final dateObj = DateTime.parse(date);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCheck = DateTime(dateObj.year, dateObj.month, dateObj.day);

    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${dateObj.day}/${dateObj.month}/${dateObj.year}';
    }
  }

  /// Get day name
  String _getDayName(String date) {
    final dateObj = DateTime.parse(date);
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[dateObj.weekday - 1];
  }

  /// Get current week dates
  List<DateTime> getCurrentWeekDates() {
    final now = DateTime.now();
    final weekStart = now.add(Duration(days: currentWeekOffset.value * 7));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final dates = <DateTime>[];
    for (int i = 0; i < 7; i++) {
      dates.add(weekStart.add(Duration(days: i)));
    }
    return dates;
  }

  /// Get week summary
  String getWeekSummary() {
    final week = selection.value.currentWeek;
    if (week == null) return 'No availability data';

    return '${week.totalAvailableSlots} slots available this week';
  }

  /// Validate selection for booking
  bool get canProceedToBooking {
    return selectedDate.value != null &&
        selectedSlot.value != null &&
        selectedAppointmentType.value != null;
  }

  /// Get booking summary
  String get bookingSummary {
    if (!canProceedToBooking) return 'Please select date and time';

    final date = selectedDate.value!;
    final slot = selectedSlot.value!;
    final type = selectedAppointmentType.value!;

    return '${type.name} on ${_formatDate(date.toIso8601String().split('T')[0])} at ${slot.formattedTime}';
  }

  /// Clear cache (useful for testing or memory management)
  void clearCache() {
    _dayCache.clear();
    _weekCache.clear();
    print('✅ AvailabilityController: Cache cleared');
  }

  /// Sync selected date to AppointmentsController
  void _syncToAppointmentsController(DateTime? date) {
    try {
      final appointmentsController = Get.find<AppointmentsController>();
      if (date != null) {
        appointmentsController.selectedDate.value = date;
        print(
            '🔄 AvailabilityController: Synced date to AppointmentsController');
      } else {
        appointmentsController.selectedDate.value = DateTime.now();
        print(
            '🔄 AvailabilityController: Synced null date to AppointmentsController (using now)');
      }
    } catch (e) {
      print(
          '⚠️ AvailabilityController: Could not sync to AppointmentsController: $e');
    }
  }

  /// Set selected date
  void setSelectedDate(DateTime? date) {
    print(
        '🔍 AvailabilityController.setSelectedDate: Setting date to ${date?.toIso8601String().split('T')[0]}');
    selectedDate.value = date;
    selection.update((val) => val?.copyWith(
          selectedDate: date,
        ));

    if (date != null) {
      print(
          '🔍 AvailabilityController.setSelectedDate: Date set, selectedDay.value is ${selectedDay.value?.date}');
    }
  }
}
