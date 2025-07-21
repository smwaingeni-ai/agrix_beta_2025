import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class SustainabilityLog {
  final String id;
  final String activity;
  final String impact;
  final String region;
  final DateTime date;
  final String recordedBy;

  SustainabilityLog({
    required this.id,
    required this.activity,
    required this.impact,
    required this.region,
    required this.date,
    required this.recordedBy,
  });

  /// 🔹 Empty instance for new entries with auto-generated UUID
  factory SustainabilityLog.empty() {
    return SustainabilityLog(
      id: const Uuid().v4(), // ✅ Automatically generates a unique ID
      activity: '',
      impact: '',
      region: '',
      date: DateTime.now(),
      recordedBy: '',
    );
  }

  /// 🔹 Deserialize from JSON with fallback values
  factory SustainabilityLog.fromJson(Map<String, dynamic> json) {
    return SustainabilityLog(
      id: json['id'] ?? const Uuid().v4(),
      activity: json['activity'] ?? '',
      impact: json['impact'] ?? '',
      region: json['region'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      recordedBy: json['recordedBy'] ?? '',
    );
  }

  /// 🔹 Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity': activity,
      'impact': impact,
      'region': region,
      'date': date.toIso8601String(),
      'recordedBy': recordedBy,
    };
  }

  /// 🔹 Formatted date for display
  String get formattedDate => DateFormat('yyyy-MM-dd').format(date);

  /// 🔹 Copy with updated fields (immutability)
  SustainabilityLog copyWith({
    String? id,
    String? activity,
    String? impact,
    String? region,
    DateTime? date,
    String? recordedBy,
  }) {
    return SustainabilityLog(
      id: id ?? this.id,
      activity: activity ?? this.activity,
      impact: impact ?? this.impact,
      region: region ?? this.region,
      date: date ?? this.date,
      recordedBy: recordedBy ?? this.recordedBy,
    );
  }

  @override
  String toString() {
    return 'SustainabilityLog(id: $id, activity: $activity, impact: $impact, region: $region, date: $date, recordedBy: $recordedBy)';
  }
}
