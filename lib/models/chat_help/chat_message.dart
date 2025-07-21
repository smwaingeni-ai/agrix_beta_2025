import 'dart:convert';
import 'package:uuid/uuid.dart';

/// Represents a single chat message between user and system (bot).
class ChatMessage {
  final String id;               // Unique message ID
  final String sender;           // 'user' or 'bot'
  final String message;          // Message content
  final DateTime timestamp;      // Time the message was sent

  static const List<String> validSenders = ['user', 'bot'];

  ChatMessage({
    String? id,
    required this.sender,
    required this.message,
    DateTime? timestamp,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now() {
    assert(validSenders.contains(sender), 'Sender must be "user" or "bot"');
  }

  /// 🔹 Create an empty/default message (useful for testing or placeholder)
  factory ChatMessage.empty() => ChatMessage(
        sender: 'user',
        message: '',
      );

  /// 🔹 Factory method with automatic ID and timestamp
  factory ChatMessage.create({
    required String sender,
    required String message,
  }) {
    return ChatMessage(
      sender: sender,
      message: message,
    );
  }

  /// 🔹 Deserialize from JSON with fallbacks
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: (json['id'] != null && json['id'].toString().isNotEmpty)
          ? json['id']
          : const Uuid().v4(),
      sender: json['sender'] ?? 'user',
      message: json['message'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  /// 🔹 Serialize to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
      };

  /// 🔹 Helpful for debugging
  @override
  String toString() => jsonEncode(toJson());
}
