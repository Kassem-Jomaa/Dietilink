import 'package:get/get.dart';
import 'core/services/api_service.dart';
import 'modules/dashboard/controllers/dashboard_controller.dart';
import 'modules/progress/controllers/progress_controller.dart';

/// Test file to verify infinite loop fix
class InfiniteLoopTest {
  static Future<void> testDashboardDataLoading() async {
    print('\n🧪 Testing Dashboard Data Loading...');

    try {
      // Initialize API service
      final apiService = ApiService();
      await apiService.init();

      // Initialize controllers
      final progressController = ProgressController();
      final dashboardController = DashboardController();

      print('✅ Controllers initialized successfully');

      // Test dashboard data loading
      print('\n📋 Test 1: Dashboard Data Loading');
      await dashboardController.refreshDashboard();
      print('✅ Dashboard data refreshed successfully');

      // Test refresh
      print('\n📋 Test 2: Dashboard Refresh');
      await dashboardController.refreshDashboard();
      print('✅ Dashboard data refreshed successfully');

      print('\n✅ Infinite loop test completed successfully');
    } catch (e) {
      print('\n❌ Infinite loop test failed: $e');
    }
  }

  static Future<void> testProgressDataLoading() async {
    print('\n🧪 Testing Progress Data Loading...');

    try {
      // Initialize API service
      final apiService = ApiService();
      await apiService.init();

      // Initialize progress controller
      final progressController = ProgressController();

      print('✅ Progress controller initialized successfully');

      // Test progress history loading
      print('\n📋 Test 1: Progress History Loading');
      await progressController.getProgressHistory();
      print('✅ Progress history loaded without infinite loop');

      // Test progress statistics loading
      print('\n📋 Test 2: Progress Statistics Loading');
      await progressController.getProgressStatistics();
      print('✅ Progress statistics loaded without infinite loop');

      print('\n✅ Progress data loading test completed successfully');
    } catch (e) {
      print('\n❌ Progress data loading test failed: $e');
    }
  }
}

/// Run this in main.dart temporarily to test the infinite loop fix
void runInfiniteLoopTest() async {
  await InfiniteLoopTest.testDashboardDataLoading();
  await InfiniteLoopTest.testProgressDataLoading();
}
