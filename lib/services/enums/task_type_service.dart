// lib/services/enums/task_type_service.dart

import 'package:agrix_beta_2025/models/core/enums/task_type.dart';

/// 🧭 TaskTypeService: Provides label mapping for TaskType enum
class TaskTypeService {
  /// 🔁 Returns all supported task types
  static List<TaskType> getAll() => TaskType.values;

  /// 🏷️ Maps TaskType enum to readable label
  static String getLabel(TaskType type) {
    switch (type) {
      case TaskType.monitoring:
        return 'Monitoring';
      case TaskType.training:
        return 'Training';
      case TaskType.inspection:
        return 'Inspection';
      case TaskType.other:
        return 'Other';
    }
  }

  /// 🔄 Converts a label string to TaskType enum
  static TaskType? fromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'monitoring':
        return TaskType.monitoring;
      case 'training':
        return TaskType.training;
      case 'inspection':
        return TaskType.inspection;
      case 'other':
        return TaskType.other;
      default:
        return null;
    }
  }
}
