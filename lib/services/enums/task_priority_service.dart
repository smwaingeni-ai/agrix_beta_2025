// lib/services/enums/task_priority_service.dart

import 'package:agrix_beta_2025/models/core/enums/task_priority.dart';

/// 🧭 TaskPriorityService: Maps [TaskPriority] enum to readable labels and vice versa
class TaskPriorityService {
  /// 🔁 Returns all available task priority values
  static List<TaskPriority> getAll() => TaskPriority.values;

  /// 🏷️ Converts a [TaskPriority] enum to a display label
  static String getLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.critical:
        return 'Critical';
    }
  }

  /// 🔄 Converts a string label to a [TaskPriority] enum value
  static TaskPriority? fromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      case 'critical':
        return TaskPriority.critical;
      default:
        return null;
    }
  }
}
