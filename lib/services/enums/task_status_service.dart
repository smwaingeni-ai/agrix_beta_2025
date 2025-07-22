import 'package:agrix_beta_2025/models/core/enums/task_status.dart';

class TaskStatusService {
  static List<TaskStatus> getAll() => TaskStatus.values;

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
      default:
        return 'Unknown';
    }
  }

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
