import 'package:uuid/uuid.dart';

class ProgramLog {
  final String id;
  final String programName;
  final String farmer;
  final String resource;
  final String impact;
  final String region;
  final String officer;
  final DateTime date;

  ProgramLog({
    required this.id,
    required this.programName,
    required this.farmer,
    required this.resource,
    required this.impact,
    required this.region,
    required this.officer,
    required this.date,
  });

  /// 🔹 Empty placeholder for form usage
  factory ProgramLog.empty() {
    return ProgramLog(
      id: const Uuid().v4(),
      programName: '',
      farmer: '',
      resource: '',
      impact: '',
      region: '',
      officer: '',
      date: DateTime.now(),
    );
  }

  /// 🔹 Deserialize from JSON
  factory ProgramLog.fromJson(Map<String, dynamic> json) {
    return ProgramLog(
      id: json['id'] ?? const Uuid().v4(),
      programName: json['programName'] ?? '',
      farmer: json['farmer'] ?? '',
      resource: json['resource'] ?? '',
      impact: json['impact'] ?? '',
      region: json['region'] ?? '',
      officer: json['officer'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    );
  }

  /// 🔹 Serialize to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'programName': programName,
        'farmer': farmer,
        'resource': resource,
        'impact': impact,
        'region': region,
        'officer': officer,
        'date': date.toIso8601String(),
      };

  /// 🔹 Useful for editing logs
  ProgramLog copyWith({
    String? id,
    String? programName,
    String? farmer,
    String? resource,
    String? impact,
    String? region,
    String? officer,
    DateTime? date,
  }) {
    return ProgramLog(
      id: id ?? this.id,
      programName: programName ?? this.programName,
      farmer: farmer ?? this.farmer,
      resource: resource ?? this.resource,
      impact: impact ?? this.impact,
      region: region ?? this.region,
      officer: officer ?? this.officer,
      date: date ?? this.date,
    );
  }

  @override
  String toString() =>
      'ProgramLog(id: $id, program: $programName, farmer: $farmer, date: $date)';
}
