class LogEntry {
  final String? result;
  final String? note;
  final String? cost;
  final String? category;
  final DateTime? timestamp;

  LogEntry({this.result, this.note, this.cost, this.category, this.timestamp});

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    DateTime? parsedTime;
    try {
      parsedTime = DateTime.tryParse(json['timestamp'] ?? '');
    } catch (_) {}

    return LogEntry(
      result: json['result'],
      note: json['note'],
      cost: json['cost'],
      category: json['category'] ?? 'Other',
      timestamp: parsedTime,
    );
  }

  String get timestampFormatted {
    if (timestamp == null) return 'Unknown';
    return '${timestamp!.toLocal()}'.split('.').first;
  }

  Map<String, dynamic> toJson() => {
        'result': result,
        'note': note,
        'cost': cost,
        'category': category,
        'timestamp': timestamp?.toIso8601String(),
      };
}
