import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/appointments_controller.dart';
import '../controllers/availability_controller.dart';
import '../services/appointments_service.dart';
import '../widgets/appointment_form.dart';
import '../widgets/appointment_slot_picker.dart';
import '../widgets/appointment_type_selector.dart';
import '../widgets/availability_flow.dart';
import '../models/availability_models.dart';
import '../../../core/theme/app_theme.dart';

/// Book Appointment View
///
/// A comprehensive screen for booking new appointments using the new availability flow system
class BookAppointmentView extends GetView<AppointmentsController> {
  const BookAppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure service is available first
    if (!Get.isRegistered<AppointmentsService>()) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Initialize availability controller safely
    final availabilityController = Get.put(
      AvailabilityController(Get.find<AppointmentsService>()),
    );

    // Set initial appointment type if available and none selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (availabilityController.selectedAppointmentType.value == null &&
          controller.appointmentTypes.isNotEmpty) {
        availabilityController
            .setAppointmentType(controller.appointmentTypes.first);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitConfirmation(context),
        ),
        actions: [
          // Clear all selections button
          Obx(() {
            if (availabilityController.selection.value.hasSelection) {
              return IconButton(
                onPressed: () =>
                    _showClearConfirmation(context, availabilityController),
                icon: const Icon(Icons.clear_all),
                tooltip: 'Clear All Selections',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Step indicator
            _buildStepIndicator(availabilityController),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(),
                    const SizedBox(height: 24),

                    // Availability Flow
                    AvailabilityFlow(
                      appointmentTypes: controller.appointmentTypes,
                      onSelectionComplete: (selection) {
                        _handleSelectionComplete(selection);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Appointment Form (shown after selection)
                    Obx(() {
                      if (!availabilityController.canProceedToBooking) {
                        return const SizedBox.shrink();
                      }
                      return _buildBookingForm();
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Build step indicator
  Widget _buildStepIndicator(AvailabilityController availabilityController) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            border: Border(
              bottom: BorderSide(color: AppTheme.border),
            ),
          ),
          child: Row(
            children: [
              // Step 1: Appointment Type
              _buildStepItem(
                step: 1,
                title: 'Type',
                isActive:
                    availabilityController.selectedAppointmentType.value !=
                        null,
                isCompleted:
                    availabilityController.selectedAppointmentType.value !=
                        null,
              ),
              _buildStepConnector(
                  availabilityController.selectedAppointmentType.value != null),

              // Step 2: Date Selection
              _buildStepItem(
                step: 2,
                title: 'Date',
                isActive: availabilityController.selectedDate.value != null,
                isCompleted: availabilityController.selectedDate.value != null,
              ),
              _buildStepConnector(
                  availabilityController.selectedDate.value != null),

              // Step 3: Time Selection
              _buildStepItem(
                step: 3,
                title: 'Time',
                isActive: availabilityController.selectedSlot.value != null,
                isCompleted: availabilityController.selectedSlot.value != null,
              ),
              _buildStepConnector(
                  availabilityController.selectedSlot.value != null),

              // Step 4: Confirmation
              _buildStepItem(
                step: 4,
                title: 'Confirm',
                isActive: availabilityController.canProceedToBooking,
                isCompleted: false,
              ),
            ],
          ),
        ));
  }

  /// Build individual step item
  Widget _buildStepItem({
    required int step,
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppTheme.success
                  : isActive
                      ? AppTheme.primary
                      : AppTheme.textMuted.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text(
                      step.toString(),
                      style: TextStyle(
                        color: isActive ? Colors.white : AppTheme.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppTheme.primary : AppTheme.textMuted,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// Build step connector
  Widget _buildStepConnector(bool isCompleted) {
    return Container(
      width: 20,
      height: 2,
      color: isCompleted ? AppTheme.success : AppTheme.border,
    );
  }

  /// Show exit confirmation dialog
  void _showExitConfirmation(BuildContext context) {
    final availabilityController = Get.find<AvailabilityController>();

    if (availabilityController.selectedDate.value != null &&
        availabilityController.selectedSlot.value != null) {
      Get.dialog(
        AlertDialog(
          title: const Text('Exit Booking?'),
          content: const Text(
              'You have unsaved selections. Are you sure you want to exit?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                Get.back(); // Exit booking
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      );
    } else {
      Get.back();
    }
  }

  /// Show clear confirmation dialog
  void _showClearConfirmation(
      BuildContext context, AvailabilityController availabilityController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Selections?'),
        content: const Text(
            'This will clear all your current selections. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              availabilityController.clearAllSelections();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// Build header section
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: AppTheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Your Appointment',
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select your preferred appointment type, date, and time',
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build appointment type selection
  Widget _buildAppointmentTypeSection() {
    final availabilityController = Get.find<AvailabilityController>();

    return AppointmentTypeSelector(
      appointmentTypes: controller.appointmentTypes,
      selectedType: controller.selectedAppointmentType.value,
      onTypeSelected: (type) {
        controller.selectedAppointmentType.value = type;
        // Clear selected date when type changes
        availabilityController.selectedDate.value = null;
        // Load available slots for the new type
        _loadAvailableSlots();
      },
      isLoading: controller.isLoading.value,
      error: controller.error.value.isNotEmpty ? controller.error.value : null,
    );
  }

  /// Build date and time selection
  Widget _buildDateTimeSection() {
    final availabilityController = Get.find<AvailabilityController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date & Time',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppTheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Date',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          _formatDate(
                              availabilityController.selectedDate.value),
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ],
                ),
              ),
              TextButton(
                onPressed: _selectDate,
                child: const Text('Change'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build slots section
  Widget _buildSlotsSection() {
    final availabilityController = Get.find<AvailabilityController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Slots',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        AppointmentSlotPicker(
          slots: availabilityController.selectedDay.value?.slots ?? [],
          selectedSlot: availabilityController.selectedSlot.value,
          onSlotSelected: (slot) {
            availabilityController.selectTimeSlot(slot);
          },
          selectedDate:
              availabilityController.selectedDate.value ?? DateTime.now(),
          onDateChanged: (date) {
            availabilityController.setSelectedDate(date);
            _loadAvailableSlots();
          },
          isLoading: availabilityController.isLoadingDay.value,
          error: availabilityController.dayError.value.isNotEmpty
              ? availabilityController.dayError.value
              : null,
        ),
      ],
    );
  }

  /// Build booking form
  Widget _buildBookingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointment Details',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        AppointmentForm(
          onSubmit: _handleBookingSubmit,
          onCancel: () => Get.back(),
          isLoading: controller.isLoading.value,
          error:
              controller.error.value.isNotEmpty ? controller.error.value : null,
        ),
      ],
    );
  }

  /// Handle booking form submission
  void _handleBookingSubmit(AppointmentFormData formData) async {
    try {
      if (controller.selectedAppointmentType.value == null) {
        Get.snackbar(
          'Error',
          'Please select an appointment type',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.error,
          colorText: Colors.white,
        );
        return;
      }

      // Set the form data in controller using the new structure
      controller.setSelectedDate(DateTime.parse(formData.appointmentDate));
      controller.setSelectedTime(formData.startTime);
      controller.notes.value = formData.notes;

      // Book the appointment using controller method
      final success = await controller.bookAppointment();

      if (success) {
        // Show success message
        Get.snackbar(
          'Success',
          'Appointment booked successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.success,
          colorText: Colors.white,
        );

        // Navigate back to appointments list
        Get.back();
      } else {
        // Show error message from controller
        Get.snackbar(
          'Error',
          controller.error.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.error,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to book appointment: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.error,
        colorText: Colors.white,
      );
    }
  }

  /// Select date using date picker
  void _selectDate() async {
    final availabilityController = Get.find<AvailabilityController>();
    final selectedDate = await showDatePicker(
      context: Get.context!,
      initialDate: availabilityController.selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (selectedDate != null) {
      availabilityController.setSelectedDate(selectedDate);
      _loadAvailableSlots();
    }
  }

  /// Load available slots for selected date and type
  void _loadAvailableSlots() async {
    final availabilityController = Get.find<AvailabilityController>();
    if (availabilityController.selectedAppointmentType.value != null &&
        availabilityController.selectedDate.value != null) {
      await availabilityController.loadDayAvailability(
        availabilityController.selectedDate.value!
            .toIso8601String()
            .split('T')[0],
      );
    }
  }

  /// Handle selection complete from availability flow
  void _handleSelectionComplete(AvailabilitySelection selection) {
    final availabilityController = Get.find<AvailabilityController>();

    // Set the selected values in the availability controller
    if (selection.selectedDate != null) {
      availabilityController.setSelectedDate(selection.selectedDate!);
    }
    if (selection.selectedSlot != null) {
      availabilityController.selectedSlot.value = selection.selectedSlot!;
    }

    // Show success message
    Get.snackbar(
      'Selection Complete',
      'Date and time selected successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.success,
      colorText: Colors.white,
    );
  }

  /// Format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return 'No date selected';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today, ${date.day}/${date.month}/${date.year}';
    } else if (dateToCheck == tomorrow) {
      return 'Tomorrow, ${date.day}/${date.month}/${date.year}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
