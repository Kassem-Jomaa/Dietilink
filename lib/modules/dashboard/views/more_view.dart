import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../chatbot/views/chatbot_view.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'More',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Health & Wellness',
            [
              _buildMenuItem(
                icon: Icons.chat,
                title: 'AI Health Assistant',
                subtitle: 'Get personalized health advice',
                onTap: () {
                  Get.toNamed('/chatbot');
                },
              ),
              _buildMenuItem(
                icon: Icons.favorite,
                title: 'Health Tips',
                subtitle: 'Daily wellness tips and advice',
                onTap: () {
                  // TODO: Implement health tips
                  Get.snackbar(
                    'Coming Soon',
                    'Health tips feature will be available soon!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.water_drop,
                title: 'Hydration Tracker',
                subtitle: 'Track your daily water intake',
                onTap: () {
                  // TODO: Implement hydration tracker
                  Get.snackbar(
                    'Coming Soon',
                    'Hydration tracker will be available soon!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Appointments',
            [
              _buildMenuItem(
                icon: Icons.event,
                title: 'My Appointments',
                subtitle: 'View and manage your appointments',
                onTap: () {
                  Get.toNamed('/appointments');
                },
              ),
              _buildMenuItem(
                icon: Icons.add_circle,
                title: 'Book Appointment',
                subtitle: 'Schedule a new consultation',
                onTap: () {
                  Get.toNamed('/appointments/book');
                },
              ),
              _buildMenuItem(
                icon: Icons.history,
                title: 'Appointment History',
                subtitle: 'View past appointments',
                onTap: () {
                  Get.toNamed('/appointments/history');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Settings & Preferences',
            [
              _buildMenuItem(
                icon: Icons.settings,
                title: 'Settings & Preferences',
                subtitle: 'Manage app settings and preferences',
                onTap: () {
                  Get.toNamed('/settings');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Support & Feedback',
            [
              _buildMenuItem(
                icon: Icons.help,
                title: 'Help & FAQ',
                subtitle: 'Get help and find answers',
                onTap: () {
                  // TODO: Implement help section
                  Get.snackbar(
                    'Coming Soon',
                    'Help section will be available soon!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.feedback,
                title: 'Send Feedback',
                subtitle: 'Share your thoughts with us',
                onTap: () {
                  // TODO: Implement feedback
                  Get.snackbar(
                    'Coming Soon',
                    'Feedback feature will be available soon!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.info,
                title: 'About',
                subtitle: 'App version and information',
                onTap: () {
                  // TODO: Implement about section
                  Get.snackbar(
                    'Coming Soon',
                    'About section will be available soon!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Account',
            [
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: () {
                  // TODO: Implement logout
                  Get.snackbar(
                    'Coming Soon',
                    'Logout feature will be available soon!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppTheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppTheme.textMuted,
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppTheme.textMuted,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
