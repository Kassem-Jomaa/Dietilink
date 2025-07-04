import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/appointment_model.dart';
import '../models/availability_models.dart';
import '../../../core/theme/app_theme.dart';

/// Appointment Slot Picker Widget
///
/// Displays available appointment slots in a grid format with:
/// - Time slot selection
/// - Doctor information
/// - Availability status
/// - Date navigation
class AppointmentSlotPicker extends StatefulWidget {
  final List<AppointmentSlot> slots;
  final AppointmentSlot? selectedSlot;
  final Function(AppointmentSlot) onSlotSelected;
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final bool isLoading;
  final String? error;

  const AppointmentSlotPicker({
    Key? key,
    required this.slots,
    this.selectedSlot,
    required this.onSlotSelected,
    required this.selectedDate,
    required this.onDateChanged,
    this.isLoading = false,
    this.error,
  }) : super(key: key);

  @override
  State<AppointmentSlotPicker> createState() => _AppointmentSlotPickerState();
}

class _AppointmentSlotPickerState extends State<AppointmentSlotPicker> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selectedDate;
  }

  @override
  void didUpdateWidget(AppointmentSlotPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _currentDate = widget.selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),

          // Date navigation
          _buildDateNavigation(),

          // Slots grid
          _buildSlotsGrid(),

          // Error message
          if (widget.error != null) _buildErrorMessage(),
        ],
      ),
    );
  }

  /// Build header with title and refresh button
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: AppTheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Available Slots',
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textMain,
            ),
          ),
          const Spacer(),
          if (widget.isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
              ),
            ),
        ],
      ),
    );
  }

  /// Build date navigation
  Widget _buildDateNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Previous day button
          IconButton(
            onPressed: _previousDay,
            icon: const Icon(Icons.chevron_left),
            color: AppTheme.primary,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),

          // Date display
          Expanded(
            child: GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(_currentDate),
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textMain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Next day button
          IconButton(
            onPressed: _nextDay,
            icon: const Icon(Icons.chevron_right),
            color: AppTheme.primary,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  /// Build slots grid
  Widget _buildSlotsGrid() {
    if (widget.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.slots.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.slots.length} available slots',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          // Slots grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: widget.slots.length,
            itemBuilder: (context, index) {
              final slot = widget.slots[index];
              final isSelected = widget.selectedSlot?.dateTime == slot.dateTime;

              return _buildSlotCard(slot, isSelected);
            },
          ),
        ],
      ),
    );
  }

  /// Build individual slot card
  Widget _buildSlotCard(AppointmentSlot slot, bool isSelected) {
    return GestureDetector(
      onTap: slot.isAvailable ? () => widget.onSlotSelected(slot) : null,
      child: Container(
        decoration: BoxDecoration(
          color: _getSlotCardColor(isSelected, slot.isAvailable),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getSlotCardBorderColor(isSelected, slot.isAvailable),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Time
            Text(
              slot.formattedTime,
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: _getSlotTextColor(isSelected, slot.isAvailable),
              ),
            ),

            // Dietitian name (if available)
            if (slot.dietitianName != null) ...[
              const SizedBox(height: 2),
              Text(
                slot.dietitianName!,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: _getSlotTextColor(isSelected, slot.isAvailable)
                      .withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Specialty (if available)
            if (slot.dietitianSpecialty != null) ...[
              const SizedBox(height: 2),
              Text(
                slot.dietitianSpecialty!,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: _getSlotTextColor(isSelected, slot.isAvailable)
                      .withValues(alpha: 0.5),
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 48,
            color: AppTheme.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No available slots',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different date or check back later',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build error message
  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.error!,
              style: Get.textTheme.bodySmall?.copyWith(
                color: AppTheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to previous day
  void _previousDay() {
    final previousDay = _currentDate.subtract(const Duration(days: 1));
    if (previousDay.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      setState(() {
        _currentDate = previousDay;
      });
      widget.onDateChanged(previousDay);
    }
  }

  /// Navigate to next day
  void _nextDay() {
    final nextDay = _currentDate.add(const Duration(days: 1));
    setState(() {
      _currentDate = nextDay;
    });
    widget.onDateChanged(nextDay);
  }

  /// Select date using date picker
  void _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (selectedDate != null) {
      setState(() {
        _currentDate = selectedDate;
      });
      widget.onDateChanged(selectedDate);
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Get slot card background color
  Color _getSlotCardColor(bool isSelected, bool isAvailable) {
    if (isSelected) return AppTheme.primary;
    if (!isAvailable) return AppTheme.background;
    return AppTheme.cardBackground;
  }

  /// Get slot card border color
  Color _getSlotCardBorderColor(bool isSelected, bool isAvailable) {
    if (isSelected) return AppTheme.primary;
    if (!isAvailable) return AppTheme.border.withValues(alpha: 0.3);
    return AppTheme.border;
  }

  /// Get slot text color
  Color _getSlotTextColor(bool isSelected, bool isAvailable) {
    if (isSelected) return Colors.white;
    if (!isAvailable) return AppTheme.textMuted.withValues(alpha: 0.5);
    return AppTheme.textMain;
  }
}

/// Time Slot Chip Widget
///
/// A compact time slot display for lists
class TimeSlotChip extends StatelessWidget {
  final AppointmentSlot slot;
  final bool isSelected;
  final VoidCallback? onTap;

  const TimeSlotChip({
    Key? key,
    required this.slot,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: slot.isAvailable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _getChipColor(),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getChipBorderColor(),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule,
              size: 16,
              color: _getChipTextColor(),
            ),
            const SizedBox(width: 4),
            Text(
              slot.formattedTime,
              style: Get.textTheme.bodySmall?.copyWith(
                color: _getChipTextColor(),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getChipColor() {
    if (isSelected) return AppTheme.primary;
    if (!slot.isAvailable) return AppTheme.background;
    return AppTheme.cardBackground;
  }

  Color _getChipBorderColor() {
    if (isSelected) return AppTheme.primary;
    if (!slot.isAvailable) return AppTheme.border.withValues(alpha: 0.3);
    return AppTheme.border;
  }

  Color _getChipTextColor() {
    if (isSelected) return Colors.white;
    if (!slot.isAvailable) return AppTheme.textMuted.withValues(alpha: 0.5);
    return AppTheme.textMain;
  }
}
