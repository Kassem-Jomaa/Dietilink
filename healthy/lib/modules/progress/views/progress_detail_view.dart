import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/progress_controller.dart';
import '../models/progress_model.dart';
import 'edit_progress_view.dart';

class ProgressDetailView extends StatelessWidget {
  final ProgressEntry entry;

  const ProgressDetailView({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProgressController>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: Text(_formatDate(entry.measurementDate)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.to(() => EditProgressView(entry: entry)),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value, controller),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfoCard(),
            const SizedBox(height: 24),
            if (_hasMeasurements()) ...[
              _buildMeasurementsCard(),
              const SizedBox(height: 24),
            ],
            if (_hasBodyComposition()) ...[
              _buildBodyCompositionCard(),
              const SizedBox(height: 24),
            ],
            if (entry.images.isNotEmpty) ...[
              _buildImagesCard(),
              const SizedBox(height: 24),
            ],
            if (entry.notes != null && entry.notes!.isNotEmpty) ...[
              _buildNotesCard(),
              const SizedBox(height: 24),
            ],
            _buildMetadataCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.violetBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Weight',
                  '${entry.weight} kg',
                  Icons.scale,
                  AppTheme.violetBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  'Date',
                  _formatDate(entry.measurementDate),
                  Icons.calendar_today,
                  AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.violetBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body Measurements',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildMeasurementsGrid(),
        ],
      ),
    );
  }

  Widget _buildMeasurementsGrid() {
    final measurements = <Map<String, dynamic>>[];

    if (entry.measurements.chest != null) {
      measurements.add({
        'label': 'Chest',
        'value': '${entry.measurements.chest} cm',
        'icon': Icons.accessibility
      });
    }
    if (entry.measurements.waist != null) {
      measurements.add({
        'label': 'Waist',
        'value': '${entry.measurements.waist} cm',
        'icon': Icons.straighten
      });
    }
    if (entry.measurements.hips != null) {
      measurements.add({
        'label': 'Hips',
        'value': '${entry.measurements.hips} cm',
        'icon': Icons.straighten
      });
    }
    if (entry.measurements.leftArm != null) {
      measurements.add({
        'label': 'Left Arm',
        'value': '${entry.measurements.leftArm} cm',
        'icon': Icons.fitness_center
      });
    }
    if (entry.measurements.rightArm != null) {
      measurements.add({
        'label': 'Right Arm',
        'value': '${entry.measurements.rightArm} cm',
        'icon': Icons.fitness_center
      });
    }
    if (entry.measurements.leftThigh != null) {
      measurements.add({
        'label': 'Left Thigh',
        'value': '${entry.measurements.leftThigh} cm',
        'icon': Icons.accessibility
      });
    }
    if (entry.measurements.rightThigh != null) {
      measurements.add({
        'label': 'Right Thigh',
        'value': '${entry.measurements.rightThigh} cm',
        'icon': Icons.accessibility
      });
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: measurements.length,
      itemBuilder: (context, index) {
        final item = measurements[index];
        return _buildInfoItem(
          item['label'],
          item['value'],
          item['icon'],
          AppTheme.violetBlue,
        );
      },
    );
  }

  Widget _buildBodyCompositionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.violetBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body Composition',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (entry.bodyComposition.fatMass != null)
                Expanded(
                  child: _buildInfoItem(
                    'Fat Mass',
                    '${entry.bodyComposition.fatMass}%',
                    Icons.monitor_weight_outlined,
                    AppTheme.warning,
                  ),
                ),
              if (entry.bodyComposition.fatMass != null &&
                  entry.bodyComposition.muscleMass != null)
                const SizedBox(width: 16),
              if (entry.bodyComposition.muscleMass != null)
                Expanded(
                  child: _buildInfoItem(
                    'Muscle Mass',
                    '${entry.bodyComposition.muscleMass} kg',
                    Icons.fitness_center,
                    AppTheme.success,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.violetBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Photos',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: entry.images.length,
              itemBuilder: (context, index) {
                final image = entry.images[index];
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => _showImageDialog(image.url),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        image.url,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppTheme.violetBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppTheme.textMuted,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.violetBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note_outlined,
                color: AppTheme.violetBlue,
              ),
              const SizedBox(width: 8),
              Text(
                'Notes',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            entry.notes!,
            style: Get.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.violetBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Entry Information',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Created',
                  _formatDateTime(entry.createdAt),
                  Icons.add_circle_outline,
                  AppTheme.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  'Updated',
                  _formatDateTime(entry.updatedAt),
                  Icons.update,
                  AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  bool _hasMeasurements() {
    final m = entry.measurements;
    return m.chest != null ||
        m.waist != null ||
        m.hips != null ||
        m.leftArm != null ||
        m.rightArm != null ||
        m.leftThigh != null ||
        m.rightThigh != null;
  }

  bool _hasBodyComposition() {
    return entry.bodyComposition.fatMass != null ||
        entry.bodyComposition.muscleMass != null;
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }

  void _showImageDialog(String imageUrl) {
    Get.dialog(
      Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Progress Photo'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            Expanded(
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load image',
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action, ProgressController controller) {
    switch (action) {
      case 'edit':
        Get.to(() => EditProgressView(entry: entry));
        break;
      case 'delete':
        _showDeleteConfirmation(controller);
        break;
    }
  }

  void _showDeleteConfirmation(ProgressController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Progress Entry'),
        content: Text(
            'Are you sure you want to delete the progress entry from ${_formatDate(entry.measurementDate)}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Close dialog
              await controller.deleteProgressEntry(entry.id);
              Get.back(); // Go back to previous screen
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
