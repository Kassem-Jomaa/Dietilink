import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../progress/controllers/progress_controller.dart';
import '../../progress/models/progress_model.dart';
import '../../appointments/models/appointment_model.dart';
import '../../../core/services/api_service.dart';
import '../models/recent_activity_model.dart';

class DashboardController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final ProgressController _progressController = Get.find<ProgressController>();
  final ApiService _apiService = Get.find<ApiService>();

  // Dashboard data observables
  final Rx<ProgressStatistics?> dashboardStats = Rx<ProgressStatistics?>(null);
  final Rx<ProgressEntry?> latestProgress = Rx<ProgressEntry?>(null);
  final RxList<RecentActivity> recentActivities = <RecentActivity>[].obs;
  final RxList<Appointment> upcomingAppointments = <Appointment>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingActivities = false.obs;
  final RxBool isLoadingUpcomingAppointments = false.obs;
  final RxString error = ''.obs;
  final RxBool isRefreshing =
      false.obs; // Prevent multiple simultaneous refreshes

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();

    // Remove reactive listeners that cause infinite loops
    // The data will be refreshed manually when needed
  }

  Future<void> loadDashboardData() async {
    if (isRefreshing.value) return;

    try {
      isRefreshing.value = true;
      isLoading.value = true;
      error.value = '';

      print('🔄 Loading dashboard data...');

      // Load data sequentially since methods return void
      await _loadProgressStatistics();
      await _loadLatestProgress();
      await _loadRecentActivities();
      await _loadUpcomingAppointments();

      print('✅ Dashboard data loaded successfully');
    } catch (e) {
      print('❌ Error loading dashboard data: $e');
      error.value = 'Failed to load dashboard data';
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> _loadProgressStatistics() async {
    try {
      await _progressController.getProgressStatistics();
      dashboardStats.value = _progressController.progressStatistics.value;
    } catch (e) {
      print('❌ Error loading progress statistics: $e');
    }
  }

  Future<void> _loadLatestProgress() async {
    try {
      await _progressController.getProgressHistory();
      final history = _progressController.progressHistory.value;
      if (history != null && history.progressEntries.isNotEmpty) {
        latestProgress.value = history.progressEntries.first;
      }
    } catch (e) {
      print('❌ Error loading latest progress: $e');
    }
  }

  Future<void> _loadRecentActivities() async {
    try {
      isLoadingActivities.value = true;

      // Load progress entries for activities
      await _progressController.getProgressHistory();
      final history = _progressController.progressHistory.value;
      final activities = <RecentActivity>[];

      if (history != null) {
        // Convert progress entries to activities
        for (final entry in history.progressEntries.take(5)) {
          activities.add(RecentActivity.fromProgressEntry(entry.toJson()));
        }
      }

      // TODO: Add other activity types (appointments, meal plans, etc.)

      recentActivities.assignAll(activities);
    } catch (e) {
      print('❌ Error loading recent activities: $e');
    } finally {
      isLoadingActivities.value = false;
    }
  }

  Future<void> _loadUpcomingAppointments() async {
    try {
      isLoadingUpcomingAppointments.value = true;

      print('🔄 Loading upcoming appointments...');

      // Call the real appointments API endpoint
      final response = await _apiService
          .get('/appointments', queryParameters: {'per_page': 10});

      print('📊 Appointments API Response: $response');

      // Handle different possible API response structures
      List<dynamic>? appointmentsData;

      if (response['data'] != null) {
        if (response['data'] is List) {
          appointmentsData = response['data'] as List<dynamic>;
        } else if (response['data']['appointments'] != null) {
          appointmentsData = response['data']['appointments'] as List<dynamic>;
        } else if (response['data']['data'] != null) {
          appointmentsData = response['data']['data'] as List<dynamic>;
        }
      } else if (response['appointments'] != null) {
        appointmentsData = response['appointments'] as List<dynamic>;
      }

      if (appointmentsData != null) {
        print('📋 Found ${appointmentsData.length} appointments in response');

        final appointments = <Appointment>[];

        for (final json in appointmentsData) {
          try {
            final appointment =
                Appointment.fromJson(json as Map<String, dynamic>);
            print(
                '✅ Parsed appointment: ${appointment.id} - ${appointment.typeText} on ${appointment.formattedDate}');
            appointments.add(appointment);
          } catch (e) {
            print('❌ Error parsing appointment: $e');
            print('📄 Raw appointment data: $json');
          }
        }

        // Filter upcoming appointments and remove duplicates
        final upcomingAppointmentsList =
            appointments.where((a) => a.isUpcoming).toList();

        // Remove duplicates by ID
        final uniqueAppointments = {
          for (var appointment in upcomingAppointmentsList)
            appointment.id: appointment
        }.values.toList();

        print(
            '📅 Found ${upcomingAppointmentsList.length} upcoming appointments');
        print(
            '🆔 After deduplication: ${uniqueAppointments.length} unique appointments');

        upcomingAppointments.assignAll(uniqueAppointments);
      } else {
        print('⚠️ No appointments data found in API response');
        upcomingAppointments.clear();
      }
    } catch (e) {
      print('❌ Error loading upcoming appointments: $e');
      upcomingAppointments.clear();
    } finally {
      isLoadingUpcomingAppointments.value = false;
    }
  }

  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  /// Get current weight for dashboard display
  String get currentWeight {
    final stats = dashboardStats.value;
    if (stats != null) {
      return stats.currentWeight.toStringAsFixed(1);
    }
    return latestProgress.value?.weight.toStringAsFixed(1) ?? '0.0';
  }

  /// Get goal weight (placeholder - could be from user profile)
  String get goalWeight {
    // This could be fetched from user profile or goals API
    return '70.0';
  }

  /// Calculate days left (placeholder - could be from goals)
  String get daysLeft {
    // This could be calculated from goal date
    return '15';
  }

  /// Calculate progress percentage
  String get progressPercentage {
    final stats = dashboardStats.value;
    if (stats != null && stats.initialWeight > 0) {
      final totalWeightToLose = stats.initialWeight - 70.0; // Goal weight
      final weightLost = stats.initialWeight - stats.currentWeight;
      final percentage =
          (weightLost / totalWeightToLose * 100).clamp(0.0, 100.0);
      return percentage.toStringAsFixed(0);
    }
    return '0';
  }

  /// Get weight change for display
  String get weightChange {
    final stats = dashboardStats.value;
    if (stats != null) {
      final change = stats.weightChange;
      final prefix = change > 0 ? '+' : '';
      return '$prefix${change.toStringAsFixed(1)}';
    }
    return '0.0';
  }

  /// Get total entries count
  int get totalEntries {
    final stats = dashboardStats.value;
    return stats?.totalEntries ?? 0;
  }

  /// Check if user has any progress data
  bool get hasProgressData {
    return latestProgress.value != null || dashboardStats.value != null;
  }

  void logout() {
    _authController.logout();
  }
}
