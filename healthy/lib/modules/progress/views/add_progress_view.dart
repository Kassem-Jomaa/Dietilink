import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../controllers/progress_controller.dart';

class AddProgressView extends StatefulWidget {
  const AddProgressView({super.key});

  @override
  State<AddProgressView> createState() => _AddProgressViewState();
}

class _AddProgressViewState extends State<AddProgressView> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<ProgressController>();

  // Form controllers
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  final _chestController = TextEditingController();
  final _leftArmController = TextEditingController();
  final _rightArmController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipsController = TextEditingController();
  final _leftThighController = TextEditingController();
  final _rightThighController = TextEditingController();
  final _fatMassController = TextEditingController();
  final _muscleMassController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    controller.clearSelectedImages();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    _chestController.dispose();
    _leftArmController.dispose();
    _rightArmController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _leftThighController.dispose();
    _rightThighController.dispose();
    _fatMassController.dispose();
    _muscleMassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: const Text('Add Progress Entry'),
        actions: [
          Obx(() => TextButton(
                onPressed: controller.isCreating.value ? null : _saveProgress,
                child: controller.isCreating.value
                    ? const LoadingIndicator()
                    : const Text('Save'),
              )),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildMeasurementsSection(),
              const SizedBox(height: 24),
              _buildBodyCompositionSection(),
              const SizedBox(height: 24),
              _buildImagesSection(),
              const SizedBox(height: 24),
              _buildNotesSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
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
          TextFormField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Weight (kg)',
              hintText: 'Enter your weight',
              prefixIcon: const Icon(Icons.scale),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Weight is required';
              }
              final weight = double.tryParse(value);
              if (weight == null || weight <= 0 || weight > 999.99) {
                return 'Please enter a valid weight (0-999.99 kg)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.textMuted.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: AppTheme.textMuted),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Measurement Date',
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: Get.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppTheme.textMuted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementsSection() {
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
            'Body Measurements (cm)',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Optional - Add measurements to track changes',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMeasurementField(
                  controller: _chestController,
                  label: 'Chest',
                  icon: Icons.accessibility,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMeasurementField(
                  controller: _waistController,
                  label: 'Waist',
                  icon: Icons.straighten,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMeasurementField(
                  controller: _hipsController,
                  label: 'Hips',
                  icon: Icons.straighten,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMeasurementField(
                  controller: _leftArmController,
                  label: 'Left Arm',
                  icon: Icons.fitness_center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMeasurementField(
                  controller: _rightArmController,
                  label: 'Right Arm',
                  icon: Icons.fitness_center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMeasurementField(
                  controller: _leftThighController,
                  label: 'Left Thigh',
                  icon: Icons.accessibility,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMeasurementField(
            controller: _rightThighController,
            label: 'Right Thigh',
            icon: Icons.accessibility,
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: '0.0',
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final measurement = double.tryParse(value);
          if (measurement == null || measurement < 0 || measurement > 999.99) {
            return 'Invalid measurement';
          }
        }
        return null;
      },
    );
  }

  Widget _buildBodyCompositionSection() {
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
          const SizedBox(height: 4),
          Text(
            'Optional - Track body fat and muscle mass',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _fatMassController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Fat Mass (%)',
                    hintText: '0.0',
                    prefixIcon: const Icon(Icons.monitor_weight_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final fatMass = double.tryParse(value);
                      if (fatMass == null || fatMass < 0 || fatMass > 100) {
                        return 'Invalid percentage';
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _muscleMassController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Muscle Mass (kg)',
                    hintText: '0.0',
                    prefixIcon: const Icon(Icons.fitness_center),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final muscleMass = double.tryParse(value);
                      if (muscleMass == null ||
                          muscleMass < 0 ||
                          muscleMass > 999.99) {
                        return 'Invalid muscle mass';
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagesSection() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress Photos',
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Optional - Add up to 5 photos',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: controller.takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.violetBlue.withOpacity(0.1),
                      foregroundColor: AppTheme.violetBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: controller.pickSingleImage,
                    icon: const Icon(Icons.photo_library),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.violetBlue.withOpacity(0.1),
                      foregroundColor: AppTheme.violetBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.selectedImages.isEmpty) {
              return Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.textMuted.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 32,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No photos selected',
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.selectedImages.length,
                itemBuilder: (context, index) {
                  final image = controller.selectedImages[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            image,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => controller.removeSelectedImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
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
            'Notes',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Optional - Add notes about your progress',
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _notesController,
            maxLines: 4,
            maxLength: 2000,
            decoration: InputDecoration(
              hintText: 'How are you feeling? Any observations?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value != null && value.length > 2000) {
                return 'Notes cannot exceed 2000 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveProgress() async {
    if (!_formKey.currentState!.validate()) return;

    final weight = double.parse(_weightController.text);
    final measurementDate =
        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

    final chest = _chestController.text.isNotEmpty
        ? double.parse(_chestController.text)
        : null;
    final leftArm = _leftArmController.text.isNotEmpty
        ? double.parse(_leftArmController.text)
        : null;
    final rightArm = _rightArmController.text.isNotEmpty
        ? double.parse(_rightArmController.text)
        : null;
    final waist = _waistController.text.isNotEmpty
        ? double.parse(_waistController.text)
        : null;
    final hips = _hipsController.text.isNotEmpty
        ? double.parse(_hipsController.text)
        : null;
    final leftThigh = _leftThighController.text.isNotEmpty
        ? double.parse(_leftThighController.text)
        : null;
    final rightThigh = _rightThighController.text.isNotEmpty
        ? double.parse(_rightThighController.text)
        : null;
    final fatMass = _fatMassController.text.isNotEmpty
        ? double.parse(_fatMassController.text)
        : null;
    final muscleMass = _muscleMassController.text.isNotEmpty
        ? double.parse(_muscleMassController.text)
        : null;
    final notes =
        _notesController.text.isNotEmpty ? _notesController.text : null;

    final success = await controller.createProgressEntry(
      weight: weight,
      measurementDate: measurementDate,
      notes: notes,
      chest: chest,
      leftArm: leftArm,
      rightArm: rightArm,
      waist: waist,
      hips: hips,
      leftThigh: leftThigh,
      rightThigh: rightThigh,
      fatMass: fatMass,
      muscleMass: muscleMass,
      images: controller.selectedImages.isNotEmpty
          ? controller.selectedImages
          : null,
    );

    if (success) {
      Get.back();
    }
  }
}
