import 'dart:convert';

/// 🧾 Represents an officer's assessment log for a field activity.
class OfficerAssessment {
  final String activity;
  final String impact;
  final String recommendation;
  final DateTime date;

  OfficerAssessment({
    required this.activity,
    required this.impact,
    required this.recommendation,
    required this.date,
  });

  /// 🆕 Factory for creating an empty default instance (used in forms or drafts).
  factory OfficerAssessment.empty() {
    return OfficerAssessment(
      activity: '',
      impact: '',
      recommendation: '',
      date: DateTime.now(),
    );
  }

  /// 🔁 Deserializes from a JSON map with null-safety and fallbacks.
  factory OfficerAssessment.fromJson(Map<String, dynamic> json) {
    return OfficerAssessment(
      activity: json['activity'] ?? '',
      impact: json['impact'] ?? '',
      recommendation: json['recommendation'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    );
  }

  /// 🔁 Serializes this object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'activity': activity,
      'impact': impact,
      'recommendation': recommendation,
      'date': date.toIso8601String(),
    };
  }

  /// 📄 Encodes this object as a JSON string.
  String toRawJson() => json.encode(toJson());

  /// 🔁 Decodes from a raw JSON string.
  factory OfficerAssessment.fromRawJson(String str) =>
      OfficerAssessment.fromJson(json.decode(str));

  /// 🔍 For logging and debugging.
  @override
  String toString() =>
      'OfficerAssessment(activity: $activity, impact: $impact, recommendation: $recommendation, date: $date)';
}
