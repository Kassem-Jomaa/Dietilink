import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../chatbot/views/chatbot_view.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'More',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, 'Health & Wellness', [
            _buildMenuItem(
              context,
              icon: Icons.chat,
              title: 'AI Health Assistant',
              subtitle: 'Get personalized health advice',
              onTap: () => Get.toNamed('/chatbot'),
            ),
            _buildMenuItem(
              context,
              icon: Icons.favorite,
              title: 'Health Tips',
              subtitle: 'Daily wellness tips and advice',
              onTap: () => Get.snackbar(
                  'Coming Soon', 'Health tips feature will be available soon!',
                  snackPosition: SnackPosition.BOTTOM),
            ),
            _buildMenuItem(
              context,
              icon: Icons.water_drop,
              title: 'Hydration Tracker',
              subtitle: 'Track your daily water intake',
              onTap: () => Get.snackbar(
                  'Coming Soon', 'Hydration tracker will be available soon!',
                  snackPosition: SnackPosition.BOTTOM),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Appointments', [
            _buildMenuItem(
              context,
              icon: Icons.event,
              title: 'My Appointments',
              subtitle: 'View and manage your appointments',
              onTap: () => Get.toNamed('/appointments'),
            ),
            _buildMenuItem(
              context,
              icon: Icons.add_circle,
              title: 'Book Appointment',
              subtitle: 'Schedule a new consultation',
              onTap: () => Get.toNamed('/appointments/book'),
            ),
            _buildMenuItem(
              context,
              icon: Icons.history,
              title: 'Appointment History',
              subtitle: 'View past appointments',
              onTap: () => Get.toNamed('/appointments/history'),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Settings & Preferences', [
            _buildMenuItem(
              context,
              icon: Icons.settings,
              title: 'Settings & Preferences',
              subtitle: 'Manage app settings and preferences',
              onTap: () => Get.toNamed('/settings'),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Support & Feedback', [
            _buildMenuItem(
              context,
              icon: Icons.help,
              title: 'Help & FAQ',
              subtitle: 'Get help and find answers',
              onTap: () => Get.snackbar(
                  'Coming Soon', 'Help section will be available soon!',
                  snackPosition: SnackPosition.BOTTOM),
            ),
            _buildMenuItem(
              context,
              icon: Icons.feedback,
              title: 'Send Feedback',
              subtitle: 'Share your thoughts with us',
              onTap: () => Get.snackbar(
                  'Coming Soon', 'Feedback feature will be available soon!',
                  snackPosition: SnackPosition.BOTTOM),
            ),
            _buildMenuItem(
              context,
              icon: Icons.info,
              title: 'About',
              subtitle: 'App version and information',
              onTap: () => Get.snackbar(
                  'Coming Soon', 'About section will be available soon!',
                  snackPosition: SnackPosition.BOTTOM),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Account', [
            _buildMenuItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              onTap: () => Get.snackbar(
                  'Coming Soon', 'Logout feature will be available soon!',
                  snackPosition: SnackPosition.BOTTOM),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: Theme.of(context).hintColor,
            ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).hintColor,
      ),
      onTap: onTap,
    );
  }
}
