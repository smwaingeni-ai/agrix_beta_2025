import 'dart:convert';

class NotificationMessage {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final String source; // e.g., 'Govt', 'System', 'Officer', 'Partner'

  NotificationMessage({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.source,
  });

  /// 🔹 Factory for empty placeholder (e.g., during init)
  factory NotificationMessage.empty() {
    return NotificationMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      body: '',
      date: DateTime.now(),
      source: 'System',
    );
  }

  /// 🔹 Deserialize from JSON
  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    return NotificationMessage(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      source: json['source'] ?? 'System',
    );
  }

  /// 🔹 Serialize to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'date': date.toIso8601String(),
        'source': source,
      };

  /// 🔹 Optional: Pretty-print for logging/debugging
  @override
  String toString() {
    return 'NotificationMessage(title: $title, source: $source, date: $date)';
  }
}
