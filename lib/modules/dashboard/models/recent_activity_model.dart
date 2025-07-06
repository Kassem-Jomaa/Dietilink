import 'package:flutter/material.dart';

/// Model for recent activities in the dashboard
class RecentActivity {
  final String id;
  final String title;
  final String description;
  final String value;
  final String timeAgo;
  final ActivityType type;
  final IconData icon;
  final Color color;

  RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.value,
    required this.timeAgo,
    required this.type,
    required this.icon,
    required this.color,
  });

  factory RecentActivity.fromProgressEntry(Map<String, dynamic> entry) {
    final weight = entry['weight']?.toString() ?? '0';
    final date = DateTime.tryParse(entry['measurement_date'] ?? '');
    final timeAgo = _getTimeAgo(date);

    return RecentActivity(
      id: entry['id']?.toString() ?? '',
      title: 'Weight Update',
      description: 'Progress measurement recorded',
      value: '$weight kg',
      timeAgo: timeAgo,
      type: ActivityType.progress,
      icon: Icons.monitor_weight_outlined,
      color: Colors.blue,
    );
  }

  factory RecentActivity.fromAppointment(Map<String, dynamic> appointment) {
    final date = DateTime.tryParse(appointment['appointment_date'] ?? '');
    final timeAgo = _getTimeAgo(date);
    final status = appointment['status'] ?? '';

    return RecentActivity(
      id: appointment['id']?.toString() ?? '',
      title: 'Appointment ${status == 'completed' ? 'Completed' : 'Scheduled'}',
      description: appointment['notes'] ?? 'Health consultation',
      value: appointment['appointment_type']?['name'] ?? 'Consultation',
      timeAgo: timeAgo,
      type: ActivityType.appointment,
      icon: Icons.event,
      color: status == 'completed' ? Colors.green : Colors.orange,
    );
  }

  factory RecentActivity.fromMealPlan(Map<String, dynamic> mealPlan) {
    final date = DateTime.tryParse(mealPlan['created_at'] ?? '');
    final timeAgo = _getTimeAgo(date);

    return RecentActivity(
      id: mealPlan['id']?.toString() ?? '',
      title: 'Meal Plan Created',
      description: 'New nutrition plan generated',
      value: mealPlan['name'] ?? 'Custom Plan',
      timeAgo: timeAgo,
      type: ActivityType.mealPlan,
      icon: Icons.restaurant,
      color: Colors.purple,
    );
  }

  factory RecentActivity.fromChatMessage(Map<String, dynamic> message) {
    final date = DateTime.tryParse(message['timestamp'] ?? '');
    final timeAgo = _getTimeAgo(date);

    return RecentActivity(
      id: message['id']?.toString() ?? '',
      title: 'AI Chat',
      description: 'Nutrition advice received',
      value: 'Chat session',
      timeAgo: timeAgo,
      type: ActivityType.chat,
      icon: Icons.chat,
      color: Colors.teal,
    );
  }

  static String _getTimeAgo(DateTime? date) {
    if (date == null) return 'Unknown time';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// Types of activities that can appear in recent activities
enum ActivityType {
  progress,
  appointment,
  mealPlan,
  chat,
  measurement,
  goal,
}

/// Extension to get display information for activity types
extension ActivityTypeExtension on ActivityType {
  String get displayName {
    switch (this) {
      case ActivityType.progress:
        return 'Progress';
      case ActivityType.appointment:
        return 'Appointment';
      case ActivityType.mealPlan:
        return 'Meal Plan';
      case ActivityType.chat:
        return 'Chat';
      case ActivityType.measurement:
        return 'Measurement';
      case ActivityType.goal:
        return 'Goal';
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityType.progress:
        return Icons.trending_up;
      case ActivityType.appointment:
        return Icons.event;
      case ActivityType.mealPlan:
        return Icons.restaurant;
      case ActivityType.chat:
        return Icons.chat;
      case ActivityType.measurement:
        return Icons.straighten;
      case ActivityType.goal:
        return Icons.flag;
    }
  }

  Color get color {
    switch (this) {
      case ActivityType.progress:
        return Colors.blue;
      case ActivityType.appointment:
        return Colors.orange;
      case ActivityType.mealPlan:
        return Colors.purple;
      case ActivityType.chat:
        return Colors.teal;
      case ActivityType.measurement:
        return Colors.indigo;
      case ActivityType.goal:
        return Colors.green;
    }
  }
}
