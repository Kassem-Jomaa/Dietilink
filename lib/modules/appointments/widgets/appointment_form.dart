import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/appointment_model.dart';
import '../../../core/theme/app_theme.dart';

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
  late TimeOfDay _selectedTime;
  late int _selectedTypeId;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.appointment != null) {
      _selectedDate = widget.appointment!.appointmentDate;
      _selectedTime =
          TimeOfDay.fromDateTime(widget.appointment!.appointmentDate);
      _selectedTypeId = widget.appointment!.appointmentTypeId;
      _reasonController.text = widget.appointment!.reason ?? '';
      _notesController.text = widget.appointment!.notes ?? '';
    } else {
      final now = DateTime.now();
      _selectedDate = now.add(const Duration(days: 1));
      _selectedTime = const TimeOfDay(hour: 9, minute: 0);
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
                  Text(_formatDate(_selectedDate),
                      style: Get.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: _selectTime,
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
                  Text(_selectedTime.format(context),
                      style: Get.textTheme.bodyMedium),
                ],
              ),
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
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final appointmentDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final formData = AppointmentFormData(
        appointmentDate: appointmentDateTime.toIso8601String().split('T')[0],
        startTime:
            '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
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
