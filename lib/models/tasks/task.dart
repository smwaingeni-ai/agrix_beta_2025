import 'dart:convert';

/// 🔹 Represents a task assigned to an officer or user in the system.
class Task {
  final String id;
  final String title;
  final String description;
  final String status; // e.g. 'Pending', 'In Progress', 'Completed'
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  /// 🔹 Empty instance for form defaults or placeholders
  factory Task.empty() {
    return Task(
      id: '',
      title: '',
      description: '',
      status: 'Pending',
      createdAt: DateTime.now(),
    );
  }

  /// 🔁 Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Pending',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// 🔁 Convert Task to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };

  /// 🧪 For debugging/logging
  @override
  String toString() =>
      'Task(id: $id, title: $title, status: $status, createdAt: $createdAt)';

  /// ⚖️ Equality override
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          status == other.status &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      status.hashCode ^
      createdAt.hashCode;

  /// ✏️ Clone with optional modifications
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
