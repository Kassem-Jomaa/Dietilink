import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_message.dart';
import '../../../core/theme/app_theme.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final occupationController = TextEditingController();
    final heightController = TextEditingController();
    final initialWeightController = TextEditingController();
    final goalWeightController = TextEditingController();
    final notesController = TextEditingController();
    final genderController = RxString('');

    // Initialize controllers with current values
    final profile = controller.profile.value;
    if (profile != null) {
      nameController.text = profile.user.name;
      emailController.text = profile.user.email ?? '';
      phoneController.text = profile.patient.phone ?? '';
      occupationController.text = profile.patient.occupation ?? '';
      heightController.text = profile.patient.height?.toString() ?? '';
      initialWeightController.text =
          profile.patient.initialWeight?.toString() ?? '';
      goalWeightController.text = profile.patient.goalWeight?.toString() ?? '';
      notesController.text = profile.patient.notes ?? '';
      genderController.value = profile.patient.gender ?? '';
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.lock, color: AppTheme.textMain),
            label: const Text('Change Password',
                style: TextStyle(color: AppTheme.textMain)),
            onPressed: () => Get.toNamed('/profile/change-password'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingIndicator();
        }

        if (controller.errorMessage.isNotEmpty) {
          return ErrorMessage(
            message: controller.errorMessage.value,
            onRetry: controller.loadProfile,
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Display validation errors if any
                if (controller.validationErrors.isNotEmpty) ...[
                  Card(
                    color: Colors.red[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.validationErrors.entries
                            .map((entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.key
                                            .replaceAll('_', ' ')
                                            .capitalize!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      ...entry.value.map((error) => Text(
                                            '• $error',
                                            style: const TextStyle(
                                                color: Colors.red),
                                          )),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Profile Picture Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            AppTheme.primaryAccent.withOpacity(0.2),
                        child: Text(
                          nameController.text.isNotEmpty
                              ? nameController.text[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryAccent,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryAccent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.background,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Basic Information Section
                _buildSectionHeader('Basic Information'),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: nameController,
                  label: 'Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    if (value.length > 255) {
                      return 'Name must be less than 255 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Patient Information Section
                _buildSectionHeader('Patient Information'),
                const SizedBox(height: 16),
                if (profile?.patient?.phone != null)
                  _buildTextField(
                    controller: phoneController,
                    label: 'Phone',
                    icon: Icons.phone,
                  ),
                if (profile?.patient?.phone != null) const SizedBox(height: 16),
                if (profile?.patient?.gender != null)
                  Obx(() => _buildDropdownField(
                        value: genderController.value.isEmpty
                            ? null
                            : genderController.value,
                        label: 'Gender',
                        icon: Icons.person_outline,
                        items: const [
                          DropdownMenuItem(value: 'male', child: Text('Male')),
                          DropdownMenuItem(
                              value: 'female', child: Text('Female')),
                          DropdownMenuItem(
                              value: 'other', child: Text('Other')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            genderController.value = value;
                          }
                        },
                      )),
                if (profile?.patient?.gender != null)
                  const SizedBox(height: 16),
                if (profile?.patient?.occupation != null)
                  _buildTextField(
                    controller: occupationController,
                    label: 'Occupation',
                    icon: Icons.work,
                  ),
                if (profile?.patient?.occupation != null)
                  const SizedBox(height: 16),
                if (profile?.patient?.height != null ||
                    profile?.patient?.initialWeight != null)
                  Row(
                    children: [
                      if (profile?.patient?.height != null)
                        Expanded(
                          child: _buildTextField(
                            controller: heightController,
                            label: 'Height (cm)',
                            icon: Icons.height,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      if (profile?.patient?.height != null &&
                          profile?.patient?.initialWeight != null)
                        const SizedBox(width: 16),
                      if (profile?.patient?.initialWeight != null)
                        Expanded(
                          child: _buildTextField(
                            controller: initialWeightController,
                            label: 'Initial Weight (kg)',
                            icon: Icons.monitor_weight,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                    ],
                  ),
                if (profile?.patient?.height != null ||
                    profile?.patient?.initialWeight != null)
                  const SizedBox(height: 16),
                if (profile?.patient?.goalWeight != null)
                  _buildTextField(
                    controller: goalWeightController,
                    label: 'Goal Weight (kg)',
                    icon: Icons.flag,
                    keyboardType: TextInputType.number,
                  ),
                if (profile?.patient?.goalWeight != null)
                  const SizedBox(height: 16),
                if (profile?.patient?.notes != null)
                  _buildTextField(
                    controller: notesController,
                    label: 'Notes',
                    icon: Icons.note,
                    maxLines: 3,
                  ),
                if (profile?.patient?.notes != null) const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final updateData = {
                        'name': nameController.text,
                        'email': emailController.text,
                      };

                      // Only add fields that have values
                      if (phoneController.text.isNotEmpty) {
                        updateData['phone'] = phoneController.text;
                      }
                      if (genderController.value.isNotEmpty) {
                        updateData['gender'] = genderController.value;
                      }
                      if (occupationController.text.isNotEmpty) {
                        updateData['occupation'] = occupationController.text;
                      }
                      if (heightController.text.isNotEmpty) {
                        final height = double.tryParse(heightController.text);
                        if (height != null) {
                          updateData['height'] = height.toString();
                        }
                      }
                      if (initialWeightController.text.isNotEmpty) {
                        final weight =
                            double.tryParse(initialWeightController.text);
                        if (weight != null) {
                          updateData['initial_weight'] = weight.toString();
                        }
                      }
                      if (goalWeightController.text.isNotEmpty) {
                        final weight =
                            double.tryParse(goalWeightController.text);
                        if (weight != null) {
                          updateData['goal_weight'] = weight.toString();
                        }
                      }
                      if (notesController.text.isNotEmpty) {
                        updateData['notes'] = notesController.text;
                      }

                      final success =
                          await controller.updateProfile(updateData);

                      if (success) {
                        Get.back();
                        Get.snackbar(
                          'Success',
                          'Profile updated successfully',
                          backgroundColor: AppTheme.success,
                          colorText: Colors.white,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.textMain,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryAccent),
        ),
        filled: true,
        fillColor: AppTheme.cardBackground,
        labelStyle: const TextStyle(color: AppTheme.textMuted),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      validator: validator,
      style: const TextStyle(color: AppTheme.textMain),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryAccent),
        ),
        filled: true,
        fillColor: AppTheme.cardBackground,
        labelStyle: const TextStyle(color: AppTheme.textMuted),
      ),
      items: items,
      onChanged: onChanged,
      dropdownColor: AppTheme.cardBackground,
      style: const TextStyle(color: AppTheme.textMain),
      icon: const Icon(Icons.arrow_drop_down, color: AppTheme.textMuted),
    );
  }
}
