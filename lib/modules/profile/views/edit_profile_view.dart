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
    // Clear any existing temp form data when entering edit mode
    controller.clearTempFormData();
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('Edit Patient Information'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                // Breadcrumb Indicators
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _buildBreadcrumb('Personal', 0),
                      _buildBreadcrumbArrow(),
                      _buildBreadcrumb('Medical', 1),
                      _buildBreadcrumbArrow(),
                      _buildBreadcrumb('Food', 2),
                    ],
                  ),
                ),
                // Tab Bar
                TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: AppTheme.textMuted,
                  indicator: BoxDecoration(
                    color: AppTheme.violetBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.person),
                      text: 'Personal Info',
                    ),
                    Tab(
                      icon: Icon(Icons.medical_services),
                      text: 'Medical History',
                    ),
                    Tab(
                      icon: Icon(Icons.restaurant),
                      text: 'Food History',
                    ),
                  ],
                ),
              ],
            ),
          ),
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

          return const TabBarView(
            children: [
              PersonalInfoTab(),
              MedicalHistoryTab(),
              FoodHistoryTab(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBreadcrumb(String title, int index) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.violetBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumbArrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(
        Icons.chevron_right,
        color: AppTheme.textMuted,
        size: 16,
      ),
    );
  }
}

// Personal Info Tab
class PersonalInfoTab extends StatefulWidget {
  const PersonalInfoTab({Key? key}) : super(key: key);

  @override
  State<PersonalInfoTab> createState() => _PersonalInfoTabState();
}

