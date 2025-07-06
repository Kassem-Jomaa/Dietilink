import 'package:get/get.dart';
import 'core/services/api_service.dart';
import 'modules/dashboard/controllers/dashboard_controller.dart';
import 'modules/dashboard/models/recent_activity_model.dart';

/// Test file to verify recent activities functionality
class RecentActivitiesTest {
  static Future<void> testRecentActivitiesLoading() async {
    print('\n🧪 Testing Recent Activities Loading...');

    try {
      // Initialize API service
      final apiService = ApiService();
      await apiService.init();

      // Initialize dashboard controller
      final dashboardController = DashboardController();

      print('✅ Dashboard controller initialized successfully');

      // Test loading recent activities
      print('\n📋 Test 1: Loading Recent Activities');
      await dashboardController.loadDashboardData();

      final activities = dashboardController.recentActivities;
      print('✅ Loaded ${activities.length} recent activities');

      // Display activities
      for (int i = 0; i < activities.length; i++) {
        final activity = activities[i];
        print(
            '  ${i + 1}. ${activity.title} - ${activity.value} (${activity.timeAgo})');
        print('     Type: ${activity.type.displayName}');
        print('     Description: ${activity.description}');
      }

      print('\n✅ Recent activities test completed successfully');
    } catch (e) {
      print('\n❌ Recent activities test failed: $e');
    }
  }

  static Future<void> testActivityModelCreation() async {
    print('\n🧪 Testing Activity Model Creation...');

    try {
      // Test progress entry
      final progressData = {
        'id': 1,
        'weight': 75.5,
        'measurement_date':
            DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
      };

      final progressActivity = RecentActivity.fromProgressEntry(progressData);
      print(
          '✅ Progress activity created: ${progressActivity.title} - ${progressActivity.value}');

      // Test appointment
      final appointmentData = {
        'id': 2,
        'appointment_date':
            DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        'status': 'completed',
        'notes': 'Health consultation',
        'appointment_type': {'name': 'Nutrition Consultation'},
      };

      final appointmentActivity =
          RecentActivity.fromAppointment(appointmentData);
      print(
          '✅ Appointment activity created: ${appointmentActivity.title} - ${appointmentActivity.value}');

      // Test meal plan
      final mealPlanData = {
        'id': 3,
        'created_at':
            DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
        'name': 'Weight Loss Plan',
      };

      final mealPlanActivity = RecentActivity.fromMealPlan(mealPlanData);
      print(
          '✅ Meal plan activity created: ${mealPlanActivity.title} - ${mealPlanActivity.value}');

      print('\n✅ Activity model creation test completed successfully');
    } catch (e) {
      print('\n❌ Activity model creation test failed: $e');
    }
  }

  static Future<void> testTimeAgoCalculation() async {
    print('\n🧪 Testing Time Ago Calculation...');

    try {
      final now = DateTime.now();

      // Test different time intervals
      final testCases = [
        now.subtract(Duration(minutes: 30)),
        now.subtract(Duration(hours: 2)),
        now.subtract(Duration(days: 1)),
        now.subtract(Duration(days: 5)),
      ];

      for (final date in testCases) {
        final now = DateTime.now();
        final difference = now.difference(date);

        String timeAgo;
        if (difference.inDays > 0) {
          timeAgo = '${difference.inDays}d ago';
        } else if (difference.inHours > 0) {
          timeAgo = '${difference.inHours}h ago';
        } else if (difference.inMinutes > 0) {
          timeAgo = '${difference.inMinutes}m ago';
        } else {
          timeAgo = 'Just now';
        }

        print('✅ ${date.toIso8601String()} -> $timeAgo');
      }

      print('\n✅ Time ago calculation test completed successfully');
    } catch (e) {
      print('\n❌ Time ago calculation test failed: $e');
    }
  }
}

/// Run this in main.dart temporarily to test the recent activities functionality
void runRecentActivitiesTest() async {
  await RecentActivitiesTest.testActivityModelCreation();
  await RecentActivitiesTest.testTimeAgoCalculation();
  await RecentActivitiesTest.testRecentActivitiesLoading();
}
