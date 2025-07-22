/// 🔹 TaskStatus enum to represent the status of an officer task
enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}

/// 🔹 Extension for TaskStatus for parsing, label, and utility methods
extension TaskStatusExtension on TaskStatus {
  /// Returns a readable label for UI
  String get label {
    switch (this) {
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

  /// Convert enum to string for JSON or storage
  String get value => toString().split('.').last;

  /// Parse from string safely
  static TaskStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return TaskStatus.pending;
      case 'inprogress':
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'completed':
        return TaskStatus.completed;
      case 'cancelled':
        return TaskStatus.cancelled;
      default:
        return TaskStatus.pending;
    }
  }

  /// Returns all values as list of strings
  static List<String> get labels =>
      TaskStatus.values.map((e) => e.label).toList();
}
