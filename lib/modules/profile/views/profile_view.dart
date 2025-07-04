import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../models/profile_model.dart';
import '../../auth/models/user_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_message.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed('/profile/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        Get.find<AuthController>().logout();
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingIndicator();
        }

        if (controller.errorMessage.isNotEmpty) {
          return Column(
            children: [
              ErrorMessage(
                message: controller.errorMessage.value,
                onRetry: controller.loadProfile,
              ),
              const SizedBox(height: 16),
              const Text('Showing basic profile data:'),
              const SizedBox(height: 16),
            ],
          );
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text('No profile data available'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // User Info Section
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildUserInfo(profile.user),
                    const SizedBox(height: 16),
                    _buildBmiCard(profile.bmi),
                  ],
                ),
              ),
              // Tabbed Content with fixed height
              SizedBox(
                height: 600, // Fixed height for tabs to ensure proper scrolling
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: AppTheme.violetBlue,
                        unselectedLabelColor: AppTheme.textMuted,
                        indicatorColor: AppTheme.violetBlue,
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.person),
                            text: 'Basic Info',
                          ),
                          Tab(
                            icon: Icon(Icons.medical_services),
                            text: 'Medical',
                          ),
                          Tab(
                            icon: Icon(Icons.restaurant),
                            text: 'Food History',
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildBasicInfoTab(profile.patient),
                            _buildMedicalTab(profile.patient),
                            _buildFoodHistoryTab(profile.patient),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showQuickActionsMenu(context);
        },
        backgroundColor: AppTheme.violetBlue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        tooltip: 'Quick Actions',
      ),
    );
  }

  Widget _buildUserInfo(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryAccent.withOpacity(0.2),
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textMain,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.role?.capitalize ?? 'Not specified',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoRow('Username', user.username),
            if (user.email != null) _buildInfoRow('Email', user.email!),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiCard(BmiModel? bmi) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'BMI Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                  ),
                ),
                if (bmi == null)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => controller.refreshBmi(),
                    tooltip: 'Refresh BMI data',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (bmi != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBmiStat('Current', bmi.current.toStringAsFixed(1)),
                  _buildBmiStat('Initial', bmi.initial.toStringAsFixed(1)),
                  _buildBmiStat('Change', '${bmi.change.toStringAsFixed(1)}'),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getBmiColor(bmi.color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getBmiColor(bmi.color),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    bmi.category,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getBmiColor(bmi.color),
                    ),
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.violetBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.violetBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.calculate,
                      size: 48,
                      color: AppTheme.violetBlue.withOpacity(0.7),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'BMI data not available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add your height and current weight in your profile to calculate BMI',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed('/profile/edit'),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Update Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.violetBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfo(PatientModel patient) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 16),
            if (patient.phone != null) _buildInfoRow('Phone', patient.phone!),
            if (patient.gender != null)
              _buildInfoRow('Gender', patient.gender!),
            if (patient.birthDate != null)
              _buildInfoRow(
                  'Birth Date', patient.birthDate!.toString().split(' ')[0]),
            if (patient.age != null)
              _buildInfoRow('Age', patient.age.toString()),
            if (patient.occupation != null)
              _buildInfoRow('Occupation', patient.occupation!),
            if (patient.height != null)
              _buildInfoRow('Height', '${patient.height} cm'),
            if (patient.initialWeight != null)
              _buildInfoRow('Initial Weight', '${patient.initialWeight} kg'),
            if (patient.goalWeight != null)
              _buildInfoRow('Goal Weight', '${patient.goalWeight} kg'),
            if (patient.activityLevel != null)
              _buildInfoRow('Activity Level', patient.activityLevel!),
            if (patient.medicalConditions?.isNotEmpty ?? false)
              _buildInfoRow('Medical Conditions', patient.medicalConditions!),
            if (patient.allergies?.isNotEmpty ?? false)
              _buildInfoRow('Allergies', patient.allergies!),
            if (patient.medications?.isNotEmpty ?? false)
              _buildInfoRow('Medications', patient.medications!),
            if (patient.surgeries?.isNotEmpty ?? false)
              _buildInfoRow('Surgeries', patient.surgeries!),
            if (patient.smokingStatus != null)
              _buildInfoRow('Smoking Status', patient.smokingStatus!),
            if (patient.giSymptoms?.isNotEmpty ?? false)
              _buildInfoRow('GI Symptoms', patient.giSymptoms!),
            if (patient.dietaryPreferences?.isNotEmpty ?? false)
              _buildInfoRow('Dietary Preferences', patient.dietaryPreferences!),
            if (patient.alcoholIntake != null)
              _buildInfoRow('Alcohol Intake', patient.alcoholIntake!),
            if (patient.coffeeIntake != null)
              _buildInfoRow('Coffee Intake', patient.coffeeIntake!),
            if (patient.vitaminIntake?.isNotEmpty ?? false)
              _buildInfoRow('Vitamin Intake', patient.vitaminIntake!),
            if (patient.dailyRoutine != null)
              _buildInfoRow('Daily Routine', patient.dailyRoutine!),
            if (patient.physicalActivityDetails != null)
              _buildInfoRow(
                  'Physical Activity', patient.physicalActivityDetails!),
            if (patient.previousDiets?.isNotEmpty ?? false)
              _buildInfoRow('Previous Diets', patient.previousDiets!),
            if (patient.subscriptionReason != null)
              _buildInfoRow('Subscription Reason', patient.subscriptionReason!),
            if (patient.notes != null) _buildInfoRow('Notes', patient.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textMain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBmiStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textMain,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getBmiColor(String color) {
    switch (color.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'yellow':
        return Colors.yellow[700]!;
      case 'green':
        return AppTheme.success;
      default:
        return AppTheme.primaryAccent;
    }
  }

  Widget _buildBasicInfoTab(PatientModel patient) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Personal Information'),
          const SizedBox(height: 16),
          if (patient.phone != null) _buildInfoRow('Phone', patient.phone!),
          if (patient.gender != null) _buildInfoRow('Gender', patient.gender!),
          if (patient.birthDate != null)
            _buildInfoRow(
                'Birth Date', patient.birthDate!.toString().split(' ')[0]),
          if (patient.age != null) _buildInfoRow('Age', patient.age.toString()),
          if (patient.occupation != null)
            _buildInfoRow('Occupation', patient.occupation!),
          const SizedBox(height: 24),
          _buildSectionHeader('Physical Information'),
          const SizedBox(height: 16),
          if (patient.height != null)
            _buildInfoRow('Height', '${patient.height} cm'),
          if (patient.initialWeight != null)
            _buildInfoRow('Initial Weight', '${patient.initialWeight} kg'),
          if (patient.goalWeight != null)
            _buildInfoRow('Goal Weight', '${patient.goalWeight} kg'),
          if (patient.activityLevel != null)
            _buildInfoRow('Activity Level', patient.activityLevel!),
          const SizedBox(height: 24),
          _buildSectionHeader('Additional Information'),
          const SizedBox(height: 16),
          if (patient.subscriptionReason != null)
            _buildInfoRow('Subscription Reason', patient.subscriptionReason!),
          if (patient.notes != null) _buildInfoRow('Notes', patient.notes!),
        ],
      ),
    );
  }

  Widget _buildMedicalTab(PatientModel patient) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Medical Conditions'),
          const SizedBox(height: 16),
          if (patient.medicalConditions?.isNotEmpty ?? false)
            _buildInfoRow('Medical Conditions', patient.medicalConditions!)
          else
            _buildEmptyInfo('No medical conditions recorded'),
          const SizedBox(height: 24),
          _buildSectionHeader('Allergies & Medications'),
          const SizedBox(height: 16),
          if (patient.allergies?.isNotEmpty ?? false)
            _buildInfoRow('Allergies', patient.allergies!)
          else
            _buildEmptyInfo('No allergies recorded'),
          const SizedBox(height: 16),
          if (patient.medications?.isNotEmpty ?? false)
            _buildInfoRow('Medications', patient.medications!)
          else
            _buildEmptyInfo('No medications recorded'),
          const SizedBox(height: 24),
          _buildSectionHeader('Medical History'),
          const SizedBox(height: 16),
          if (patient.surgeries?.isNotEmpty ?? false)
            _buildInfoRow('Surgeries', patient.surgeries!)
          else
            _buildEmptyInfo('No surgeries recorded'),
          const SizedBox(height: 16),
          if (patient.smokingStatus != null)
            _buildInfoRow('Smoking Status', patient.smokingStatus!)
          else
            _buildEmptyInfo('Smoking status not specified'),
          const SizedBox(height: 16),
          if (patient.recentBloodTest != null)
            _buildInfoRow('Recent Blood Test', patient.recentBloodTest!)
          else
            _buildEmptyInfo('No recent blood test recorded'),
          const SizedBox(height: 24),
          _buildSectionHeader('Symptoms'),
          const SizedBox(height: 16),
          if (patient.giSymptoms?.isNotEmpty ?? false)
            _buildInfoRow('GI Symptoms', patient.giSymptoms!)
          else
            _buildEmptyInfo('No GI symptoms recorded'),
        ],
      ),
    );
  }

  Widget _buildFoodHistoryTab(PatientModel patient) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Dietary Preferences'),
          const SizedBox(height: 16),
          if (patient.dietaryPreferences?.isNotEmpty ?? false)
            _buildInfoRow('Dietary Preferences', patient.dietaryPreferences!)
          else
            _buildEmptyInfo('No dietary preferences recorded'),
          const SizedBox(height: 24),
          _buildSectionHeader('Consumption Habits'),
          const SizedBox(height: 16),
          if (patient.alcoholIntake != null)
            _buildInfoRow('Alcohol Intake', patient.alcoholIntake!)
          else
            _buildEmptyInfo('Alcohol intake not specified'),
          const SizedBox(height: 16),
          if (patient.coffeeIntake != null)
            _buildInfoRow('Coffee Intake', patient.coffeeIntake!)
          else
            _buildEmptyInfo('Coffee intake not specified'),
          const SizedBox(height: 24),
          _buildSectionHeader('Supplements'),
          const SizedBox(height: 16),
          if (patient.vitaminIntake?.isNotEmpty ?? false)
            _buildInfoRow('Vitamin Intake', patient.vitaminIntake!)
          else
            _buildEmptyInfo('No vitamin intake recorded'),
          const SizedBox(height: 24),
          _buildSectionHeader('Diet History'),
          const SizedBox(height: 16),
          if (patient.previousDiets?.isNotEmpty ?? false)
            _buildInfoRow('Previous Diets', patient.previousDiets!)
          else
            _buildEmptyInfo('No previous diets recorded'),
          const SizedBox(height: 16),
          if (patient.weightHistory?.isNotEmpty ?? false)
            _buildInfoRow('Weight History', patient.weightHistory!)
          else
            _buildEmptyInfo('No weight history recorded'),
          const SizedBox(height: 24),
          _buildSectionHeader('Lifestyle'),
          const SizedBox(height: 16),
          if (patient.dailyRoutine != null)
            _buildInfoRow('Daily Routine', patient.dailyRoutine!)
          else
            _buildEmptyInfo('Daily routine not specified'),
          const SizedBox(height: 16),
          if (patient.physicalActivityDetails != null)
            _buildInfoRow('Physical Activity', patient.physicalActivityDetails!)
          else
            _buildEmptyInfo('Physical activity not specified'),
        ],
      ),
    );
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

  Widget _buildEmptyInfo(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.textMuted.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppTheme.textMuted,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppTheme.textMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickActionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 20),

              // Action buttons
              _buildActionButton(
                icon: Icons.edit,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () {
                  Get.back();
                  Get.toNamed('/profile/edit');
                },
              ),
              const SizedBox(height: 12),

              _buildActionButton(
                icon: Icons.add_chart,
                title: 'Add Progress Entry',
                subtitle: 'Record your latest weight progress',
                onTap: () {
                  Get.back();
                  Get.toNamed('/progress/add');
                },
              ),
              const SizedBox(height: 12),

              _buildActionButton(
                icon: Icons.lock,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () {
                  Get.back();
                  Get.toNamed('/profile/change-password');
                },
              ),
              const SizedBox(height: 12),

              _buildActionButton(
                icon: Icons.refresh,
                title: 'Refresh Data',
                subtitle: 'Reload profile and BMI information',
                onTap: () {
                  Get.back();
                  controller.refresh();
                },
              ),
              const SizedBox(height: 12),

              _buildActionButton(
                icon: Icons.calculate,
                title: 'BMI Calculator',
                subtitle: 'Calculate and update your BMI',
                onTap: () {
                  Get.back();
                  _showBmiCalculator(context);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.rowHover,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.textMuted.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.violetBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.violetBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showBmiCalculator(BuildContext context) {
    final heightController = TextEditingController();
    final weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardBackground,
          title: const Text(
            'BMI Calculator',
            style: TextStyle(color: AppTheme.textMain),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final height = double.tryParse(heightController.text);
                final weight = double.tryParse(weightController.text);

                if (height != null && weight != null && height > 0) {
                  final bmi = weight / ((height / 100) * (height / 100));
                  Get.back();
                  Get.snackbar(
                    'BMI Calculated',
                    'Your BMI is: ${bmi.toStringAsFixed(1)}',
                    backgroundColor: AppTheme.success.withOpacity(0.1),
                    colorText: AppTheme.success,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Please enter valid height and weight values',
                    backgroundColor: AppTheme.error.withOpacity(0.1),
                    colorText: AppTheme.error,
                  );
                }
              },
              child: const Text('Calculate'),
            ),
          ],
        );
      },
    );
  }
}
