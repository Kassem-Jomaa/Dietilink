import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/appointment_type_api.dart';
import '../../../core/theme/app_theme.dart';

/// Appointment Type Selector Widget
///
/// Displays a list of appointment types from the API and allows selection
class AppointmentTypeSelector extends StatelessWidget {
  final List<AppointmentTypeAPI> appointmentTypes;
  final AppointmentTypeAPI? selectedType;
  final Function(AppointmentTypeAPI) onTypeSelected;
  final bool isLoading;
  final String? error;

  const AppointmentTypeSelector({
    Key? key,
    required this.appointmentTypes,
    this.selectedType,
    required this.onTypeSelected,
    this.isLoading = false,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointment Type',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (isLoading)
          _buildLoadingState()
        else if (error != null)
          _buildErrorState()
        else if (appointmentTypes.isEmpty)
          _buildEmptyState()
        else
          _buildTypeList(),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.violetBlue),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading appointment types...',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error ?? 'Failed to load appointment types',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppTheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppTheme.textMuted,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            'No appointment types available',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeList() {
    return Column(
      children: appointmentTypes.map((type) => _buildTypeCard(type)).toList(),
    );
  }

  Widget _buildTypeCard(AppointmentTypeAPI type) {
    final isSelected = selectedType?.id == type.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          onTypeSelected(type);
          // Show selection feedback
          Get.snackbar(
            'Type Selected',
            type.name,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: _getTypeColor(type.color).withValues(alpha: 0.9),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            icon: Icon(_getTypeIcon(type.name), color: Colors.white),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? _getTypeColor(type.color).withValues(alpha: 0.1)
                : AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? _getTypeColor(type.color) : AppTheme.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Type icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getTypeColor(type.color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTypeIcon(type.name),
                  color: _getTypeColor(type.color),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Type details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            type.name,
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(type.color)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            type.formattedDuration,
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: _getTypeColor(type.color),
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (type.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        type.description!,
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMuted,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Selection indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: _getTypeColor(type.color),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceAll('#', '0xFF')));
    } catch (e) {
      return AppTheme.violetBlue;
    }
  }

  IconData _getTypeIcon(String typeName) {
    final name = typeName.toLowerCase();
    if (name.contains('consultation') || name.contains('initial')) {
      return Icons.medical_services;
    } else if (name.contains('follow') || name.contains('up')) {
      return Icons.update;
    } else if (name.contains('quick') || name.contains('check')) {
      return Icons.schedule;
    } else if (name.contains('nutrition')) {
      return Icons.restaurant_menu;
    } else if (name.contains('fitness')) {
      return Icons.fitness_center;
    } else {
      return Icons.event;
    }
  }
}
