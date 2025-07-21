import 'dart:convert';

class TrainingLog {
  final String id;
  final String title;
  final String facilitator;
  final String location;
  final int participants;
  final String region;
  final DateTime date;

  TrainingLog({
    required this.id,
    required this.title,
    required this.facilitator,
    required this.location,
    required this.participants,
    required this.region,
    required this.date,
  });

  /// 🔹 Empty default constructor for forms or drafts
  factory TrainingLog.empty() {
    return TrainingLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      facilitator: '',
      location: '',
      participants: 0,
      region: '',
      date: DateTime.now(),
    );
  }

  /// 🔹 Deserialize from JSON
  factory TrainingLog.fromJson(Map<String, dynamic> json) {
    return TrainingLog(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      facilitator: json['facilitator'] ?? '',
      location: json['location'] ?? '',
      participants: json['participants'] ?? 0,
      region: json['region'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    );
  }

  /// 🔹 Serialize to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'facilitator': facilitator,
        'location': location,
        'participants': participants,
        'region': region,
        'date': date.toIso8601String(),
      };

  /// 🔹 For logging/debugging
  @override
  String toString() {
    return 'TrainingLog(title: $title, facilitator: $facilitator, participants: $participants, region: $region, location: $location, date: $date)';
  }
}
