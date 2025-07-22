enum TaskType {
  inspection,
  training,
  evaluation,
  reporting,
  other,
}

extension TaskTypeExtension on TaskType {
  String get label {
    switch (this) {
      case TaskType.inspection:
        return 'Inspection';
      case TaskType.training:
        return 'Training';
      case TaskType.evaluation:
        return 'Evaluation';
      case TaskType.reporting:
        return 'Reporting';
      case TaskType.other:
        return 'Other';
    }
  }

  String get value => toString().split('.').last;

  static TaskType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'inspection':
        return TaskType.inspection;
      case 'training':
        return TaskType.training;
      case 'evaluation':
        return TaskType.evaluation;
      case 'reporting':
        return TaskType.reporting;
      default:
        return TaskType.other;
    }
  }
}
