import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'chat_view.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: AppTheme.background,
              elevation: 0,
              title: Text(
                'More',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSection(
                    context,
                    'Diet & Nutrition',
                    [
                      _buildMenuItem(
                        context,
                        'Meal Plan',
                        'View and manage your meal plans',
                        Icons.restaurant_menu_outlined,
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        'Food Diary',
                        'Track your daily food intake',
                        Icons.book_outlined,
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        'Water Intake',
                        'Monitor your water consumption',
                        Icons.water_drop_outlined,
                        () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Health & Fitness',
                    [
                      _buildMenuItem(
                        context,
                        'Workout Tracker',
                        'Record and track your exercises',
                        Icons.fitness_center_outlined,
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        'Sleep Tracker',
                        'Monitor your sleep patterns',
                        Icons.bedtime_outlined,
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        'Health Metrics',
                        'Track various health indicators',
                        Icons.favorite_outline,
                        () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Support & Settings',
                    [
                      _buildMenuItem(
                        context,
                        'Chat with Nutritionist',
                        'Get professional advice',
                        Icons.chat_outlined,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatView(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        'Notifications',
                        'Manage your app notifications',
                        Icons.notifications_outlined,
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        'Privacy Settings',
                        'Control your data and privacy',
                        Icons.privacy_tip_outlined,
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        'Help & Support',
                        'Get help and contact support',
                        Icons.help_outline,
                        () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'About',
                    [
                      _buildMenuItem(
                        context,
                        'Terms of Service',
                        'Read our terms and conditions',
                        Icons.description_outlined,
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        'Privacy Policy',
                        'Learn about our privacy policy',
                        Icons.policy_outlined,
                        () {},
                      ),
                      _buildMenuItem(
                        context,
                        'App Version',
                        'v1.0.0',
                        Icons.info_outline,
                        () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildFeedbackButton(context),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Container(
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
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.cardBackground,
              width: 1,
            ),
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
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMuted,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.violetBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.feedback_outlined),
      label: Text(
        'Send Feedback',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
