import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../models/profile_model.dart';
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
          return ErrorMessage(
            message: controller.errorMessage.value,
            onRetry: controller.loadProfile,
          );
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text('No profile data available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo(profile.user),
              const SizedBox(height: 24),
              _buildBmiCard(profile.bmi),
              const SizedBox(height: 24),
              _buildPatientInfo(profile.patient),
            ],
          ),
        );
      }),
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
            _buildInfoRow('Email', user.email),
            if (user.status != null) _buildInfoRow('Status', user.status!),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiCard(BmiModel bmi) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BMI Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBmiStat('Current', bmi.current.toStringAsFixed(1)),
                _buildBmiStat('Initial', bmi.initial.toStringAsFixed(1)),
                _buildBmiStat('Change', '${bmi.change.toStringAsFixed(1)}'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              _buildListInfo('Medical Conditions', patient.medicalConditions!),
            if (patient.allergies?.isNotEmpty ?? false)
              _buildListInfo('Allergies', patient.allergies!),
            if (patient.medications?.isNotEmpty ?? false)
              _buildListInfo('Medications', patient.medications!),
            if (patient.surgeries?.isNotEmpty ?? false)
              _buildListInfo('Surgeries', patient.surgeries!),
            if (patient.smokingStatus != null)
              _buildInfoRow('Smoking Status', patient.smokingStatus!),
            if (patient.giSymptoms?.isNotEmpty ?? false)
              _buildListInfo('GI Symptoms', patient.giSymptoms!),
            if (patient.dietaryPreferences?.isNotEmpty ?? false)
              _buildListInfo(
                  'Dietary Preferences', patient.dietaryPreferences!),
            if (patient.alcoholIntake != null)
              _buildInfoRow('Alcohol Intake', patient.alcoholIntake!),
            if (patient.coffeeIntake != null)
              _buildInfoRow('Coffee Intake', patient.coffeeIntake!),
            if (patient.vitaminIntake?.isNotEmpty ?? false)
              _buildListInfo('Vitamin Intake', patient.vitaminIntake!),
            if (patient.dailyRoutine != null)
              _buildInfoRow('Daily Routine', patient.dailyRoutine!),
            if (patient.physicalActivityDetails != null)
              _buildInfoRow(
                  'Physical Activity', patient.physicalActivityDetails!),
            if (patient.previousDiets?.isNotEmpty ?? false)
              _buildListInfo('Previous Diets', patient.previousDiets!),
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

  Widget _buildListInfo(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: items
                .map((item) => Chip(
                      label: Text(item),
                      backgroundColor: AppTheme.rowHover,
                      labelStyle: const TextStyle(color: AppTheme.textMain),
                    ))
                .toList(),
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
}
