class OfficerAssessment {
  final String activity;           // What was assessed (e.g. training, program)
  final String impact;             // What was the observed effect
  final String recommendation;     // What the officer suggests going forward
  final DateTime date;             // When the assessment was made
  final String officerId;          // Who made the assessment
  final String region;             // Where it was conducted

  OfficerAssessment({
    required this.activity,
    required this.impact,
    required this.recommendation,
    required this.date,
    required this.officerId,
    required this.region,
  });

  /// 🔹 Empty factory for form initialization or test data
  factory OfficerAssessment.empty() {
    return OfficerAssessment(
      activity: '',
      impact: '',
      recommendation: '',
      date: DateTime.now(),
      officerId: '',
      region: '',
    );
  }

  /// 🔹 Create instance from JSON map
  factory OfficerAssessment.fromJson(Map<String, dynamic> json) {
    return OfficerAssessment(
      activity: json['activity'] ?? '',
      impact: json['impact'] ?? '',
      recommendation: json['recommendation'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      officerId: json['officerId'] ?? '',
      region: json['region'] ?? '',
    );
  }

  /// 🔹 Convert instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'activity': activity,
      'impact': impact,
      'recommendation': recommendation,
      'date': date.toIso8601String(),
      'officerId': officerId,
      'region': region,
    };
  }

  @override
  String toString() {
    return 'OfficerAssessment(activity: $activity, officerId: $officerId, date: $date)';
  }
}
