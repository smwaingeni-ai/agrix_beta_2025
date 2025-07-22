import 'package:flutter/foundation.dart';

/// 🔹 Model representing a task assigned to or completed by an officer.
class TaskModel {
  final String id;
  final String title;
  final String description;
  final String result;
  final DateTime date;

  const TaskModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.result,
    required this.date,
  });

  /// 🔹 Empty instance for default usage (e.g. forms, drafts)
  factory TaskModel.empty() {
    return TaskModel(
      title: '',
      description: '',
      result: '',
      date: DateTime.now(),
    );
  }

  /// 🔁 Convert this model into a JSON object
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'result': result,
        'date': date.toIso8601String(),
      };

  /// 🔁 Create a model from a JSON object with safe fallbacks
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      result: json['result'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    );
  }

  /// 🧪 For debugging purposes
  @override
  String toString() =>
      'TaskModel(id: $id, title: $title, result: $result, date: $date)';

  /// ⚖️ Equality override for comparing instances
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          result == other.result &&
          date == other.date;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ description.hashCode ^ result.hashCode ^ date.hashCode;

  /// ✏️ Clone with modifications
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? result,
    DateTime? date,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      result: result ?? this.result,
      date: date ?? this.date,
    );
  }
}
