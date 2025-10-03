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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_services,
                color: AppTheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Appointment Type',
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the type of appointment you need',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          if (isLoading)
            _buildLoadingState()
          else if (error != null)
            _buildErrorState()
          else if (appointmentTypes.isEmpty)
            _buildEmptyState()
          else
            _buildTypeList(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          const SizedBox(width: 16),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.error,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.textMuted.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline,
              color: AppTheme.textMuted,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
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
      margin: const EdgeInsets.only(bottom: 12),
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected
                ? _getTypeColor(type.color).withValues(alpha: 0.1)
                : AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? _getTypeColor(type.color)
                  : AppTheme.border.withValues(alpha: 0.5),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: _getTypeColor(type.color).withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Type icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getTypeColor(type.color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(type.name),
                  color: _getTypeColor(type.color),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

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
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(type.color)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            type.formattedDuration,
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: _getTypeColor(type.color),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (type.description != null) ...[
                      const SizedBox(height: 6),
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTypeColor(type.color),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
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
