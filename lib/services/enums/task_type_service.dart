import 'package:agrix_beta_2025/models/core/enums/task_type.dart';

class TaskTypeService {
  static List<TaskType> getAll() => TaskType.values;

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
      default:
        return 'Unknown';
    }
  }

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
