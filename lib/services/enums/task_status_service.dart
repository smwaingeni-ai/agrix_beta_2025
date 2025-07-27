// lib/services/enums/task_status_service.dart

import 'package:agrix_beta_2025/models/core/enums/task_status.dart';

/// 🧭 TaskStatusService: Provides label mapping for TaskStatus enum
class TaskStatusService {
  /// 🔁 Returns all possible task statuses
  static List<TaskStatus> getAll() => TaskStatus.values;

  /// 🏷️ Maps TaskStatus enum to human-readable label
  static String getLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// 🔄 Converts a string label to TaskStatus enum
  static TaskStatus? fromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'pending':
        return TaskStatus.pending;
      case 'in progress':
        return TaskStatus.inProgress;
      case 'completed':
        return TaskStatus.completed;
      case 'cancelled':
        return TaskStatus.cancelled;
      default:
        return null;
    }
  }
}
