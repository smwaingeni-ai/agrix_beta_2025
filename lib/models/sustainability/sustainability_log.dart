import 'package:intl/intl.dart';

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

  /// 🔹 Empty instance for initialization/forms
  factory SustainabilityLog.empty() {
    return SustainabilityLog(
      id: '',
      activity: '',
      impact: '',
      region: '',
      date: DateTime.now(),
      recordedBy: '',
    );
  }

  /// 🔹 Create from JSON with fallback defaults
  factory SustainabilityLog.fromJson(Map<String, dynamic> json) {
    return SustainabilityLog(
      id: json['id'] ?? '',
      activity: json['activity'] ?? '',
      impact: json['impact'] ?? '',
      region: json['region'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      recordedBy: json['recordedBy'] ?? '',
    );
  }

  /// 🔹 Convert to JSON for storage/export
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

  /// 🔹 Display date in user-friendly format (e.g., in lists)
  String get formattedDate => DateFormat('yyyy-MM-dd').format(date);

  @override
  String toString() {
    return 'SustainabilityLog(id: $id, activity: $activity, impact: $impact, region: $region, date: $date, recordedBy: $recordedBy)';
  }
}
