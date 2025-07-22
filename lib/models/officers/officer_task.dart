// 📁 lib/models/officers/officer_task.dart

import 'package:agrix_beta_2025/models/core/enums/task_status.dart';

class OfficerTask {
  final String id;
  final String title;
  final String description;
  final String assignedOfficerId;
  final String assignedOfficerName;
  final String region;
  final DateTime dueDate;
  final TaskStatus status;
  final DateTime createdAt;

  OfficerTask({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedOfficerId,
    required this.assignedOfficerName,
    required this.region,
    required this.dueDate,
    this.status = TaskStatus.pending,
    required this.createdAt,
  });

  /// 🔹 Safe empty constructor
  factory OfficerTask.empty() {
    return OfficerTask(
      id: '',
      title: '',
      description: '',
      assignedOfficerId: '',
      assignedOfficerName: '',
      region: '',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
    );
  }

  /// 🔹 From JSON
  factory OfficerTask.fromJson(Map<String, dynamic> json) {
    return OfficerTask(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      assignedOfficerId: json['assignedOfficerId'] ?? '',
      assignedOfficerName: json['assignedOfficerName'] ?? '',
      region: json['region'] ?? '',
      dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
      status: TaskStatusExtension.fromString(json['status']) ?? TaskStatus.pending,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// 🔹 To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assignedOfficerId': assignedOfficerId,
      'assignedOfficerName': assignedOfficerName,
      'region': region,
      'dueDate': dueDate.toIso8601String(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'OfficerTask(id: $id, title: $title, status: ${status.name}, due: $dueDate)';
}
