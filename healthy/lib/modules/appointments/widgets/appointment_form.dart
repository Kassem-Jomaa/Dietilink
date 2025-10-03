import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/appointment_model.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/availability_controller.dart';

/// Appointment Form Widget
///
/// A form for booking and editing appointments
class AppointmentForm extends StatefulWidget {
  final Appointment? appointment;
  final Function(AppointmentFormData) onSubmit;
  final VoidCallback? onCancel;
  final bool isLoading;
  final String? error;

  const AppointmentForm({
    Key? key,
    this.appointment,
    required this.onSubmit,
    this.onCancel,
    this.isLoading = false,
    this.error,
  }) : super(key: key);

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();

  late DateTime _selectedDate;
  late int _selectedTypeId;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.appointment != null) {
      _selectedDate = widget.appointment!.appointmentDate;
      _selectedTypeId = widget.appointment!.appointmentTypeId;
      _reasonController.text = widget.appointment!.reason ?? '';
      _notesController.text = widget.appointment!.notes ?? '';
    } else {
      final now = DateTime.now();
      _selectedDate = now.add(const Duration(days: 1));
      _selectedTypeId = 1; // Default to consultation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Date and time selection
          _buildDateTimeSection(),
          const SizedBox(height: 16),

          // Type selection
          _buildTypeSection(),
          const SizedBox(height: 16),

          // Reason field
          TextFormField(
            controller: _reasonController,
            decoration: InputDecoration(
              labelText: 'Reason for Visit',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          // Notes field
          TextFormField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Additional Notes (Optional)',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              if (widget.onCancel != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('Back'),
                  ),
                ),
              if (widget.onCancel != null) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: widget.isLoading ? null : _submitForm,
                  icon: widget.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          widget.appointment != null
                              ? Icons.update
                              : Icons.check,
                          size: 16,
                        ),
                  label: Text(widget.appointment != null ? 'Update' : 'Book'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection() {
    final availabilityController = Get.find<AvailabilityController>();

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date', style: Get.textTheme.bodySmall),
                  Obx(() {
                    final selectedDate =
                        availabilityController.selectedDate.value;
                    if (selectedDate != null) {
                      return Text(_formatDate(selectedDate),
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ));
                    } else {
                      return Text('No date selected',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textMuted,
                          ));
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Time', style: Get.textTheme.bodySmall),
                Obx(() {
                  final selectedSlot =
                      availabilityController.selectedSlot.value;
                  if (selectedSlot != null) {
                    return Text(
                      '${_formatTimeForDisplay(selectedSlot.startTime)} - ${_formatTimeForDisplay(selectedSlot.endTime)}',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  } else {
                    return Text(
                      'No time selected',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Appointment Type', style: Get.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _getAppointmentTypes().map((type) {
            final isSelected = _selectedTypeId == type['id'];
            return ChoiceChip(
              label: Text(type['name']),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedTypeId = type['id']);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _selectDate() async {
    final availabilityController = Get.find<AvailabilityController>();
    final initialDate =
        availabilityController.selectedDate.value ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date != null) {
      availabilityController.setSelectedDate(date);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final availabilityController = Get.find<AvailabilityController>();
      final selectedSlot = availabilityController.selectedSlot.value;
      final selectedDate = availabilityController.selectedDate.value;

      if (selectedSlot == null) {
        Get.snackbar(
          'Error',
          'Please select a time slot from the availability calendar',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.error,
          colorText: Colors.white,
        );
        return;
      }

      if (selectedDate == null) {
        Get.snackbar(
          'Error',
          'Please select a date from the availability calendar',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.error,
          colorText: Colors.white,
        );
        return;
      }

      final formData = AppointmentFormData(
        appointmentDate: selectedDate.toIso8601String().split('T')[0],
        startTime: selectedSlot.startTime, // Use selected slot time
        appointmentTypeId: _selectedTypeId,
        notes: _notesController.text.trim(),
        dietitianId: 1, // Default dietitian ID
      );

      widget.onSubmit(formData);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Format time for display (e.g., "09:30" -> "9:30 AM")
  String _formatTimeForDisplay(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time;
    }
  }

  List<Map<String, dynamic>> _getAppointmentTypes() {
    return [
      {'id': 1, 'name': 'Consultation'},
      {'id': 2, 'name': 'Follow-up'},
      {'id': 3, 'name': 'Nutrition'},
      {'id': 4, 'name': 'Fitness'},
      {'id': 5, 'name': 'General'},
    ];
  }
}

/// Appointment Form Data Model
class AppointmentFormData {
  final String appointmentDate; // Changed to String format for API
  final String startTime; // Added start time
  final int appointmentTypeId;
  final String notes;
  final int dietitianId;

  AppointmentFormData({
    required this.appointmentDate,
    required this.startTime,
    required this.appointmentTypeId,
    required this.notes,
    required this.dietitianId,
  });
}