class _PersonalInfoTabState extends State<PersonalInfoTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _occupationController = TextEditingController();
  final _heightController = TextEditingController();
  final _initialWeightController = TextEditingController();
  final _goalWeightController = TextEditingController();

  String? _selectedGender;
  String? _selectedActivityLevel;
  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _setupFormListeners();
  }

  void _setupFormListeners() {
    final controller = Get.find<ProfileController>();

    _nameController.addListener(() {
      controller.updateTempFormData('name', _nameController.text);
    });
    _emailController.addListener(() {
      controller.updateTempFormData('email', _emailController.text);
    });
    _phoneController.addListener(() {
      controller.updateTempFormData('phone', _phoneController.text);
    });
    _occupationController.addListener(() {
      controller.updateTempFormData('occupation', _occupationController.text);
    });
    _heightController.addListener(() {
      controller.updateTempFormData('height', _heightController.text);
    });
    _initialWeightController.addListener(() {
      controller.updateTempFormData(
          'initial_weight', _initialWeightController.text);
    });
    _goalWeightController.addListener(() {
      controller.updateTempFormData('goal_weight', _goalWeightController.text);
    });
  }

  void _loadProfileData() {
    final controller = Get.find<ProfileController>();
    final profile = controller.profile.value;

    if (profile != null) {
      _nameController.text = profile.user.name;
      _emailController.text = profile.user.email ?? '';
      _phoneController.text = profile.patient.phone ?? '';
      _occupationController.text = profile.patient.occupation ?? '';
      _heightController.text = profile.patient.height?.toString() ?? '';
      _initialWeightController.text =
          profile.patient.initialWeight?.toString() ?? '';
      _goalWeightController.text = profile.patient.goalWeight?.toString() ?? '';
      _selectedGender = profile.patient.gender;
      _selectedActivityLevel = profile.patient.activityLevel;
      _selectedBirthDate = profile.patient.birthDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Validation Errors Display
            GetBuilder<ProfileController>(
              builder: (controller) {
                if (controller.validationErrors.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withOpacity(0.1),
                      border: Border.all(color: AppTheme.error),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.validationErrors.entries
                          .map((entry) => Text(
                                '${entry.key}: ${entry.value.join(', ')}',
                                style: const TextStyle(color: AppTheme.error),
                              ))
                          .toList(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Personal Information Section
            _buildSectionHeader('Personal Information'),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _nameController,
              label: 'Full Name *',
              icon: Icons.person,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Full name is required';
                if (value!.length > 255)
                  return 'Name must be less than 255 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _emailController,
              label: 'Email Address *',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Email is required';
                if (!GetUtils.isEmail(value!))
                  return 'Please enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value != null && value.isNotEmpty && value.length > 20) {
                  return 'Phone number must be less than 20 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildDateField(
              label: 'Birth Date',
              icon: Icons.calendar_today,
              selectedDate: _selectedBirthDate,
              onDateSelected: (date) {
                if (date.isAfter(DateTime.now())) {
                  Get.snackbar('Error', 'Birth date cannot be in the future');
                  return;
                }
                setState(() {
                  _selectedBirthDate = date;
                });
                final controller = Get.find<ProfileController>();
                controller.updateTempFormData(
                    'birth_date', date.toIso8601String().split('T')[0]);
              },
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              value: _selectedGender,
              label: 'Gender',
              icon: Icons.person_outline,
              items: const ['Male', 'Female', 'Other'],
              onChanged: (value) {
                setState(() => _selectedGender = value);
                final controller = Get.find<ProfileController>();
                controller.updateTempFormData('gender', value);
              },
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _occupationController,
              label: 'Occupation',
              icon: Icons.work,
              validator: (value) {
                if (value != null && value.length > 255) {
                  return 'Occupation must be less than 255 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Physical Information Section
            _buildSectionHeader('Physical Information'),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _heightController,
                    label: 'Height (cm)',
                    icon: Icons.height,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final height = double.tryParse(value);
                        if (height == null)
                          return 'Please enter a valid number';
                        if (height < 50 || height > 300)
                          return 'Height must be between 50-300 cm';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _initialWeightController,
                    label: 'Initial Weight (kg)',
                    icon: Icons.monitor_weight,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final weight = double.tryParse(value);
                        if (weight == null)
                          return 'Please enter a valid number';
                        if (weight < 20 || weight > 500)
                          return 'Weight must be between 20-500 kg';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _goalWeightController,
              label: 'Goal Weight (kg)',
              icon: Icons.flag,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final weight = double.tryParse(value);
                  if (weight == null) return 'Please enter a valid number';
                  if (weight < 20 || weight > 500)
                    return 'Weight must be between 20-500 kg';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              value: _selectedActivityLevel,
              label: 'Activity Level',
              icon: Icons.fitness_center,
              items: const [
                'Sedentary',
                'Light',
                'Moderate',
                'Active',
                'Very Active'
              ],
              onChanged: (value) {
                setState(() => _selectedActivityLevel = value);
                final controller = Get.find<ProfileController>();
                controller.updateTempFormData('activity_level', value);
              },
            ),
            const SizedBox(height: 32),

            // Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.textMuted),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextTab,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.violetBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _nextTab() {
    if (_formKey.currentState!.validate()) {
      DefaultTabController.of(context)?.animateTo(1);
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
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
          borderSide: const BorderSide(color: AppTheme.violetBlue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.error),
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
    required List<String> items,
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
          borderSide: const BorderSide(color: AppTheme.violetBlue),
        ),
        filled: true,
        fillColor: AppTheme.cardBackground,
        labelStyle: const TextStyle(color: AppTheme.textMuted),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item.toLowerCase(),
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      dropdownColor: AppTheme.cardBackground,
      style: const TextStyle(color: AppTheme.textMain),
    );
  }

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required DateTime? selectedDate,
    required void Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ??
              DateTime.now().subtract(const Duration(days: 365 * 25)),
          firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.cardBackground,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textMuted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedDate != null
                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : label,
                style: TextStyle(
                  color: selectedDate != null
                      ? AppTheme.textMain
                      : AppTheme.textMuted,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(Icons.calendar_today, color: AppTheme.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}

// Medical History Tab
class MedicalHistoryTab extends StatefulWidget {
  const MedicalHistoryTab({Key? key}) : super(key: key);

  @override
  State<MedicalHistoryTab> createState() => _MedicalHistoryTabState();
}

class _MedicalHistoryTabState extends State<MedicalHistoryTab> {
  final _formKey = GlobalKey<FormState>();
  final _medicalConditionsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _surgeriesController = TextEditingController();
  final _giSymptomsController = TextEditingController();
  final _bloodTestController = TextEditingController();
  final _vitaminIntakeController = TextEditingController();

  String? _selectedSmokingStatus;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _setupFormListeners();
  }

  void _setupFormListeners() {
    final controller = Get.find<ProfileController>();
    
    _medicalConditionsController.addListener(() {
      controller.updateTempFormData('medical_conditions', _medicalConditionsController.text);
    });
    _allergiesController.addListener(() {
      controller.updateTempFormData('allergies', _allergiesController.text);
    });
    _medicationsController.addListener(() {
      controller.updateTempFormData('medications', _medicationsController.text);
    });
    _surgeriesController.addListener(() {
      controller.updateTempFormData('surgeries', _surgeriesController.text);
    });
    _giSymptomsController.addListener(() {
      controller.updateTempFormData('gi_symptoms', _giSymptomsController.text);
    });
    _bloodTestController.addListener(() {
      controller.updateTempFormData('recent_blood_test', _bloodTestController.text);
    });
    _vitaminIntakeController.addListener(() {
      controller.updateTempFormData('vitamin_intake', _vitaminIntakeController.text);
    });
  }

  void _loadProfileData() {
    final controller = Get.find<ProfileController>();
    final profile = controller.profile.value;

    if (profile != null) {
      _medicalConditionsController.text =
          profile.patient.medicalConditions ?? '';
      _allergiesController.text = profile.patient.allergies ?? '';
      _medicationsController.text = profile.patient.medications ?? '';
      _surgeriesController.text = profile.patient.surgeries ?? '';
      _giSymptomsController.text = profile.patient.giSymptoms ?? '';
      _bloodTestController.text = profile.patient.recentBloodTest ?? '';
      _vitaminIntakeController.text = profile.patient.vitaminIntake ?? '';
      _selectedSmokingStatus = profile.patient.smokingStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Medical Conditions'),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _medicalConditionsController,
              label: 'Medical Conditions',
              icon: Icons.medical_services,
              hint: 'List any medical conditions you have...',
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Allergies & Medications'),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _allergiesController,
              label: 'Allergies',
              icon: Icons.warning,
              hint: 'List any allergies you have...',
            ),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _medicationsController,
              label: 'Current Medications',
              icon: Icons.medication,
              hint: 'List your current medications...',
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Medical History'),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _surgeriesController,
              label: 'Previous Surgeries',
              icon: Icons.local_hospital,
              hint: 'List any previous surgeries...',
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              value: _selectedSmokingStatus,
              label: 'Smoking Status',
              icon: Icons.smoking_rooms,
              items: const ['Never', 'Former', 'Current'],
              onChanged: (value) {
                setState(() => _selectedSmokingStatus = value);
                final controller = Get.find<ProfileController>();
                controller.updateTempFormData('smoking_status', value);
              },
            ),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _bloodTestController,
              label: 'Recent Blood Test Results',
              icon: Icons.bloodtype,
              hint: 'Enter recent blood test results...',
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Symptoms & Supplements'),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _giSymptomsController,
              label: 'GI Symptoms',
              icon: Icons.sick,
              hint: 'Describe any gastrointestinal symptoms...',
            ),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _vitaminIntakeController,
              label: 'Vitamin/Supplement Intake',
              icon: Icons.medical_information,
              hint: 'List vitamins and supplements you take...',
            ),
            const SizedBox(height: 32),

            // Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        DefaultTabController.of(context)?.animateTo(0),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.textMuted),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextTab,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.violetBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _nextTab() {
    if (_formKey.currentState!.validate()) {
      DefaultTabController.of(context)?.animateTo(2);
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textMain,
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      maxLength: 2000,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
          borderSide: const BorderSide(color: AppTheme.violetBlue),
        ),
        filled: true,
        fillColor: AppTheme.cardBackground,
        labelStyle: const TextStyle(color: AppTheme.textMuted),
        hintStyle: TextStyle(color: AppTheme.textMuted.withOpacity(0.7)),
      ),
      style: const TextStyle(color: AppTheme.textMain),
      validator: (value) {
        if (value != null && value.length > 2000) {
          return 'Text must be less than 2000 characters';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
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
          borderSide: const BorderSide(color: AppTheme.violetBlue),
        ),
        filled: true,
        fillColor: AppTheme.cardBackground,
        labelStyle: const TextStyle(color: AppTheme.textMuted),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item.toLowerCase(),
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      dropdownColor: AppTheme.cardBackground,
      style: const TextStyle(color: AppTheme.textMain),
    );
  }
}

// Food History Tab
class FoodHistoryTab extends StatefulWidget {
  const FoodHistoryTab({Key? key}) : super(key: key);

  @override
  State<FoodHistoryTab> createState() => _FoodHistoryTabState();
}

class _FoodHistoryTabState extends State<FoodHistoryTab> {
  final _formKey = GlobalKey<FormState>();
  final _dietaryPreferencesController = TextEditingController();
  final _alcoholIntakeController = TextEditingController();
  final _coffeeIntakeController = TextEditingController();
  final _previousDietsController = TextEditingController();
  final _weightHistoryController = TextEditingController();
  final _dailyRoutineController = TextEditingController();
  final _physicalActivityController = TextEditingController();
  final _subscriptionReasonController = TextEditingController();
  final _additionalNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _setupFormListeners();
  }

  void _setupFormListeners() {
    final controller = Get.find<ProfileController>();
    
    _dietaryPreferencesController.addListener(() {
      controller.updateTempFormData('dietary_preferences', _dietaryPreferencesController.text);
    });
    _alcoholIntakeController.addListener(() {
      controller.updateTempFormData('alcohol_intake', _alcoholIntakeController.text);
    });
    _coffeeIntakeController.addListener(() {
      controller.updateTempFormData('coffee_intake', _coffeeIntakeController.text);
    });
    _previousDietsController.addListener(() {
      controller.updateTempFormData('previous_diets', _previousDietsController.text);
    });
    _weightHistoryController.addListener(() {
      controller.updateTempFormData('weight_history', _weightHistoryController.text);
    });
    _dailyRoutineController.addListener(() {
      controller.updateTempFormData('daily_routine', _dailyRoutineController.text);
    });
    _physicalActivityController.addListener(() {
      controller.updateTempFormData('physical_activity_details', _physicalActivityController.text);
    });
    _subscriptionReasonController.addListener(() {
      controller.updateTempFormData('subscription_reason', _subscriptionReasonController.text);
    });
    _additionalNotesController.addListener(() {
      controller.updateTempFormData('notes', _additionalNotesController.text);
    });
  }

  void _loadProfileData() {
    final controller = Get.find<ProfileController>();
    final profile = controller.profile.value;

    if (profile != null) {
      _dietaryPreferencesController.text =
          profile.patient.dietaryPreferences ?? '';
      _alcoholIntakeController.text = profile.patient.alcoholIntake ?? '';
      _coffeeIntakeController.text = profile.patient.coffeeIntake ?? '';
      _previousDietsController.text = profile.patient.previousDiets ?? '';
      _weightHistoryController.text =
          profile.patient.weightHistory?.toString() ?? '';
      _dailyRoutineController.text = profile.patient.dailyRoutine ?? '';
      _physicalActivityController.text =
          profile.patient.physicalActivityDetails ?? '';
      _subscriptionReasonController.text =
          profile.patient.subscriptionReason ?? '';
      _additionalNotesController.text = profile.patient.notes ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Dietary Preferences'),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _dietaryPreferencesController,
              label: 'Dietary Preferences',
              icon: Icons.restaurant_menu,
              hint: 'e.g., Vegetarian, Vegan, Keto, Mediterranean...',
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Consumption Habits'),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _alcoholIntakeController,
              label: 'Alcohol Intake',
              icon: Icons.local_bar,
              hint: 'e.g., 2 glasses per week',
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _coffeeIntakeController,
              label: 'Coffee Intake',
              icon: Icons.coffee,
              hint: 'e.g., 3 cups per day',
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Diet History'),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _previousDietsController,
              label: 'Previous Diets Tried',
              icon: Icons.history,
              hint: 'List diets you have tried in the past...',
            ),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _weightHistoryController,
              label: 'Weight History',
              icon: Icons.show_chart,
              hint: 'Describe your weight history and changes...',
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Lifestyle'),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _dailyRoutineController,
              label: 'Daily Routine',
              icon: Icons.schedule,
              hint: 'Describe your typical daily routine...',
            ),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _physicalActivityController,
              label: 'Physical Activity Details',
              icon: Icons.fitness_center,
              hint: 'Describe your physical activities and exercise...',
            ),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _subscriptionReasonController,
              label: 'Subscription Reason',
              icon: Icons.help,
              hint: 'Why did you decide to join our program?',
            ),
            const SizedBox(height: 16),

            _buildTextArea(
              controller: _additionalNotesController,
              label: 'Additional Notes',
              icon: Icons.note,
              hint: 'Any additional information you want to share...',
            ),
            const SizedBox(height: 32),

            // Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        DefaultTabController.of(context)?.animateTo(1),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.textMuted),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveAllChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.violetBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAllChanges() async {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<ProfileController>();

      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Save Changes'),
          content: const Text(
              'Are you sure you want to save all changes to your profile?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Save'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        // Collect all data from all tabs using the controller's centralized method
        final updateData = controller.collectAllFormData();

        final success = await controller.updateProfile(updateData);

        if (success) {
          Get.back(); // Close edit profile screen
          Get.snackbar(
            'Success',
            'Profile updated successfully',
            backgroundColor: AppTheme.success,
            colorText: Colors.white,
          );
        }
      }
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textMain,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
          borderSide: const BorderSide(color: AppTheme.violetBlue),
        ),
        filled: true,
        fillColor: AppTheme.cardBackground,
        labelStyle: const TextStyle(color: AppTheme.textMuted),
        hintStyle: TextStyle(color: AppTheme.textMuted.withOpacity(0.7)),
      ),
      style: const TextStyle(color: AppTheme.textMain),
      validator: (value) {
        if (value != null && value.length > 255) {
          return 'Text must be less than 255 characters';
        }
        return null;
      },
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      maxLength: 2000,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
          borderSide: const BorderSide(color: AppTheme.violetBlue),
        ),
        filled: true,
        fillColor: AppTheme.cardBackground,
        labelStyle: const TextStyle(color: AppTheme.textMuted),
        hintStyle: TextStyle(color: AppTheme.textMuted.withOpacity(0.7)),
      ),
      style: const TextStyle(color: AppTheme.textMain),
      validator: (value) {
        if (value != null && value.length > 2000) {
          return 'Text must be less than 2000 characters';
        }
        return null;
      },
    );
  }
}
