import 'package:agrix_beta_2025/models/core/enums/task_priority.dart';

class TaskPriorityService {
  static List<TaskPriority> getAll() => TaskPriority.values;

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
      default:
        return 'Unknown';
    }
  }

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
